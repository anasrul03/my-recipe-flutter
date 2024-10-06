import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_recipe_flutter/blocs/recipe_manager_cubit.dart';
import 'package:my_recipe_flutter/blocs/recipe_manager_state.dart';
import 'package:my_recipe_flutter/controllers/recipe_form_helpers.dart';

import 'package:my_recipe_flutter/views/recipe_list_widget.dart';

class MainPage extends StatefulWidget {
   const MainPage({super.key});



  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late RecipeManagerCubit _recipeManagerCubit;

  @override
  void didChangeDependencies() {
    _recipeManagerCubit = BlocProvider.of<RecipeManagerCubit>(context)
      ..fetchRecipes();
    super.didChangeDependencies();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Recipe Flutter"),
        actions: [
          IconButton(
              onPressed: () => RecipeFormHelper().buildFilterPage(context),
              icon: const Icon(Icons.filter_alt_sharp))
        ],
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 30),
        width: 100,
        child: FloatingActionButton(
          onPressed: () {
            RecipeFormHelper().buildRecipeForm(context);
          },
          child: const Text("Add Recipe"),
        ),
      ),
      body: BlocBuilder<RecipeManagerCubit, RecipeManagerState>(
        builder: (context, state) {
          if (state is RecipeManagerLoaded) {
            return RecipeListWidget(listOfRecipe: state.listOfRecipes);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
