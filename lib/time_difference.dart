import 'package:expense_tracker/message_regex.dart';
import 'package:expense_tracker/variables.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'local_storage.dart';
import 'latest_message.dart';

bool isTimestampMatch(
    DateTime messageTimestamp, DateTime receivedTime, Duration tolerance) {
  Duration difference = receivedTime.difference(messageTimestamp).abs();
  return difference <= tolerance;
}

Future<bool> onAddTransactionClicked() async {
  List<SmsMessage> messages = await fetchMessages();
  SmsMessage latestMessage = messages.last;
  print(message_datetime);
  DateTime receivedTime =
      message_datetime as DateTime; // Use the actual received time if available
  Duration tolerance = Duration(milliseconds: 1600); // 1.6 seconds tolerance
  DateTime smsDateTime = latestMessage.date ?? DateTime.now();
  String formattedDate =
      '${smsDateTime.day}/${smsDateTime.month}/${smsDateTime.year}';
  if (isTimestampMatch(latestMessage.dateSent!, receivedTime, tolerance)) {
    List<String?> transactionData =
        parseTransactionMessage(latestMessage.body!);

    String amount = transactionData[1] ?? "";
    String transactionType = transactionData[0] ?? "";
    String bank = transactionData[2] ?? "";
    print(messages.last.dateSent);
    addTransaction(
        latestMessage.id!, amount, transactionType, bank, formattedDate);
    print('Transaction added successfully!');
    return true;
    // Track as processed
  } else {
    print('Timestamp mismatch or no valid payment message found.');
    return false;
  }
}
