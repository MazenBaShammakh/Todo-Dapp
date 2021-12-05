import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import './constants.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  static const routeName = '/auth';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController _keyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Container(
          padding: EdgeInsets.only(
            right: kDefaultSpacing * 4,
            left: kDefaultSpacing * 4,
            top: kDefaultSpacing * 6 + MediaQuery.of(context).viewPadding.top,
          ),
          width: double.infinity,
          height: double.infinity,
          decoration: decorationBodyContainer(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultSpacing),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kDefaultSpacing),
                  color: kLightThemeVeryLightGrayishBlue,
                ),
                child: Row(
                  children: [
                    const SizedBox(width: kDefaultSpacing),
                    Expanded(
                      child: TextField(
                        controller: _keyController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'Paste your private key here',
                          hintStyle: GoogleFonts.josefinSans(
                            fontSize: 18,
                          ),
                          contentPadding: const EdgeInsets.all(0),
                        ),
                        style: GoogleFonts.josefinSans(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // final todoList = Provider.of<TodoList>(context, listen: false);
                        // todoList.addTodo(_keyController.text);
                        _keyController.clear();
                        FocusScopeNode currentFocus = FocusScope.of(context);

                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                      },
                      icon: const Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration decorationBodyContainer() {
    return BoxDecoration(
      color: kLightThemeLightGrayishBlue,
      // image: DecorationImage(
      //   image: Image.asset('assets/images/bg-mobile-light.jpg').image,
      //   fit: BoxFit.contain,
      //   alignment: Alignment.topCenter,
      // ),
    );
  }
}
