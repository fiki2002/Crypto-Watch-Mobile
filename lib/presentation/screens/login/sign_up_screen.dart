import 'package:cryptowatch/presentation/screens/login/sign_in_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cryptowatch/app/app_constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../core/provider/auth_provider.dart';



class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  @override
  void dispose() {
    _email.clear();
    _password.clear();
    _confirmPassword.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Background2,
      body: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 132),
        child: Builder(builder: (context) {
          return Container(
            alignment: Alignment.center,
            child: Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/images/cryptowatch_logo_blue.svg'),
                    SizedBox(
                      height: 36,
                    ),
                    Text('Create an account',
                        style: Header1.copyWith(color: Text1)),
                    SizedBox(
                      height: 4,
                    ),
                    Text('Create an account to get started',
                        style: BodyText1.copyWith(color: Text3)),
                    SizedBox(
                      height: 56,
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(fontSize: 14),
                      validator: (value) {
                        if (!RegExp(
                                r'^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                            .hasMatch(value!)) {
                          return 'Please input a valid email';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        fillColor: Background1,
                        filled: true,
                        hintText: 'Email address',
                        hintStyle: BodyText1.copyWith(color: Text3),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: _password,
                      style: TextStyle(fontSize: 14),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) {
                        RegExp regex =
                            RegExp(r'^(?=.*?[a-z])(?=.*?[0-9]).{6,}$');
                        if (value == '' || value == null) {
                          return 'Please input your password!';
                        } else if (!regex.hasMatch(value)) {
                          return 'Password must not contain any special character!';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        fillColor: Background1,
                        filled: true,
                        hintText: 'Password',
                        hintStyle: BodyText1.copyWith(color: Text3),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: _confirmPassword,
                      style: TextStyle(fontSize: 14),
                      validator: (value) {
                        if (_password.text != _confirmPassword.text) {
                          return 'Password must match';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        fillColor: Background1,
                        filled: true,
                        hintText: 'Confirm password',
                        hintStyle: BodyText1.copyWith(color: Text3),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 48,
                    ),
                    Consumer<AuthenticationProvider>(builder: (
                      context,
                      auth,
                      child,
                    ) {
                      WidgetsBinding.instance!.addPostFrameCallback((_) {
                        if (auth.resMessage != '') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(auth.resMessage),
                            ),
                          );
                          auth.clear();
                        }
                      });
                      return MaterialButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            auth.signUpUser(
                              email: _email.text.trim(),
                              password: _password.text.trim(),
                              confirmPassword: _confirmPassword.text.trim(),
                              context: context,
                            );
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: Primary2,
                        minWidth: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: auth.isLoading == true
                            ? const Center(
                                child: SizedBox(
                                  height:  20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                'Create account',
                                style: BodyText1.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                      );
                    }),
                    SizedBox(
                      height: 32,
                    ),
                    RichText(
                        text: TextSpan(
                            text: 'Already a User? ',
                            style: BodyText2.copyWith(
                              color: Text3,
                            ),
                            children: [
                          TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => SignInScreen())),
                              text: 'Log in to your account',
                              style: BodyText2.copyWith(color: Primary3))
                        ]))
                  ]),
            ),
          );
        }),
      ),
    );
  }
}
