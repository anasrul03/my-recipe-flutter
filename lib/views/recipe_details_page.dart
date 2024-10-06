import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_recipe_flutter/blocs/recipe_manager_cubit.dart';
import 'package:my_recipe_flutter/controllers/navigations_helpers.dart';
import 'package:my_recipe_flutter/controllers/recipe_form_helpers.dart';
import 'package:my_recipe_flutter/models/recipe_model.dart';

class RecipeDetailsPage extends StatelessWidget {
  const RecipeDetailsPage({super.key, required this.recipe});

  final RecipeModel recipe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recipe Details"),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
        actions: [
          IconButton(
              onPressed: () {
                RecipeFormHelper().buildRecipeForm(context, recipe: recipe);
              },
              icon: const Icon(Icons.edit)),
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Recipe?'),
                    content: const Text("This action cannot be undo."),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await RecipeManagerCubit().deleteRecipe(recipe);
                          if (!context.mounted) return;
                          NavigationHelpers.navigateToMainPage(context);
                        },
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.delete))
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cached image with a placeholder and error widget
            Center(
              child: CachedNetworkImage(
                imageUrl: recipe.imagePublicUrl,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => const SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            const SizedBox(height: 20),

            // Recipe title

            Row(
              children: [
                Expanded(
                  child: Text(
                    recipe.title,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                // Recipe category
                Chip(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  label: Text(recipe.category.toUpperCase()),
                  backgroundColor: Colors.greenAccent.shade100,
                ),
              ],
            ),

            const SizedBox(height: 10),

            const SizedBox(height: 20),

            // Ingredients section
            const Text(
              'Ingredients',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            ...recipe.ingredients.map((ingredient) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      const Icon(Icons.check, color: Colors.greenAccent),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          ingredient,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                )),

            const SizedBox(height: 20),

            // Instructions section
            const Text(
              'Instructions',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              recipe.instructions,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
