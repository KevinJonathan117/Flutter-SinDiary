import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterUI extends StatefulWidget {
  const RegisterUI({Key? key}) : super(key: key);

  @override
  _RegisterUIState createState() => _RegisterUIState();
}

class _RegisterUIState extends State<RegisterUI> {
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

  Future<void> registerUser() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _usernameController.text,
              password: _passwordController.text);
      print(userCredential);
      Navigator.pop(loadingDialogContext!);
      showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Registration Success'),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("You registered using ${_usernameController.text}")
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: Text('OK'),
                ),
              ],
            );
          });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        Navigator.pop(loadingDialogContext!);
        showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Weak Password'),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                          "The password provided is too weak. Please try another password."),
                    )
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: Text('OK'),
                  ),
                ],
              );
            });
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        Navigator.pop(loadingDialogContext!);
        showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Email already in use'),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("The account already exists for that email.")
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: Text('OK'),
                  ),
                ],
              );
            });
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
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.1,
              horizontal: MediaQuery.of(context).size.width * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      registerUser();
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
                    child: Text("Register"),
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all<double>(0),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue)),
                  )),
            ],
          )),
    );
  }
}
