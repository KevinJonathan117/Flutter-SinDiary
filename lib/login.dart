import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sindiary/register.dart';

import 'home.dart';

class LoginUI extends StatefulWidget {
  const LoginUI({Key? key}) : super(key: key);

  @override
  _LoginUIState createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  BuildContext? loadingDialogContext;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  Future<void> signIn() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _usernameController.text,
              password: _passwordController.text);
      print(userCredential);
      Navigator.pop(loadingDialogContext!);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeUI()));
    } on FirebaseAuthException catch (e) {
      print(e.code);

      if (e.code == 'user-not-found') {
        Navigator.pop(loadingDialogContext!);
        print('No user found for that email.');
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Error'),
            content: Text('No user found for that email'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else if (e.code == 'wrong-password') {
        Navigator.pop(loadingDialogContext!);
        print('Wrong password provided for that user.');
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Error'),
            content: Text('Wrong password provided for that user.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else if (e.code == 'invalid-email') {
        await Future.delayed(Duration(seconds: 1));
        Navigator.pop(loadingDialogContext!);
        print('Invalid email.');
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Error'),
            content: Text('Invalid email.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.1,
              horizontal: MediaQuery.of(context).size.width * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("SinDiary Login",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: Colors.grey[800])),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
              ),
              TextField(
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.person),
                ),
                controller: _usernameController,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                ),
                controller: _passwordController,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.height * 0.8,
                height: MediaQuery.of(context).size.height * 0.05,
                child: ElevatedButton(
                  onPressed: () {
                    signIn();
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) {
                          loadingDialogContext = context;
                          return AlertDialog(
                            title: Text('Loading'),
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [CircularProgressIndicator()],
                            ),
                          );
                        });
                  },
                  child: Text("Login"),
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all<double>(0),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue)),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.height * 0.8,
                height: MediaQuery.of(context).size.height * 0.05,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => RegisterUI()));
                  },
                  child: Text(
                    "Register",
                    style: TextStyle(color: Colors.blue),
                  ),
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all<double>(0),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.transparent)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
