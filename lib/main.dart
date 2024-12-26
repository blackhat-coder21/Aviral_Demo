import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/login.dart';
import 'pages/home.dart';
import 'pages/score.dart';
import 'pages/creators.dart';
import 'utils/api.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF4F378B),
      ),
    );

    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      navigatorKey: navigationRef, // Navigation reference
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (_) => const SplashScreenWidget(),
            );
          case '/login':
            return MaterialPageRoute(
              builder: (_) => const Login(),
            );
          case '/home':
            return MaterialPageRoute(
              builder: (_) => const Home(),
            );
          case '/score':
            return MaterialPageRoute(
              builder: (_) => const Score(),
            );
          case '/creators':
            return MaterialPageRoute(
              builder: (_) => const Creators(),
            );
          default:
            return null;
        }
      },
    );
  }
}

class SplashScreenWidget extends StatefulWidget {
  const SplashScreenWidget({Key? key}) : super(key: key);
  @override
  State<SplashScreenWidget> createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget> {
  @override
  void initState() {
    super.initState();
    startUp();
  }

  Future<void> startUp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? creds = prefs.getString('creds');
    if (creds != null) {
      final res = await logUser(creds); // Make the API call
      if (res['user_group'] != null) {
        Navigator.pushReplacementNamed(
          context,
          '/home',
          arguments: {
            'jwt_token': res['jwt_token'],
            'session': res['session_id'],
          },
        );
        return;
      }
    }
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
