import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_me/authentication/user_repository.dart';
import 'package:hello_me/random_words.dart';
import 'package:provider/provider.dart';

class SignUpBottomSheet extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final UserRepository userRepository;

  SignUpBottomSheet({
    @required this.emailController,
    @required this.passwordController,
    @required this.userRepository,
    Key key
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignUpBottomSheet();
}

class _SignUpBottomSheet extends State<SignUpBottomSheet> {
  TextEditingController _passwordConfirmationController;
  final _passwordFormKey = GlobalKey<FormState>();
  bool _validatePassword;
  bool _loading;

  @override
  void initState() {
    super.initState();
    _passwordConfirmationController = TextEditingController(text: '');
    _validatePassword = false;
    _loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 0),
        child: Form(
          key: _passwordFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Please confirm your password below:'),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                height: 1,
                width: double.infinity,
                color: Colors.grey[300],
              ),
              Form(
                child: TextFormField(
                  controller: _passwordConfirmationController,
                  enableSuggestions: false,
                  autocorrect: false,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm password',
                    prefixIcon: Icon(Icons.lock),
                    errorText: _validatePassword ? 'Passwords must match' : null
                  ),
                ),
              ),
              Container(height: 16.0,),
              _loading ? Center(child: CircularProgressIndicator()) : RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                  textColor: Colors.white,
                  elevation: 0.0,
                  color: Theme.of(context).accentColor,
                  child: Text('Confirm'),
                  onPressed: _signUp
              ),
              Container(height: 10.0,)
            ],
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    setState(() {
      _loading = true;
    });

    if (_passwordConfirmationController.text != widget.passwordController.text) {
      setState(() {
        _validatePassword = true;
        _loading = false;
      });
      return;
    }

    if (!await widget.userRepository.signUp(widget.emailController.text, widget.passwordController.text)) {
      setState(() {
        _loading = false;
      });
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => RandomWords()),
          (_) => false
      );
    }
  }
}