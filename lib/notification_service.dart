import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:expense_tracker/time_difference.dart';
import 'dart:async';
import 'package:flutter/material.dart';

final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();

Future<void> showTransactionNotification(
    String amount, String transaction_type, String bank) async {
  String body = "₹ $amount $transaction_type from/to $bank";
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 7869,
      channelKey: 'transaction_sms_detector',
      title: 'New Transaction',
      body: body,
      notificationLayout: NotificationLayout.Default,
    ),
    actionButtons: [
      NotificationActionButton(
        key: 'ADD',
        label: 'Add transaction',
      ),
      NotificationActionButton(
        key: 'IGNORE',
        label: 'Ignore',
      ),
    ],
  );
}

void listenToNotificationActions() {
  AwesomeNotifications().setListeners(
    onActionReceivedMethod: onActionReceivedMethod,
  );
}

@pragma('vm:entry-point')
Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
  if (receivedAction.id == 7869) {
    if (receivedAction.buttonKeyPressed == 'ADD') {
      print('User chose to add the transaction');

      onAddTransactionClicked();
    } else if (receivedAction.buttonKeyPressed == 'IGNORE') {
      print('User chose to ignore the transaction');
    }
  }
}

Future<void> initializeService() async {
  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'transaction_sms_detector',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white,
      )
    ],
    debug: true,
  );
  listenToNotificationActions();
}
