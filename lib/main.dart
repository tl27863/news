import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:news/providers/user_provider.dart';
import 'package:news/responsive/mobile_screen_layout.dart';
import 'package:news/responsive/responsive_layout.dart';
import 'package:news/responsive/web_screen_layout.dart';
import 'package:news/screens/login_screen.dart';
import 'package:news/screens/signup_screen.dart';
import 'package:news/utils/pallete.dart';
import 'package:news/resources/firebase_api.dart';
import 'package:provider/provider.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: apiKey, 
        appId: appId, 
        messagingSenderId: messagingSenderId, 
        projectId: projectId,
        storageBucket: storageBucket
      ),
    );
  }else{
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'News',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: primaryColor,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
                if(snapshot.hasData){
                  return const ResponsiveLayout(
                    webScreenLayout: WebScreenLayout(), 
                    mobileScreenLayout: MobileScreenLayout()
                  );                
                } else if(snapshot.hasError){
                  return Center(
                    child: Text('${snapshot.error}'),
                  );
                }
                break;
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(
                    color: secondaryColor,
                  ),
                );
              default:          
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}

