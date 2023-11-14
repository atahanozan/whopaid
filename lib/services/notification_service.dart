import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whopayed/main.dart';
import 'package:http/http.dart' as http;

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  // ignore: avoid_print
  print("Title: ${message.notification?.title}");
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

class FirebaseApi {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  var serviceAccountJson = {
    "type": "service_account",
    "project_id": "whopayed",
    "private_key_id": "8159dacea141dde675c75ec3824d3ef5491113af",
    "private_key":
        "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDG/hY4IDVAgNgO\nbniL6k9YCKb84TG/ZXKBn3wG8Jd7rElVIineMAzviH/QI/diNb3lMFrI2mNQLqkI\ng8AVm+GmLrQFp89gT37ZVITsBvNvDjT+4nagA4+zwFxJy85fkN5sHj4NYb6rIVSI\n1FG3vM7XCtyBVW2GjPqnB+c6JtjeETUNZ7b51/YA5XtdIWi/xwamVGTI5M5+1zPo\nOPN74ZwQ6bciBNg5586RcJBLeHQdH8kW7r3NWukQXyn4x047W0g2GPpijN596BXy\n6j9wuO6M8PuuiZEmHLRIGKDE3V456A1dJVcVewHidUwJxxTSqu2kJgEEjO0n5uHW\nRx6rdVPDAgMBAAECggEAT4FITl9r91wjNszjg/93eRRn56Rv9GkrcWfPrZQl6gdB\ne269bKUlHfUbIAWmuwn+15nUw+ghgvFJnvnI3rlb1EJXseTEwdWxOFMBEq6KR6ZU\n/TttKuyRVz+1f9SanWsruuXwY/dYL1aPSGYQSkl5GMkhpdkEfBxKrz7En2LTBhIE\nkHBhghrAQuErXFTu+Rcg554W+GrJYeDr3wc6TlZ07QiXjWx6SDOKk9AZwLsXfAxe\nDExVE973yDJY65JhX7EeL6/6TxaIVFEYdJYqEiqirJ26JSUZxC3d+3ywsgod+0sF\nA9GTfNDzT3LLz2blhN9nd3hJhW2ymEiiLuI1J3mmlQKBgQDlEM1Z7qxlkzc6xG5a\nZCRVatnyOqlL8WqquBM2Lxx1HRY9ns6eOJyDpkpRQxhq3MdSZKe8P1+emTIOpBrP\njeJUIyS7r4LgqOUfuBJix8sIVgo/Ag4ZIBNlLfLOWDbrc1DhZpiw1wZtHUzvpikc\nOPAETFBCDQ5QU3j9xXIZ/xRsDwKBgQDeZAq0Omn1+8HpPHAhje5f19keur0c5ZQE\nV3u6UnyqIKcE0Rkkv6PQUbc/9VEcGsAbN+cSmnORc/4akGbvAJb+ZnS3eKOV4wl+\ntPz6WoW9MsvI5p9Ut4cNKgJFlnPfdIx2kPzENzngD+Uq32naFGUrtYc4D1BFPWZ4\ne2AmtFu5DQKBgB/GY+X8wLdaY4foZbJuP8gFiXQbhQ5+z6Ac5rVWdakdPs+PbvPt\nwHBWqep51zJDq/aW9dmcJOR4NcRoKTvvX5zyPw81+n61jwsGWq6PLm/al5ND8raz\nh106sXrEK+IfXfHWbInjWgXa0ahQsVUz5L+D4oI3E2w7GAaD1B8dDjUrAoGBAKaX\n/sTANXxFmh9kXQNl1ToK8eTpMp2hBV6zQkZzYFv5leQv10wGG2sEq+fHl3kcOOiq\n2fi/pu9BGws/PTyxDmuIyMpgHvs7VnOKlS/d++2dTbczvAu0aADehVEnwamVH1v6\nhL9gN4S3o46YSi1JtfgmRiMipZkYw9hhY8fauBNJAoGBANk2aHglrELRX3O4Rev9\nSDmBZoMHbjrtyFhL+0rM8hgy0wx042w61DSbUJS0+almO6tMIsfK5F/FYoI7AaCD\nQiA60oXXqDRYCVwsjldAU0mg8x8zJlvirTRaHdDD/GfQNoVoZIvnluLRPqI++0Ga\n+vZqnt+yKaJZ0ipImilyViMi\n-----END PRIVATE KEY-----\n",
    "client_email": "firebase-adminsdk-fscst@whopayed.iam.gserviceaccount.com",
    "client_id": "108543158506722020351",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url":
        "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fscst%40whopayed.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com"
  };

  Future<bool> sendNotification(Map<String, dynamic> notification) async {
    final accountCredential =
        ServiceAccountCredentials.fromJson(serviceAccountJson);

    List<String> scopes = ["https://www.googleapis.com/auth/cloud-platform"];
    try {
      try {
        clientViaServiceAccount(accountCredential, scopes).then((client) async {
          Uri urlC = Uri.https(
              "fcm.googleapis.com", "/v1/projects/whopayed/messages:send");
          http.Response responseC = await client.post(
            urlC,
            headers: {
              "Authorization": "Bearer ${client.credentials.accessToken}"
            },
            body: json.encode(notification),
          );
          // ignore: avoid_print
          print("sonuç ${responseC.body}");
          client.close();
        });
      } catch (e) {
        print("ilk hata $e");
      }
    } catch (err) {
      print("ilk hata $err");
    }
    return true;
  }

  final _androidChannel = const AndroidNotificationChannel(
    "high_importance_channel",
    "High Importance Notifications",
    description: "This channel is used for importance notifications",
    importance: Importance.defaultImportance,
  );
  final _localNotifications = FlutterLocalNotificationsPlugin();

  void handleMessage(RemoteMessage? message) {
    if (message != null) {
      navigatorKey.currentState?.pushNamed("/home");
    } else {
      return;
    }
  }

  Future initLocalNotifications() async {
    const iOS = DarwinInitializationSettings();
    const android = AndroidInitializationSettings("@drawable/ic_launcher");
    const settings = InitializationSettings(android: android, iOS: iOS);

    await _localNotifications.initialize(
      settings,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      onDidReceiveNotificationResponse: (notificationResponse) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            final message = RemoteMessage.fromMap(
                jsonDecode(notificationResponse.payload.toString()));
            handleMessage(message);
            break;
          case NotificationResponseType.selectedNotificationAction:
            final message = RemoteMessage.fromMap(
                jsonDecode(notificationResponse.payload.toString()));
            handleMessage(message);
            break;
        }
      },
    );

    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;

      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: '@drawable/ic_launcher',
          ),
        ),
        payload: jsonEncode(message.toMap()),
      );
    });
  }

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    setfCMToken(fCMToken);

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    initPushNotifications();
    initLocalNotifications();
  }

  Future<void> setfCMToken(String? fCMToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("fCMToken", fCMToken.toString());
  }
}
