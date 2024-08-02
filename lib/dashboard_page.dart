import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class AddTransactionPopup extends StatefulWidget {
  final Function(int, String, String, String, String) onTransactionAdded;

  const AddTransactionPopup({Key? key, required this.onTransactionAdded})
      : super(key: key);

  @override
  _AddTransactionPopupState createState() => _AddTransactionPopupState();
}

class _AddTransactionPopupState extends State<AddTransactionPopup> {
  int _id = DateTime.now().millisecondsSinceEpoch;
  String _amount = '';
  String _type = 'credited';
  String _bank = 'Bank of Baroda';
  DateTime? _selectedDate;

  final TextEditingController _dateTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Transaction'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _amount = value;
                });
              },
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _type,
              decoration: InputDecoration(labelText: 'Type'),
              items: <String>['credited', 'debited'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _type = value ?? 'credited';
                });
              },
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _bank,
              decoration: InputDecoration(labelText: 'Bank'),
              items: <String>['Bank of Baroda', 'BOB', 'Federal Bank', 'Other']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _bank = value ?? 'Bank of Baroda';
                });
              },
            ),
            SizedBox(height: 16),
            if (_bank == 'Other')
              TextField(
                decoration: InputDecoration(labelText: 'Other Bank'),
                onChanged: (value) {
                  setState(() {
                    _bank = value;
                  });
                },
              ),
            SizedBox(height: 16),
            TextFormField(
              controller: _dateTimeController,
              decoration: InputDecoration(labelText: 'Date (dd/mm/yyyy)'),
              readOnly: true,
              onTap: () {
                _pickDate(context);
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Add'),
          onPressed: () async {
            String formattedDate = _selectedDate != null
                ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                : '';
            await widget.onTransactionAdded(
                _id, _amount, _type, _bank, formattedDate);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dateTimeController.text =
            '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}';
      });
    }
  }
}

class _DashboardPageState extends State<DashboardPage> {
  List<Map<String, dynamic>> _transactions = [];

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final SharedPreferences prefs = await _prefs;
    final String transactionsJson = prefs.getString('transactions') ?? '[]';
    setState(() {
      _transactions =
          List<Map<String, dynamic>>.from(jsonDecode(transactionsJson));
    });
  }

  double _calculateCurrentBalance(List<Map<String, dynamic>> transactions) {
    double balance = 0.0;
    transactions.forEach((transaction) {
      double amount = double.parse('${transaction['amount']}');
      if (transaction['type'] == 'credited') {
        balance += amount;
      } else {
        balance -= amount;
      }
    });
    return balance;
  }

  Future<void> _refreshTransactions() async {
    await _loadTransactions();
    setState(() {
      // Update UI if necessary
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTitle(),
            _buildChart(),
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text('Transactions',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: _buildTransactionList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTransactionDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.only(top: 44, left: 16),
      color: Colors.blue.withOpacity(0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Dashboard',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          IconButton(
            icon: Icon(Icons.receipt_long),
            onPressed: () {
              Navigator.pushNamed(context, '/messages');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    List<Map<String, dynamic>> chartData = [];

    _transactions.forEach((transaction) {
      double amount = double.parse('${transaction['amount']}');
      bool isCredit = transaction['type'] == 'credited';

      // Assuming transaction['dateTime'] is in format '28/6/2024'
      DateTime dateTime = _parseDate(transaction['dateTime']);

      chartData.add({
        'dateTime': dateTime,
        'amount': isCredit ? amount : -amount,
      });
    });

    // Sort chartData by dateTime
    chartData.sort((a, b) => a['dateTime'].compareTo(b['dateTime']));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Text(
            'Current Balance: ₹ ${_calculateCurrentBalance(_transactions).toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Transactions Over Time',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: _refreshTransactions,
              ),
            ],
          ),
        ),
        Container(
          height: 300,
          padding: EdgeInsets.all(16),
          child: SfCartesianChart(
            primaryXAxis: DateTimeAxis(),
            series: <CartesianSeries>[
              LineSeries<Map<String, dynamic>, DateTime>(
                dataSource: chartData,
                xValueMapper: (data, _) => data['dateTime'],
                yValueMapper: (data, _) => data['amount'],
                dataLabelSettings: DataLabelSettings(isVisible: true),
              ),
            ],
          ),
        ),
      ],
    );
  }

  DateTime _parseDate(String dateString) {
    // Example: '28/6/2024'
    List<String> parts = dateString.split('/');
    int day = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int year = int.parse(parts[2]);
    return DateTime(year, month, day);
  }

  Widget _buildTransactionList() {
    return _transactions.isEmpty
        ? Center(child: Text('No transactions found.'))
        : ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _transactions.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> transaction = _transactions[index];
              bool isCredit = transaction['type'] == 'credited';

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
                        '${isCredit ? 'Credited' : 'Debited'}: ₹ ${transaction['amount']}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Bank: ${transaction['bank']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    'Date: ${transaction['dateTime']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              );
            },
          );
  }

  void _showAddTransactionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddTransactionPopup(
          onTransactionAdded: (id, amount, type, bank, dateTime) async {
            await addTransaction(id, amount, type, bank, dateTime);
            _refreshTransactions();
          },
        );
      },
    );
  }
}

Future<String> addTransaction(
    int id, String amount, String type, String bank, String dateTime) async {
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
    'id': id,
    'amount': amount,
    'type': type,
    'bank': bank,
    'dateTime': dateTime,
  });

  // Save the updated transactions list back to SharedPreferences
  await prefs.setString('transactions', jsonEncode(existingTransactions));

  // Return success message
  return 'Transaction added successfully!';
}
