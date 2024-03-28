import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iconsax/iconsax.dart';
import 'package:newsbyte/bloc/auth_bloc.dart';
import 'package:newsbyte/bloc/theme/theme.dart';
import 'package:newsbyte/bloc/theme/theme_bloc.dart';
import 'package:newsbyte/constants.dart';
import 'package:newsbyte/main.dart';
import 'package:newsbyte/screens/home_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sup;
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  static String routeName = "/login";

  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _emailController = TextEditingController();
  late final StreamSubscription<sup.AuthState> _authStateSubscription;
  bool emailValidated = false;

  @override
  void initState() {
    _authStateSubscription = supabase.auth.onAuthStateChange.listen((data) {
      final session = data.session;

      if (session != null) {
        BlocProvider.of<AuthBloc>(context)
            .add(AuthUserAuthenicated(email: session.user.email!));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _authStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }

          if (state is AuthEmailSent) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                    Text("Please check your email to login to your account"),
              ),
            );
            _emailController.clear();
          }

          if (state is AuthSuccess) {
            Navigator.pushNamedAndRemoveUntil(
                context, HomeScreen.routeName, (route) => false);
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const CircularProgressIndicator();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text('Welcome To',
                      style: Theme.of(context).textTheme.titleLarge),
                  Text(
                    'NewsBites.',
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 40,
                        ),
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  TextField(
                    controller: _emailController,
                    onChanged: (_emailController) {
                      if (EmailValidator.validate(
                              _emailController.toString()) &&
                          emailValidated == false) {
                        setState(() {
                          emailValidated = true;
                        });
                      } else if (emailValidated == true &&
                          !EmailValidator.validate(
                              _emailController.toString())) {
                        setState(() {
                          emailValidated = false;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(15.0),
                      hintText: 'Enter Your Email.',
                      labelStyle: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                      ),
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14.0,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      floatingLabelStyle: const TextStyle(
                        fontSize: 18.0,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).primaryColor, width: 1.5),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: MaterialButton(
                      onPressed: emailValidated == false
                          ? () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter a valid email.'),
                                ),
                              );
                            }
                          : () {
                              BlocProvider.of<AuthBloc>(context)
                                  .add(AuthLoginRequested(
                                email: _emailController.text.trim(),
                                loginType: email.toString(),
                              ));
                            },
                      color: Colors.black,
                      height: 50,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: Colors.white), // Add this line
                      ),
                      child: Text(
                        "Get Login Link.",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Or Login With',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Card(
                          color: Theme.of(context)
                              .scaffoldBackgroundColor, // Use cardColor instead of scaffoldBackgroundColor
                          margin: const EdgeInsets.only(right: 5),
                          child: InkWell(
                            onTap: () {
                              BlocProvider.of<AuthBloc>(context)
                                  .add(AuthLoginRequested(
                                email: "",
                                loginType: google.toString(),
                              ));
                            },
                            child: Container(
                              width: 100, // Set the width to 100 pixels
                              height: 100, // Set the height to 100 pixels
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border:
                                    Border.all(color: Colors.grey, width: 0.5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: Image.asset(
                                  'assets/google.png',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          margin: const EdgeInsets.only(left: 5),
                          child: InkWell(
                            onTap: () {
                              BlocProvider.of<AuthBloc>(context)
                                  .add(AuthLoginRequested(
                                email: "",
                                loginType: apple.toString(),
                              ));
                            },
                            child: Container(
                              width: 100, // Set the width to 100 pixels
                              height: 100, // Set the height to 100 pixels
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border:
                                    Border.all(color: Colors.grey, width: 0.5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Icon(
                                  Icons.apple,
                                  color: Theme.of(context).primaryColor,
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ));
  }
}
