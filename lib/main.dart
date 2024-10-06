import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_recipe_flutter/blocs/recipe_manager_cubit.dart';
import 'package:my_recipe_flutter/controllers/environment_handler.dart';
import 'package:my_recipe_flutter/views/main_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: apiUrl,
    anonKey: apiKey,
  );
  final RecipeManagerCubit recipeManagerCubit = RecipeManagerCubit();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<RecipeManagerCubit>(create: (_) => recipeManagerCubit),
      BlocProvider<RecipeManagerCubit>(create: (_) => recipeManagerCubit),
    ],
    child: BlocProvider<RecipeManagerCubit>(
        create: (_) => recipeManagerCubit, child: const MyApp()),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Recipe Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}
