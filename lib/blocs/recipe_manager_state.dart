import 'package:equatable/equatable.dart';
import 'package:my_recipe_flutter/models/recipe_model.dart';

abstract class RecipeManagerState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class RecipeManagerInitial extends RecipeManagerState {}

final class RecipeManagerLoaded extends RecipeManagerState {
  RecipeManagerLoaded(this.listOfRecipes);

  final List<RecipeModel> listOfRecipes;

  @override
  List<Object?> get props => [listOfRecipes];
}

final class RecipeManagerLoading extends RecipeManagerState {}

final class RecipeManagerError extends RecipeManagerState {
  RecipeManagerError({required this.error});

  final Exception error;

  @override
  List<Object?> get props => [error];
}
