// import 'package:dark/onboarding2.dart';
// import 'package:dark/onboarding3.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'onboarding1.dart';
// import 'theme_provider.dart';
// void main() {
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider<ThemeProvider>(
//           create: (context) => ThemeProvider(),
//         ),
//         ChangeNotifierProvider<PageIndex>(
//           create: (context) => PageIndex(),
//         ),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Theme Example',
//       theme: ThemeData.light(),
//       darkTheme: ThemeData.dark(),
//       themeMode: Provider.of<ThemeProvider>(context).isDarkModeEnabled
//           ? ThemeMode.dark
//           : ThemeMode.light,
//       onGenerateRoute: (settings) {
//         if (settings.name == '/second') {
//           return MaterialPageRoute(
//             builder: (context) => const OnboardingScreen2(),
//           );
//         } else if (settings.name == '/third') {
//           return MaterialPageRoute(
//             builder: (context) => const OnboardingScreen3(),
//           );
//         }
        
//         return null;
//       },
//       home: const OnboardingScreen(),
//     );
//   }
// }


// class PageIndex extends ChangeNotifier {
//   int _index = 0;

//   int get index => _index;

//   void incrementIndex() {
//     _index++;
//     notifyListeners();
//   }

//   void setPageIndex(int newIndex) {
//     _index = newIndex;
//     notifyListeners();
//   }
// }
import 'package:dark/auth/authscreen.dart';
import 'package:dark/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        // colorScheme: ColorScheme.fromSwatch().copyWith(
        //   primary: Colors.deepOrange,
        //   secondary: Colors.deepOrange,
        // ),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Waiting for the authentication state to be determined
            return CircularProgressIndicator();
          } else if (snapshot.hasData) {
            // User is authenticated
            return HomeScreen();
          } else {
            // User is not authenticated
            return authscreen();
          }
        },
      ),
    );
  }
}
