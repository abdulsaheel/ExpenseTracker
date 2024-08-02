import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'messages_page.dart';
import 'permission_request_page.dart';
import 'notification_service.dart';
import 'background_service.dart';
// import 'package:telephony/telephony.dart';
import 'sms_service.dart';
import 'latest_message.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
  await initializeBackgroundService();
  setupTelephony();
  getPermissions();
  fetchMessages();
  runApp(MyApp());
}

void getPermissions() async {
  bool? permissionStatus = await telephony.requestSmsPermissions;
  if (permissionStatus == true) {
    print('Permission granted');
  } else {
    print('Permission not granted');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => PermissionRequestPage(),
        '/dashboard': (context) => DashboardPage(),
        '/messages': (context) => MessagesPage(),
      },
    );
  }
}
