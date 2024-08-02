import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

Future<String> addTransactiontemp(int messageId, String amount, String type,
    String bank, String dateTime) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  try {
    // Load existing transactions from SharedPreferences
    final String? tempTransactionsJson = prefs.getString('temp_transactions');
    List<Map<String, dynamic>> tempTransactions = [];
    if (tempTransactionsJson != null && tempTransactionsJson.isNotEmpty) {
      tempTransactions =
          jsonDecode(tempTransactionsJson).cast<Map<String, dynamic>>();
    }

    // Generate a unique ID for the new transaction
    int id =
        DateTime.now().millisecondsSinceEpoch; // Example: Generate unique ID

    // Add the new transaction to the existing list
    tempTransactions.add({
      'id': id,
      'messageId': messageId,
      'amount': amount,
      'type': type,
      'bank': bank,
      'dateTime': dateTime,
    });

    // Save the updated transactions list back to SharedPreferences
    await prefs.setString('temp_transactions', jsonEncode(tempTransactions));

    // Return success message
    return 'Transaction added successfully!';
  } catch (e) {
    // Handle exceptions here
    print('Error adding transaction: $e');
    return 'Failed to add transaction. Please try again later.';
  }
}

Future<String> addTransaction(int messageId, String amount, String type,
    String bank, String dateTime) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Load existing transactions from SharedPreferences
  final String? TransactionsJson = prefs.getString('transactions');
  List<Map<String, dynamic>> Transactions = [];
  if (TransactionsJson != null && TransactionsJson.isNotEmpty) {
    Transactions = jsonDecode(TransactionsJson).cast<Map<String, dynamic>>();
  }

  // Add the new transaction to the existing list
  Transactions.add({
    'id': messageId, // You can generate a unique ID here
    'amount': amount,
    'type': type,
    'bank': bank,
    'dateTime': dateTime,
  });

  // Save the updated transactions list back to SharedPreferences
  await prefs.setString('transactions', jsonEncode(Transactions));

  // Return success message
  return 'Transaction added successfully!';
}

Future<Map<String, dynamic>?> gettempTransaction() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  try {
    // Load temp transactions from SharedPreferences
    final String? tempTransactionsJson = prefs.getString('temp_transactions');
    if (tempTransactionsJson != null && tempTransactionsJson.isNotEmpty) {
      List<Map<String, dynamic>> tempTransactions =
          jsonDecode(tempTransactionsJson).cast<Map<String, dynamic>>();

      // Find transaction by id
      for (var transaction in tempTransactions) {
        if (transaction['id'] == 7869) {
          return transaction;
        }
      }
    }
  } catch (e) {
    // Handle exceptions here
    print('Error getting transaction: $e');
  }

  return null; // Return null if transaction with given id is not found or on error
}
