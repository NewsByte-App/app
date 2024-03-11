import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newsbyte/bloc/auth_bloc.dart';
import 'package:newsbyte/bloc/theme/theme.dart';
import 'package:newsbyte/bloc/theme/theme_bloc.dart';
import 'package:newsbyte/bloc/theme/theme_event.dart';
import 'package:newsbyte/constants.dart';
import 'package:newsbyte/screens/authentication.dart';

class People extends StatelessWidget {
  const People({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('People'),
        centerTitle: true,
      ),
    );
  }
}

class NavDrawer extends StatelessWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthInitial) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false);
          }
        },
        builder: (context, state) {
          return Material(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 80, 24, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  headerWidget(),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(
                    thickness: 1,
                    height: 10,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const MergeSemantics(
                    child: ListTile(
                      leading: Icon(Icons.bookmark, size: 30),
                      title: Text("Bookmarks"),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MergeSemantics(
                    child: ListTile(
                      title: const Text("Dark Mode"),
                      leading: SizedBox(
                        height: 10,
                        width: 10,
                        child: Transform.scale(
                          scale: 0.7,
                          child: BlocBuilder<ThemeBloc, ThemeData>(
                            builder: (context, state) {
                              return CupertinoSwitch(
                                  activeColor: Colors.grey,
                                  value: state == darkMode,
                                  onChanged: (bool val) {
                                    BlocProvider.of<ThemeBloc>(context)
                                        .add(ThemeSwitching());
                                  });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(
                    thickness: 1,
                    height: 10,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  MergeSemantics(
                    child: ListTile(
                      leading: const Icon(Icons.logout, size: 30),
                      title: const Text("Logout"),
                      onTap: () {
                        BlocProvider.of<AuthBloc>(context)
                            .add(AuthLogoutRequested());
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget headerWidget() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthSuccess) {
          return Text(
            state.email,
            style: Theme.of(context).textTheme.bodyText1,
          );
        } else {
          return const Text(
            "",
          );
        }
      },
    );
  }
}
