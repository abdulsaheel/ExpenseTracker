import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionRequestPage extends StatefulWidget {
  @override
  _PermissionRequestPageState createState() => _PermissionRequestPageState();
}

class _PermissionRequestPageState extends State<PermissionRequestPage> {
  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    if (await Permission.sms.isGranted) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  Future<void> _requestPermission() async {
    if (await Permission.sms.request().isGranted) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SMS Permission Required'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'This app needs SMS permission to operate.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _requestPermission,
              child: Text('Grant Permission'),
            ),
          ],
        ),
      ),
    );
  }
}
