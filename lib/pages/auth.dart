import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped-models/main.dart';
import '../models/auth.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> with TickerProviderStateMixin {
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
    'terms': false
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();
  AuthMode _authMode = AuthMode.Login;
  AnimationController _controller;
  Animation<Offset> _slideAnimation;

  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0.0, -2.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
    );
    super.initState();
  }

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
      image: AssetImage('assets/bg1.gif'),
      fit: BoxFit.cover,
      colorFilter:
          ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.dstATop),
    );
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(color: Theme.of(context).accentColor),
        filled: true,
        fillColor: Colors.white,
      ),
      style: TextStyle(color: Theme.of(context).accentColor),
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'Email is required and should be a valid email';
        }
      },
      onSaved: (String value) {
        _formData['email'] = value;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(color: Theme.of(context).accentColor),
        filled: true,
        fillColor: Colors.white,
      ),
      obscureText: true,
      controller: _passwordTextController,
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          return 'Password is required and should be 6+ characters long';
        }
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

  Widget _buildPasswordConfirmTextField() {
    return FadeTransition(
      opacity: CurvedAnimation(parent: _controller, curve: Curves.easeIn),
      child: SlideTransition(
        position: _slideAnimation,
        child: TextFormField(
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            labelStyle: TextStyle(color: Theme.of(context).accentColor),
            filled: true,
            fillColor: Colors.white,
          ),
          style: TextStyle(color: Theme.of(context).accentColor),
          obscureText: true,
          validator: (String value) {
            if (_passwordTextController.text != value &&
                _authMode == AuthMode.SignUp) {
              return 'Passwords must match';
            }
          },
        ),
      ),
    );
  }

  Widget _buildAcceptSwitchListTile() {
    return SwitchListTile(
      value: _formData['terms'],
      onChanged: (bool value) {
        setState(() {
          _formData['terms'] = value;
        });
      },
      title: Text('Accept Terms'),
    );
  }

  void _submitForm(Function authenticate) async {
    if (!_formKey.currentState.validate() || !_formData['terms']) {
      return;
    }
    _formKey.currentState.save();
    Map<String, dynamic> successInformation = await authenticate(
        _formData['email'], _formData['password'], _authMode);

    if (successInformation['success']) {
      // Navigator.pushReplacementNamed(context, '/');
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('An error has occured!'),
            content: Text(
              successInformation['message'],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.85;
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: _buildBackgroundImage(),
        ),
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: targetWidth,
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _buildEmailTextField(),
                    SizedBox(
                      height: 10.0,
                    ),
                    _buildPasswordTextField(),
                    SizedBox(
                      height: 10.0,
                    ),
                    _buildPasswordConfirmTextField(),
                    _buildAcceptSwitchListTile(),
                    SizedBox(height: 10.0),
                    ScopedModelDescendant<MainModel>(builder:
                        (BuildContext context, Widget child, MainModel model) {
                      return model.isLoading
                          ? CircularProgressIndicator()
                          : RaisedButton(
                              child: Text(_authMode == AuthMode.Login
                                  ? 'Log In'
                                  : 'Sign Up'),
                              onPressed: () => _submitForm(model.authenticate));
                    }),
                    Center(
                      child: Container(
                        child: FlatButton(
                          child: Text(
                              '${_authMode == AuthMode.Login ? 'Sign Up' : 'Login'}'),
                          onPressed: () {
                            if (_authMode == AuthMode.Login) {
                              setState(() {
                                _authMode = AuthMode.SignUp;
                              });
                              _controller.forward();
                            } else {
                              setState(() {
                                _authMode = AuthMode.Login;
                              });
                              _controller.reverse();
                            }
                          },
                        ),
                        alignment: Alignment.bottomCenter,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
