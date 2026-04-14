import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../services/fcm_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FCMService _fcmService = FCMService();

  String statusText = 'Waiting for a cloud message';
  String imagePath = 'assets/images/default.png';
  String tokenText = 'No token yet';

  @override
  void initState() {
    super.initState();

    _fcmService.initialize(
      onData: (RemoteMessage message) {
        debugPrint('Received message: ${message.data}');

        if (!mounted) return;

        setState(() {
          statusText = message.notification?.title ??
              message.data['title'] ??
              'Payload received';

          final assetName =
              (message.data['asset'] ?? 'default').toString();

          imagePath = 'assets/images/$assetName.png';
        });
      },
      onToken: (String token) {
        if (!mounted) return;

        setState(() {
          tokenText = token;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FCM Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              statusText,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 20),

            Image.asset(
              imagePath,
              height: 180,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/default.png',
                  height: 180,
                );
              },
            ),

            const SizedBox(height: 20),

            const Text('Device Token:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            Text(
              tokenText,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}