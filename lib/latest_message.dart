import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';

Future<List<SmsMessage>> fetchMessages() async {
  SmsQuery query = SmsQuery();
  List<SmsMessage> messages = await query.getAllSms;
  print(
      "${messages.first.body},${messages.first.id},${messages.first.dateSent},${messages.first.date.toString()}");
  return messages;
}
