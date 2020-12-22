import 'package:flutter/material.dart';
import 'package:messman2/screens/forgot_password_screen.dart';
import 'package:messman2/screens/home_screen.dart';
import 'package:messman2/screens/signin_screen.dart';
import 'package:messman2/screens/signup_screen.dart';
import 'package:messman2/services/auth_service.dart';
import 'package:provider/provider.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ListenableProvider.value(value: AuthService())],
      child: MaterialApp(
        title: 'MessMan',
        home: RootScreen(),
        routes: {
          HomeScreen.routeName: (context) => HomeScreen(),
          SigninScreen.routeName: (context) => SigninScreen(),
          SignupScreen.routeName: (context) => SignupScreen(),
          ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
        },
      ),
    );
  }
}

class RootScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);
    if (auth.isLoggedIn) {
      return HomeScreen();
    } else {
      return SigninScreen();
    }
  }
}
