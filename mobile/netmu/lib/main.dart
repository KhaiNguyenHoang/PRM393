import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:netmu/core/utils/api/token_storage.dart';
import 'package:netmu/core/utils/logger/logger.dart';
import 'package:netmu/features/notifications/widgets/notification_badge.dart';
import 'package:netmu/features/auth/screens/login_screen.dart';
import 'package:netmu/features/auth/screens/register_screen.dart';
import 'package:netmu/features/home/splash_screen.dart';
import 'package:netmu/features/home/main_screen.dart';
import 'package:netmu/features/settings/services/locale_provider.dart';
import 'package:netmu/firebase_options.dart';
import 'package:netmu/l10n/app_localizations.dart';
import 'package:netmu/l10n/l10n.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> main() async {
  // Load .env
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    NetmuLog.logger.e("Error loading .env file: $e");
    return;
  }

  // Get token storage
  final storage = SecureTokenStorage();

  // Check if user is logged in
  var isLoggedIn = await storage.getAccessToken() != null;
  NetmuLog.logger.i("Is user logged in: $isLoggedIn");

  // Register Firebase Cloud Messaging
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  await messaging.requestPermission();

  // Show badge when a notification arrives while app is in foreground
  FirebaseMessaging.onMessage.listen((_) {
    NotificationBadgeNotifier.instance.show();
  });

  // Load saved locale before running app
  await LocaleProvider.instance.loadInitial();

  // Run app
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LocaleProvider.instance,
      builder: (context, _) {
        return MaterialApp(
          title: 'Netmu',
          initialRoute: "/",
          routes: {
            "/": (context) => isLoggedIn ? HomePage() : WelcomeScreen(),
            "/auth/register": (context) => RegisterScreen(),
            "/auth/login": (context) => LoginScreen(),
            "/main": (context) => HomePage(),
          },
          supportedLocales: L10n.all,
          locale: LocaleProvider.instance.locale,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
        );
      },
    );
  }
}
