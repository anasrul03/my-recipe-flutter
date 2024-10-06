import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_recipe_flutter/blocs/auth/auth_cubit.dart';
import 'package:my_recipe_flutter/blocs/auth/auth_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatelessWidget {
  final User user;

  ProfilePage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display user's email
            Text(
              'Welcome, ${user.email}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Logout button
            ElevatedButton(
              onPressed: () {
                // Call the logout function in AuthCubit
                context.read<AuthCubit>().signOut();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.red, // Change the color of the button to red
              ),
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
            ),

            BlocListener<AuthCubit, AuthenticationState>(
              listener: (context, state) {
                if (state is AuthSignedOut) {
                  // Navigate to login page when signed out
                  Navigator.of(context).pushReplacementNamed('/login');
                } else if (state is AuthErrorState) {
                  // Show error if sign out fails
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.error.message)),
                  );
                }
              },
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
