import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  String _emailValue;
  String _passwordValue;
  bool _acceptTerms = false;

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
      image: AssetImage('assets/bg1.gif'),
      fit: BoxFit.cover,
      colorFilter:
          ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.dstATop),
    );
  }

  Widget _buildEmailTextField() {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(color: Theme.of(context).accentColor),
        filled: true,
        fillColor: Colors.white,
      ),
      style: TextStyle(color: Theme.of(context).accentColor),
      onChanged: (value) {
        setState(() {
          _emailValue = value;
        });
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(color: Theme.of(context).accentColor),
        filled: true,
        fillColor: Colors.white,
      ),
      obscureText: true,
      onChanged: (value) {
        setState(() {
          _passwordValue = value;
        });
      },
    );
  }

  Widget _buildAcceptSwitchListTile() {
    return SwitchListTile(
      value: _acceptTerms,
      onChanged: (bool value) {
        setState(() {
          _acceptTerms = value;
        });
      },
      title: Text('Accept Terms'),
    );
  }

  void _submitForm() {
    print(_emailValue);
    print(_passwordValue);
    Navigator.pushReplacementNamed(context, '/products');
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
              child: Column(
                children: <Widget>[
                  _buildEmailTextField(),
                  SizedBox(
                    height: 10.0,
                  ),
                  _buildPasswordTextField(),
                  _buildAcceptSwitchListTile(),
                  SizedBox(height: 10.0),
                  RaisedButton(child: Text('Login'), onPressed: _submitForm),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
