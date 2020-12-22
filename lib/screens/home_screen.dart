import 'package:flutter/material.dart';
import 'package:messman2/services/auth_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static final routeName = '/home';
  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('MessMan Home'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Welcome ${auth?.user?.name ?? 'Username'}'),
            RaisedButton(
              onPressed: () {
                auth.logout();
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
