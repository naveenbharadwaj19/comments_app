import 'package:comments_app/providers/auth_provider.dart';
import 'package:comments_app/providers/comment_provider.dart';
import 'package:comments_app/screens/comment_screen.dart';
import 'package:comments_app/services/firebase/firebase_auth_service.dart';
import 'package:comments_app/services/firebase/firebase_remote_config_service.dart';
import 'package:comments_app/utlis/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'screens/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthService>(create: (_) => FirebaseAuthService()),
        Provider<FirebaseRemoteConfigService>(
            create: (_) => FirebaseRemoteConfigService()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CommentProvider()),
      ],
      child: MaterialApp(
        title: "Comments App",
        theme: themeData,
        home: AuthScreen(),
        routes: {
          "/auth": (context) => AuthScreen(),
          "/comment": (context) => CommentScreen(),
        },
      ),
    );
  }
}
