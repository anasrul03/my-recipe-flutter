import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_recipe_flutter/models/recipe_model.dart';
import 'package:my_recipe_flutter/views/recipe_details_page.dart';

class RecipeListWidget extends StatefulWidget {
  const RecipeListWidget({super.key, required this.listOfRecipe});

  final List<RecipeModel> listOfRecipe;

  @override
  State<RecipeListWidget> createState() => _RecipeListWidgetState();
}

class _RecipeListWidgetState extends State<RecipeListWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.listOfRecipe.isNotEmpty
          ? ListView.builder(
              itemCount: widget.listOfRecipe.length,
              itemBuilder: (_, index) {
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: SizedBox(
                      width: 60.0,
                      height: 60.0,
                      child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: widget.listOfRecipe[index].imagePublicUrl),
                    ),
                  ),
                  title: Text(widget.listOfRecipe[index].title.toUpperCase()),
                  subtitle: Text(
                    widget.listOfRecipe[index].category,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RecipeDetailsPage(
                              recipe: widget.listOfRecipe[index])),
                    );
                  },
                );
              })
          : const Center(child: Text("No Recipes yet")),
    );
  }
}
