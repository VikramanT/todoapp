import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool isLoginPage = false;
  String username = '';

  void startAuthentication() {
    final validity = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (validity) {
      _formKey.currentState!.save();
      submitForm(email, password, username);
    }
  }

  void submitForm(String email, String password, String username) async {
    final auth = FirebaseAuth.instance;
    try {
      if (isLoginPage) {
        // Sign in with the provided credentials
        final authResult = await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        // You can access the signed-in user information from authResult.user
       
        print('Sign-in successful. User ID: ${authResult.user?.uid}');
      } else {
        // Sign up with the provided credentials
        final authResult = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
          // username:username,
        );
         String? uid=authResult.user?.uid;
         await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'username':username,
          'email':email

         });
        print('Sign-up successful. User ID: ${authResult.user?.uid}');
      }
    } catch (e) {
      // Handle any errors that occur during the authentication process
      print('Authentication error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isLoginPage)
                    TextFormField(
                      keyboardType: TextInputType.name,
                      key: ValueKey('username'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        username = value!;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(19),
                        ),
                        labelText: "Username",
                        labelStyle: GoogleFonts.roboto(),
                      ),
                    ),
                  const SizedBox(height: 10),
                  TextFormField(
                    autofillHints: [AutofillHints.email],
                    keyboardType: TextInputType.emailAddress,
                    key: ValueKey('email'),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      email = value!;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(19),
                      ),
                      labelText: "Email",
                      labelStyle: GoogleFonts.roboto(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      password = value!;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(19),
                      ),
                      labelText: "Password",
                      labelStyle: GoogleFonts.roboto(),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(5),
                    width: double.infinity,
                    height: 70,
                    child: ElevatedButton(
                      onPressed: startAuthentication,
                      child: isLoginPage ? Text('Login') : Text('Signup'),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          isLoginPage = !isLoginPage;
                        });
                      },
                      child: isLoginPage
                          ? Text("Not a Member")
                          : Text("Already a Member?"),
                    ),
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
