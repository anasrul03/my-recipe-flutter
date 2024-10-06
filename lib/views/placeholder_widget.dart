import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_recipe_flutter/blocs/recipe_manager_cubit.dart';
import 'package:my_recipe_flutter/blocs/recipe_manager_state.dart';
import 'package:my_recipe_flutter/controllers/recipe_form_helpers.dart';

import 'package:my_recipe_flutter/views/profile_page.dart';
import 'package:my_recipe_flutter/views/recipe_details_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PlaceholderWidget extends StatefulWidget {
  const PlaceholderWidget({super.key, required this.user});

  final User user;

  @override
  State<PlaceholderWidget> createState() => _PlaceholderWidgetState();
}

class _PlaceholderWidgetState extends State<PlaceholderWidget> {
  final ValueNotifier<int> _selectedIndexNotifier = ValueNotifier<int>(0);

  @override
  void didChangeDependencies() {
    BlocProvider.of<RecipeManagerCubit>(context).fetchRecipes();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
        valueListenable: _selectedIndexNotifier,
        builder: (_, selectedIndex, __) {
          return Scaffold(
            floatingActionButton: Container(
              margin: const EdgeInsets.only(bottom: 10),
              width: 100,
              child: FloatingActionButton(
                onPressed: () => RecipeFormHelper()
                    .buildRecipeForm(context, userId: widget.user.id),
                child: const Text("Add Recipe"),
              ),
            ),
            bottomNavigationBar: NavigationBar(
              onDestinationSelected: (int index) =>
                  _selectedIndexNotifier.value = index,
              indicatorColor: Colors.amber,
              selectedIndex: selectedIndex,
              destinations: const <Widget>[
                NavigationDestination(
                  selectedIcon: Icon(Icons.home),
                  icon: Icon(Icons.home_outlined),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Badge(child: Icon(Icons.person)),
                  label: 'Profile',
                ),
              ],
            ),
            body: <Widget>[
              BlocBuilder<RecipeManagerCubit, RecipeManagerState>(
                  builder: (_, state) {
                if (state is RecipeManagerLoaded) {
                  return state.listOfRecipe.isNotEmpty
                      ? ListView.builder(
                          itemCount: state.listOfRecipe.length,
                          itemBuilder: (_, index) {
                            return ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: SizedBox(
                                  width: 60.0,
                                  height: 60.0,
                                  child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: state
                                          .listOfRecipe[index].imagePublicUrl),
                                ),
                              ),
                              title: Text(state.listOfRecipe[index].title
                                  .toUpperCase()),
                              subtitle: Text(
                                state.listOfRecipe[index].category,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RecipeDetailsPage(
                                            recipe: state.listOfRecipe[index],
                                            userId: widget.user.id,
                                          )),
                                );
                              },
                            );
                          })
                      : const Center(child: Text("No Recipes yet"));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
              ProfilePage(user: widget.user),
            ][selectedIndex],
          );
        });
  }
}
