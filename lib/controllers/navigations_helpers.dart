import 'package:flutter/material.dart';
import 'package:my_recipe_flutter/views/main_page.dart';

class NavigationHelpers {
  static void navigateToMainPage(BuildContext context) =>
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
        (Route<dynamic> route) => false,
      );
}
