import 'package:flutter/material.dart';
import 'package:messman2/screens/forgot_password_screen.dart';
import 'package:messman2/screens/signup_screen.dart';
import 'package:messman2/models/http_exception.dart';
import 'package:messman2/services/auth_service.dart';
import 'package:messman2/services/helpers.dart';
import 'package:provider/provider.dart';

class SigninScreen extends StatefulWidget {
  static const routeName = '/signin';
  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _form = GlobalKey<FormState>();
  final _passwordFocusNode = FocusNode();
  AuthService _auth;

  bool _isLoading = false;

  String _email = '';
  String _password = '';

  Future<void> _saveForm() async {
    if (!_form.currentState.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    _form.currentState.save();
    try {
      await _auth.signIn(_email, _password);
    } on HttpException catch (error) {
      showHttpError(context, error);
    } catch (error) {
      showHttpError(context, 'Something went wrong, could not sign you in!');
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthService>(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: Icon(
                            Icons.people,
                            size: 60,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(height: 20),
                        FittedBox(
                          child: Text(
                            'Welcome to MessMan',
                            style: TextStyle(
                              fontSize: 30,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Please sign in to continue.',
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Form(
                      key: _form,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            initialValue: _email,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              labelText: 'Email Address',
                            ),
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (value) {
                              FocusScope.of(context)
                                  .requestFocus(_passwordFocusNode);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter your email address!';
                              } else if (!RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value)) {
                                return 'This is not a valid email!';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _email = value.trim();
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            initialValue: _password,
                            obscureText: true,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              labelText: 'Password',
                            ),
                            focusNode: _passwordFocusNode,
                            onFieldSubmitted: (value) {
                              _saveForm();
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter your password!';
                              } else if (value.length < 6) {
                                return 'Password cannot be less than 6 character!';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _password = value;
                            },
                          ),
                          SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              child: Text('Forgot Password?'),
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(ForgotPasswordScreen.routeName);
                              },
                            ),
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            height: 45,
                            width: double.infinity,
                            child: RaisedButton(
                              onPressed: _saveForm,
                              child: Text('Sign In'),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                            ),
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        SizedBox(height: 16),
                        SizedBox(
                          height: 45,
                          width: double.infinity,
                          child: RaisedButton.icon(
                            onPressed: () async {
                              setState(() {
                                _isLoading = true;
                              });
                              _auth.googleSignIn().then((_) {
//                                Navigator.of(context).pushNamed(HomeScreen.routeName);
                              }).catchError((error) {
                                setState(() {
                                  _isLoading = false;
                                });
                                showHttpError(context, error);
                              });
                            },
                            icon: SizedBox(
                              height: 20,
                              width: 20,
                              child: Image.asset(
                                'assets/icons/google.png',
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                            label: Text('Connect with Google'),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('New here? '),
                        GestureDetector(
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(SignupScreen.routeName);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (_isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.grey.shade100.withOpacity(0.5),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
