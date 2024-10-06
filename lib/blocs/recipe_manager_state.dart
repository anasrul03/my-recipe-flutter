import 'package:equatable/equatable.dart';
import 'package:my_recipe_flutter/models/recipe_model.dart';

abstract class RecipeManagerState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class RecipeManagerInitial extends RecipeManagerState {}

final class RecipeManagerLoaded extends RecipeManagerState {
  RecipeManagerLoaded(this.listOfRecipe);

  final List<RecipeModel> listOfRecipe;

  @override
  List<Object?> get props => [listOfRecipe];
}

final class RecipeManagerLoading extends RecipeManagerState {}

final class RecipeManagerError extends RecipeManagerState {
  RecipeManagerError({required this.error});

  final Exception error;

  @override
  List<Object?> get props => [error];
}
