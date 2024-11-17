import 'package:dadding/firebase_options.dart';
import 'package:dadding/pages/main/ChatPage.dart';
import 'package:dadding/pages/MainPage.dart';
import 'package:dadding/pages/main/LoginPage.dart';
import 'package:dadding/pages/main/PostPage.dart';
import 'package:dadding/pages/main/ProfilePage.dart';
import 'package:dadding/pages/post/CreatePostPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/route_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: 'assets/config/.env');
  
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: [
        GetPage(name: '/', page: () => const MainPage()),
        GetPage(name: '/post', page: () => const PostPage()),
        GetPage(name: '/chat', page: () => const ChatPage()),
        GetPage(name: '/profile', page: () => const ProfilePage()),
        GetPage(name: '/create-post', page: () => const CreatePostPage()),
        GetPage(name: '/login', page: () => const LoginPage()),
      ],
      initialRoute: FirebaseAuth.instance.currentUser == null ? '/login' : '/',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
      ],
      locale: const Locale('ko'),
      debugShowCheckedModeBanner: false,
    );
  }
}


