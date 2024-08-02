import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'message_regex.dart';

class MessagesPage extends StatefulWidget {
  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  late Future<List<SmsMessage>> _messagesFuture;
  List<Map<String, dynamic>> _transactions = [];

  @override
  void initState() {
    super.initState();
    _messagesFuture = _fetchMessages();
    _loadTransactionsFromStorage();
  }

  Future<void> _loadTransactionsFromStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? transactionsJson = prefs.getString('transactions');
    if (transactionsJson != null && transactionsJson.isNotEmpty) {
      setState(() {
        _transactions =
            jsonDecode(transactionsJson).cast<Map<String, dynamic>>();
      });
    }
  }

  Future<List<SmsMessage>> _fetchMessages() async {
    SmsQuery query = SmsQuery();
    List<SmsMessage> messages = await query.getAllSms;
    return messages;
  }

  Future<void> _saveTransaction(int messageId, String amount, String type,
      String bank, String dateTime) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Load existing transactions from SharedPreferences
    final String? transactionsJson = prefs.getString('transactions');
    List<Map<String, dynamic>> existingTransactions = [];
    if (transactionsJson != null && transactionsJson.isNotEmpty) {
      existingTransactions =
          jsonDecode(transactionsJson).cast<Map<String, dynamic>>();
    }

    // Add the new transaction to the existing list
    existingTransactions.add({
      'id': messageId, // You can generate a unique ID here
      'amount': amount,
      'type': type,
      'bank': bank,
      'dateTime': dateTime,
    });

    // Save the updated transactions list back to SharedPreferences
    await prefs.setString('transactions', jsonEncode(existingTransactions));

    setState(() {
      _transactions = existingTransactions;
    }); // Update the UI after saving
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
      ),
      body: FutureBuilder<List<SmsMessage>>(
        future: _messagesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error fetching messages: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No messages found.'));
          } else {
            List<SmsMessage> messages = snapshot.data!;
            List<List<String?>> parsedMessages = [];

            // Parse each message using the transaction parser
            messages.forEach((message) {
              List<String?> parsed = parseTransactionMessage(message.body!);
              if (parsed.every((element) => element != null)) {
                parsedMessages.add(parsed);
              }
            });

            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: parsedMessages.length,
              itemBuilder: (context, index) {
                List<String?> parsedMessage = parsedMessages[index];
                String transactionType = parsedMessage[0] ?? '';
                String amount = parsedMessage[1] ?? '';
                String bank = parsedMessage[2] ?? '';
                int? messageId = messages[index].id;
                DateTime smsDateTime = messages[index].date ?? DateTime.now();
                String formattedDate =
                    '${smsDateTime.day}/${smsDateTime.month}/${smsDateTime.year}';

                bool isCredit =
                    transactionType.toLowerCase().contains('credit');

                // Check if this transaction ID is already in _transactions
                bool isTransactionAdded = _transactions
                    .any((transaction) => transaction['id'] == messageId);

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Icon(
                      isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                      color: isCredit ? Colors.green : Colors.red,
                      size: 28,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${isCredit ? 'Credited' : 'Debited'}: Rs. $amount',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Bank: $bank',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      'Date: $formattedDate',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(isTransactionAdded ? Icons.check : Icons.add),
                      onPressed: isTransactionAdded
                          ? null
                          : () {
                              _saveTransaction(
                                  messageId!,
                                  amount,
                                  isCredit ? 'credited' : 'debited',
                                  bank,
                                  formattedDate);
                            },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
