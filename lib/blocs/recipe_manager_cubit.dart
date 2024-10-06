import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_recipe_flutter/blocs/recipe_manager_state.dart';
import 'package:my_recipe_flutter/controllers/local_storage/local_storage_controller.dart';
import 'package:my_recipe_flutter/controllers/recipe_controller.dart';
import 'package:my_recipe_flutter/models/recipe_model.dart';

class RecipeManagerCubit extends Cubit<RecipeManagerState> {
  RecipeManagerCubit() : super(RecipeManagerInitial());
  final RecipeController recipeController = RecipeController();
  final LocalStorageController localStorageController =
      LocalStorageController();

  Future<void> fetchRecipes() async {
    emit(RecipeManagerLoading());
    final List<String> savedFilter =
        await localStorageController.getSavedFilter();
    final Either<Exception, List<RecipeModel>> recipes =
        await recipeController.getRecipes(savedFilter);

    recipes.fold((Exception error) {
      emit(RecipeManagerError(error: error));
    }, (List<RecipeModel> recipes) {
      emit(RecipeManagerLoaded(recipes));
    });
  }

  Future<void> createRecipe(RecipeModel recipe) async {
    emit(RecipeManagerLoading());

    await recipeController.createRecipe(recipe);
    fetchRecipes();
  }

  Future<void> updateRecipe(RecipeModel recipe, File? avatarFile) async {
    emit(RecipeManagerLoading());
    String? publicUrl;
    try {
      if (avatarFile != null) {
        final imagePath =
            await recipeController.replaceImage(recipe, avatarFile);
        publicUrl = await recipeController.getImagePublicUrl(
            imagePath?.replaceAll("recipe_food_image", "") ?? "");
      }

      await recipeController
          .updateRecipe(recipe.copyWith(imagePublicUrl: publicUrl));

      fetchRecipes();
    } on Exception catch (error) {
      if (kDebugMode) {
        print("Error occurred while trying to update: $error");
      }
      emit(RecipeManagerError(error: error));
    }
  }

  Future<void> deleteRecipe(RecipeModel recipe) async {
    emit(RecipeManagerLoading());
    await recipeController.deleteRecipe(recipe);
    fetchRecipes();
  }

  Future<String?> uploadImageToServer(
      RecipeModel recipe, File avatarFile) async {
    await recipeController.uploadImageToServer(recipe, avatarFile);

    final publicUrl =
        await recipeController.getImagePublicUrl(recipe.imagePath);
    return publicUrl;
  }

  Future<void> replaceImage(RecipeModel recipe, File avatarFile) async {
    await recipeController.replaceImage(recipe, avatarFile);
  }
}
