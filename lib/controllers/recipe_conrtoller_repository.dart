import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:my_recipe_flutter/models/recipe_model.dart';

abstract class RecipeRepository {
  Future<void> uploadImageToServer(RecipeModel recipe, File avatarFile);

  Future<String?> getImagePublicUrl(String imagePath);

  Future<Either<Exception, List<RecipeModel>>> getRecipes(List<String> filter);

  Future<void> createRecipe(RecipeModel recipe);

  Future<void> deleteImage(RecipeModel recipe);

  Future<void> deleteRecipe(RecipeModel recipe);

  Future<String?> replaceImage(RecipeModel recipe, File avatarFile);

  Future<void> updateRecipe(RecipeModel recipe);
}
