import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_recipe_flutter/blocs/recipe_manager_cubit.dart';
import 'package:my_recipe_flutter/controllers/navigations_helpers.dart';
import 'package:my_recipe_flutter/controllers/recipe_form_helpers.dart';
import 'package:my_recipe_flutter/enums/recipe_category_enum.dart';
import 'package:my_recipe_flutter/models/recipe_model.dart';
import 'package:path/path.dart' as path;

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key, this.recipeModel});

  final RecipeModel? recipeModel;

  @override
  _AddRecipePageState createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final _formKey = GlobalKey<FormState>();
  ValueNotifier<String?> category = ValueNotifier<String?>(null);
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _ingredientController = TextEditingController();
  late RecipeManagerCubit _recipeManagerCubit;
  List<String> ingredients = [];
  File? _image;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 1024,
      maxWidth: 1024,
    );

    if (pickedFile != null && mounted) {
      File imageFile = File(pickedFile.path);

      // Validate file extension (must be .jpg)
      String extension = path.extension(imageFile.path).toLowerCase();
      if (extension != '.jpg' && mounted) {
        RecipeFormHelper.showErrorDialog(
            context, "Invalid file format. Only .jpg images are allowed.");
        return;
      }

      // Validate file size (must be less than 50MB)
      final int fileSizeInBytes = imageFile.lengthSync();
      final double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
      if (fileSizeInMB > 50) {
        RecipeFormHelper.showErrorDialog(
            context, "File is too large. Maximum size is 50MB.");
        return;
      }

      setState(() {
        _image = imageFile;
      });
    }
  }

  void _addIngredient() {
    if (_ingredientController.text.isNotEmpty) {
      setState(() {
        ingredients.add(_ingredientController.text);
        _ingredientController.clear();
      });
    }
  }

  void _removeIngredient(int index) {
    setState(() {
      ingredients.removeAt(index);
    });
  }

  Future<void> _submitForm() async {
    File? avatarFile;

    if (_formKey.currentState!.validate()) {
      final recipe = RecipeModel(
        title: _titleController.text,
        ingredients: ingredients,
        instructions: _instructionsController.text,
        category: category.value ?? "",
        imagePublicUrl: "",
        imagePath: 'public/${_titleController.text.toSnakeCase()}'
            '+${category.value!.toSnakeCase()}.jpg',
      );
      if (isEditRecipe()) {
        if (_image != null) {
          avatarFile = File(_image!.path);
        } else {
          avatarFile = null;
        }
        _recipeManagerCubit.updateRecipe(
            recipe.copyWith(
              id: widget.recipeModel!.id,
              imagePath: widget.recipeModel!.imagePath,
            ),
            avatarFile);
        // Clear the cached image
        CachedNetworkImage.evictFromCache(widget.recipeModel!.imagePublicUrl);
        setState(() {});
        Navigator.pop(context);
        NavigationHelpers.navigateToMainPage(context);
        return;
      }
      if (_image == null) {
        RecipeFormHelper.showErrorDialog(context, "Please upload an image.");
        return;
      } else {
        avatarFile = File(_image!.path);
      }

      final publicUrl =
          await _recipeManagerCubit.uploadImageToServer(recipe, avatarFile);
      _recipeManagerCubit
          .createRecipe(recipe.copyWith(imagePublicUrl: publicUrl));
      if (mounted) {
        Navigator.pop(context);
      }
      return;
    }
  }

  @override
  void initState() {
    _recipeManagerCubit = BlocProvider.of<RecipeManagerCubit>(context);
    setInitialValues();

    super.initState();
  }

  void setInitialValues() {
    if (widget.recipeModel != null) {
      _titleController.text = widget.recipeModel!.title;
      category.value = widget.recipeModel!.category;
      ingredients = widget.recipeModel!.ingredients;
      _instructionsController.text = widget.recipeModel!.title;
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Recipe"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                ValueListenableBuilder<String?>(
                    valueListenable: category,
                    builder: (_, selectedCategory, __) {
                      return DropdownButton<String>(
                        hint: const Text("Select Category"),
                        value: selectedCategory,
                        items: RecipeCategoryExtension.getDisplayNames()
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          category.value = newValue ?? "Empty";
                        },
                      );
                    }),

                const SizedBox(height: 16),

                // Ingredients field
                TextFormField(
                  controller: _ingredientController,
                  decoration:
                      const InputDecoration(labelText: 'Add Ingredient'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _addIngredient,
                  child: const Text('Add Ingredient'),
                ),
                const SizedBox(height: 16),

                // List of ingredients
                const Text(
                  'Ingredients:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ...ingredients.asMap().entries.map((entry) {
                  int index = entry.key;
                  String ingredient = entry.value;
                  return ListTile(
                    title: Text(ingredient),
                    trailing: IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => _removeIngredient(index),
                    ),
                  );
                }),
                const SizedBox(height: 16),

                // Instructions field (max 1000 words)
                TextFormField(
                  controller: _instructionsController,
                  maxLines: 5,
                  decoration: const InputDecoration(labelText: 'Instructions'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the instructions';
                    }
                    final wordCount = value.split(RegExp(r'\s+')).length;
                    if (wordCount > 1000) {
                      return 'Instructions cannot exceed 1000 words';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Image upload
                _image == null
                    ? ElevatedButton(
                        onPressed: _pickImage,
                        child: const Text('Upload Image (.jpg, max 50MB)'),
                      )
                    : Image.file(
                        _image!,
                        height: 200,
                      ),
                const SizedBox(height: 16),

                // Submit button
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child:
                        Text(isEditRecipe() ? 'Edit Recipe' : 'Create Recipe'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isEditRecipe() => widget.recipeModel != null;
}
