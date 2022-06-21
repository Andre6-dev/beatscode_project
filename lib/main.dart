import 'package:beatscode_project/providers/user_provider.dart';
import 'package:beatscode_project/responsive/mobile_screen_layout.dart';
import 'package:beatscode_project/responsive/responsive_layout_screen.dart';
import 'package:beatscode_project/responsive/web_screen_layout.dart';
import 'package:beatscode_project/screens/login_screen.dart';
import 'package:beatscode_project/screens/signup_screen.dart';
import 'package:beatscode_project/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyA3CuxBZrgRvjRc4pQ3vPdCxs8_IGZXKbI",
        appId: "1:768813693004:web:bdcc195cb2c14db8d61ce9",
        messagingSenderId: "768813693004",
        projectId: "beatscodefinalproject",
        storageBucket: "beatscodefinalproject.appspot.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BeatsCode Project',
        theme: ThemeData.dark()
            .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
        /*home: ResponsiveLayout(
          webScreenLayout: WebScreenLayout(),
          mobileScreenLayout: MobileScreenLayout(),
        ),*/
        home: StreamBuilder(
          // this method only runs when the user has signed in or signed out
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveLayout(
                  webScreenLayout: WebScreenLayout(),
                  mobileScreenLayout: MobileScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            }

            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
