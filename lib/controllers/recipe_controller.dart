import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';
import 'package:my_recipe_flutter/controllers/recipe_conrtoller_repository.dart';
import 'package:my_recipe_flutter/models/recipe_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecipeController implements RecipeRepository {
  final client = Supabase.instance.client;
  final String _recipeTable = "recipes";
  final String _bucketName = "recipe_food_image";

  @override
  Future<Either<Exception, List<RecipeModel>>> getRecipes(
      List<String>? filter) async {
    final response = await _getResponse(filter);
    try {
      if (kDebugMode) {
        print(response);
      }

      List<RecipeModel> recipes =
          response.map((json) => RecipeModel.fromJson(json)).toList();
      return Right(recipes);
    } on Exception catch (error) {
      return Left(error);
    }
  }

  Future<List<Map<String, dynamic>>> _getResponse(List<String>? filter) async {
    if (filter != null && filter.isNotEmpty) {
      return await client
          .from(_recipeTable)
          .select()
          .inFilter('category', filter);
    } else {
      return await client.from(_recipeTable).select();
    }
  }

  @override
  Future<void> createRecipe(RecipeModel recipe) async =>
      await client.from(_recipeTable).insert(recipe.toJson());

  @override
  Future<void> updateRecipe(RecipeModel recipe) async => client
      .from(_recipeTable)
      .update(recipe.imagePublicUrl.isEmpty
          ? recipe.toJsonWithoutImagePublicUrl()
          : recipe.toJson())
      .eq("id", recipe.id as String);

  @override
  Future<void> deleteRecipe(RecipeModel recipe) async {
    try {
      if (recipe.id != null) {
        deleteImage(recipe);

        await client.from(_recipeTable).delete().eq('id', recipe.id!);
      } else {
        throw Exception("ERROR DELETING DATA: Recipe ID is null");
      }
    } on Exception catch (error) {
      print("Error deleting recipe: $error");
    }
  }

  @override
  Future<void> uploadImageToServer(RecipeModel recipe, File avatarFile) async {
    try {
      await client.storage.from('recipe_food_image').upload(
            recipe.imagePath,
            avatarFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );
    } catch (error) {
      print("Error getting image public url: $error");
    }
  }

  @override
  Future<String?> getImagePublicUrl(String imagePath) async {
    try {
      final response = client.storage.from(_bucketName).getPublicUrl(imagePath);

      return response;
    } on Exception catch (error) {
      print("Error getting image public url: $error");
      return null;
    }
  }

  @override
  Future<void> deleteImage(RecipeModel recipe) async {
    try {
      client.storage.from(_bucketName).remove([recipe.imagePath]);
    } on Exception catch (error) {
      print("Error deleting image: $error");
    }
  }

  @override
  Future<String?> replaceImage(RecipeModel recipe, File avatarFile) async {
    try {
      final response = await client.storage.from(_bucketName).update(
            recipe.imagePath,
            avatarFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      print("REPLACE IMAGE RES: $response");
      return response;
    } on Exception catch (error) {
      print("Error replacing image: $error");
      return null;
    }
  }
}
