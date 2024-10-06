import 'package:equatable/equatable.dart';

class RecipeModel implements Equatable {
  RecipeModel({
    this.id,
    required this.title,
    required this.ingredients,
    required this.instructions,
    required this.category,
    required this.imagePublicUrl,
    required this.imagePath,
    required this.auth,
  });

  final String? id;
  final String title;
  final List<String> ingredients;
  final String instructions;
  final String category;
  final String imagePublicUrl;
  final String imagePath;
  final String auth;

  // fromJson function to convert a map into a RecipeModel object
  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
        id: json['id'],
        title: json['title'],
        ingredients: List<String>.from(json['ingredients']),
        instructions: json['instructions'],
        category: json['category'],
        imagePublicUrl: json['imagePublicUrl'],
        imagePath: json['imagePath'],
        auth: json['auth']);
  }

  // toJson function to convert a RecipeModel object into a map
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'ingredients': ingredients,
      'instructions': instructions,
      'category': category,
      'imagePublicUrl': imagePublicUrl,
      'imagePath': imagePath,
      'auth': auth
    };
  }

  // toJson function to convert a RecipeModel object into a map
  Map<String, dynamic> toJsonWithoutImagePublicUrl() {
    return {
      'title': title,
      'ingredients': ingredients,
      'instructions': instructions,
      'category': category,
      'imagePath': imagePath,
      'auth': auth
    };
  }

  // copyWith function to create a copy of RecipeModel with some updated fields
  RecipeModel copyWith({
    String? id,
    String? title,
    List<String>? ingredients,
    String? instructions,
    String? category,
    String? imagePublicUrl,
    String? imagePath,
    String? auth,
  }) {
    return RecipeModel(
      id: id ?? this.id,
      title: title ?? this.title,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      category: category ?? this.category,
      imagePublicUrl: imagePublicUrl ?? this.imagePublicUrl,
      imagePath: imagePath ?? this.imagePath,
      auth: auth ?? this.auth,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        ingredients,
        instructions,
        category,
        imagePublicUrl,
        imagePath,
        auth,
      ];

  @override
  // TODO: implement stringify
  bool? get stringify => throw UnimplementedError();
}
