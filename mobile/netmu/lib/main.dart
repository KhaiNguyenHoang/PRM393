import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:netmu/core/utils/api/token_storage.dart';
import 'package:netmu/core/utils/logger/logger.dart';
import 'package:netmu/features/home/splash_screen.dart';
import 'package:netmu/features/notifications/widgets/notification_badge.dart';
import 'package:netmu/features/auth/screens/login_screen.dart';
import 'package:netmu/features/auth/screens/register_screen.dart';
import 'package:netmu/features/home/main_screen.dart';
import 'package:netmu/features/settings/services/locale_provider.dart';
import 'package:netmu/l10n/app_localizations.dart';
import 'package:netmu/l10n/l10n.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    // await Firebase.initializeApp(); // Assuming options aren't strictly needed for background in this case, or can be skipped if missing
  } catch (e) {
    // Ignore
  }
}

Future<void> main() async {
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    NetmuLog.logger.e("Error loading .env file: $e");
  }

  final storage = SecureTokenStorage();
  var isLoggedIn = await storage.getAccessToken() != null;

  NetmuLog.logger.i("Is user logged in: $isLoggedIn");

  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(); // Assuming DefaultFirebaseOptions isn't imported, let it use default
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();
    FirebaseMessaging.onMessage.listen((_) {
      NotificationBadgeNotifier.instance.show();
    });
  } catch (e) {
    NetmuLog.logger.e("Firebase init failed: $e");
  }

  await LocaleProvider.instance.loadInitial();

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
            "/": (context) => isLoggedIn ? const HomePage() : const WelcomeScreen(),
            "/auth/register": (context) => RegisterScreen(),
            "/auth/login": (context) => LoginScreen(),
            "/main": (context) => const HomePage(),
          },
          supportedLocales: L10n.all,
          locale: LocaleProvider.instance.locale,
          localizationsDelegates: const [
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
