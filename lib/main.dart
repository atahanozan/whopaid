import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:whopayed/firebase_options.dart';
import 'package:whopayed/helper/themes_custom.dart';
import 'package:whopayed/model/darktheme_provider.dart';
import 'package:whopayed/pages/loginpages/commercial_page.dart';
import 'package:whopayed/pages/loginpages/forgot_password.dart';
import 'package:whopayed/pages/loginpages/login_page.dart';
import 'package:whopayed/pages/loginpages/registerw_email.dart';
import 'package:whopayed/pages/navigation_page.dart';
import 'package:whopayed/pages/splash_page.dart';
import 'package:whopayed/services/notification_service.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotification();
  await MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => themeChangeProvider,
        child: Consumer<DarkThemeProvider>(
          builder: (context, value, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Who Paid?',
              theme: ThemeClass.selectedTheme(
                  themeChangeProvider.darkTheme, context),
              routes: {
                "/": (context) => const SplashScreen(),
                "/register": (context) => const RegisterWithEmailPage(),
                "/login": (context) => const LoginPage(),
                "/home": (context) => const NavigationPage(),
                "/forgotpass": (context) => const ForgotPassword(),
                "/commercial": (context) => const CommercialPage(),
              },
            );
          },
        ));
  }
}
