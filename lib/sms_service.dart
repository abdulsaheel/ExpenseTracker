import 'package:expense_tracker/notification_service.dart';
import 'package:expense_tracker/variables.dart';
import 'package:telephony/telephony.dart';
import 'message_regex.dart';
import 'package:intl/intl.dart';

String formatTimestamp(int timestampMs) {
  // Convert milliseconds to seconds
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestampMs);

  // Define the desired format
  DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');

  // Format the DateTime object
  String formattedDate = formatter.format(dateTime);

  return formattedDate;
}

final Telephony telephony = Telephony.instance;

void setupTelephony() {
  telephony.listenIncomingSms(
    onNewMessage: (SmsMessage message) {
      // Handle incoming message
      String dateTime = message.date.toString();
      print("Date Time : ${dateTime}");
      List<String?> transactionData = parseTransactionMessage(message.body!);
      message_datetime = dateTime;
      // Check if all values are not null before printing
      if (transactionData.isNotEmpty) {
        String amount = transactionData[1] ?? "";
        String transactionType = transactionData[0] ?? "";
        String bank = transactionData[2] ?? "";
      }
    },
    listenInBackground:
        true, // Set to true if you want to listen in the background
    onBackgroundMessage: backgroundMessageHandler,
  );
}

void backgroundMessageHandler(SmsMessage message) async {
  ;

  print("Date Time : ${formatTimestamp(message.date!)}");

  // Handle background message
  print("Message received in background");
  print(message.body);
  List<String?> transactionData = parseTransactionMessage(message.body!);
  print("Thread ID: ${message.threadId}");

  // Check if all values are not null before printing
  if (transactionData.every((value) => value != null)) {
    String amount = transactionData[1] ?? "";
    String transactionType = transactionData[0] ?? "";
    String bank = transactionData[2] ?? "";

    // Print formatted message
    print("₹ $amount $transactionType from/to $bank");
    // showTransactionNotificationandaddtodb(
    //     amount, transactionType, bank, message.id!, message.date as String);
    print(
        "$amount, $transactionType, $bank,${message.threadId},${message.date}");
    showTransactionNotification(amount, transactionType, bank);
  }

  // You can also call other plugins or perform background tasks here
}
