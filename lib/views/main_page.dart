import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_recipe_flutter/blocs/auth/auth_cubit.dart';
import 'package:my_recipe_flutter/blocs/auth/auth_state.dart';

import 'package:my_recipe_flutter/controllers/recipe_form_helpers.dart';
import 'package:my_recipe_flutter/views/auth/login_page.dart';

import 'package:my_recipe_flutter/views/placeholder_widget.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthenticationState>(
      listener: (_, state) {
        if (state is AuthErrorState) {
          RecipeFormHelper.showErrorDialog(context, state.error.message);
        }
      },
      builder: (context, state) {
        if (state is AuthSignedIn) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("My Recipe Flutter"),
              actions: [
                IconButton(
                    onPressed: () =>
                        RecipeFormHelper().buildFilterPage(context),
                    icon: const Icon(Icons.filter_alt_sharp))
              ],
            ),
            body: PlaceholderWidget(user: state.user),
          );
        } else if (state is AuthSignedOut || state is AuthInitialState) {
          return LoginPage();
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
