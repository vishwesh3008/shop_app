import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/auth.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://cdn.hipwallpaper.com/i/9/25/YbxLqa.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 135.0, top: 30),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                      // transform: Matrix4.rotationZ(-8 * pi / 180)
                      //   ..translate(-10.0),
                      // // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.indigo[800],
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black87,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'Myshop',
                        style: TextStyle(
                          // ignore: deprecated_member_use
                          color: Colors.white,
                          fontSize: 40,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  void _showErrorDialog(String msg) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text("An Error Occured"),
              content: Text(msg),
              actions: [
                FlatButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: Text('okay'))
              ],
            ));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false)
            .logIn(_authData['email'], _authData['password']);
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false)
            .signUp(_authData['email'], _authData['password']);
      }
    } on HttpException catch (error) {
      var errormsg = "Authentication Failed";
      if (error.toString().contains('EMAIL_EXISTS')) {
        errormsg = 'This email already Exisits';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errormsg = 'Invalid Email.Please check your Email ';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errormsg = 'This password is too weak';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errormsg = 'Could not find a user with that Email';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errormsg = 'Invalid password';
      }
      _showErrorDialog(errormsg);
    } catch (error) {
      const errormsg = 'Could not authenticate you.Please try again later';
      _showErrorDialog(errormsg);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: EdgeInsets.only(top: 50),
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.Signup ? 320 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                  },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    textInputAction: TextInputAction.done,
                    enabled: _authMode == AuthMode.Signup,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!';
                            }
                          }
                        : null,
                  ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    child:
                        Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
                FlatButton(
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  onPressed: _switchAuthMode,
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
