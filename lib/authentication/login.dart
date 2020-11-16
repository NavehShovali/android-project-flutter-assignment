import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_me/authentication/sign_up_bottom_sheet.dart';
import 'package:hello_me/authentication/user_repository.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  State createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _email;
  TextEditingController _password;
  TextEditingController _passwordConfirmation;
  bool _loading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: '');
    _password = TextEditingController(text: '');
    _passwordConfirmation = TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Login')),
      body: Container(
        constraints: BoxConstraints.expand(),
        margin: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Welcome to Startup Name Generator. Please log in below.'),
              Container(height: 8),
              TextFormField(
                controller: _email,
                decoration: InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email)),
              ),
              Container(height: 4),
              TextField(
                controller: _password,
                decoration: InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock)),
                enableSuggestions: false,
                autocorrect: false,
                obscureText: true,
              ),
              Container(height: 16),
              SizedBox(
                width: double.infinity,
                child: _loading
                    ? Center(child: CircularProgressIndicator())
                    : RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  color: Theme.of(context).primaryColor,
                  child: Text('Log in', style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    setState(() {
                      _loading = true;
                    });
                    if (_formKey.currentState.validate()) {
                      if (!await user.signIn(_email.text, _password.text)) {
                        setState(() {
                          _loading = false;
                        });
                        _scaffoldKey.currentState.showSnackBar(
                            SnackBar(content: Text('There was an error logging in to the app'))
                        );
                      } else {
                        Navigator.of(context).pop();
                      }
                    }
                  },
                ),
              ),
              Container(height: 8),
              _loading ? Container(height: 0) : SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  color: Theme.of(context).accentColor,
                  child: Text('New user? Click to sign up', style: TextStyle(color: Colors.white)),
                  onPressed: () { _signUpBottomSheet(user); },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _passwordConfirmation.dispose();
    super.dispose();
  }

  void _signUpBottomSheet(userRepository) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) =>
        SignUpBottomSheet(
          emailController: _email,
          passwordController: _password,
          userRepository: userRepository,
        )
    );
  }
}

