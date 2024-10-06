import 'package:flutter/material.dart';
import 'package:my_recipe_flutter/views/auth/sign_up_page.dart';
import 'package:my_recipe_flutter/views/main_page.dart';

class NavigationHelpers {
  static void navigateToMainPage(BuildContext context) =>
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
        (Route<dynamic> route) => false,
      );

  static void navigateToSignupPage(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignupPage()),
      );
}
