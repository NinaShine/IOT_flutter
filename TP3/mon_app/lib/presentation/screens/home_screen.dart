import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/blocs/auth_bloc.dart';
import '../../business_logic/events/auth_event.dart';
import '../../business_logic/blocs/quiz_bloc.dart';
import '../../business_logic/events/quiz_event.dart';

import '../../data/seed/seed_firestore.dart';
import 'profile_screen.dart';
import 'theme_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _seedDatabase(BuildContext context) async {
    try {
      final seeder = FirestoreSeeder(FirebaseFirestore.instance);
      await seeder.run();

      if (context.mounted) {
        context.read<QuizBloc>().add(const QuizThemesRequested());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Base Firestore mise à jour ✅")),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur seed: $e")),
        );
      }
    }
  }

  void _openProfile(BuildContext context) {
    final uid = context.read<AuthBloc>().state.uid;
    if (uid == null) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProfileScreen(uid: uid),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Accueil"),
        centerTitle: true,
        backgroundColor: cs.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // ✅ bouton seed (mise à jour base)
          IconButton(
            tooltip: "Mettre à jour la base",
            icon: const Icon(Icons.cloud_upload_rounded),
            onPressed: () => _seedDatabase(context),
          ),

          // ✅ bouton profil
          IconButton(
            tooltip: "Profil",
            icon: const Icon(Icons.account_circle_rounded),
            onPressed: () => _openProfile(context),
          ),

          // ✅ bouton déconnexion
          IconButton(
            tooltip: "Déconnexion",
            icon: const Icon(Icons.logout_rounded),
            onPressed: () =>
                context.read<AuthBloc>().add(const AuthLogoutRequested()),
          ),
        ],
      ),
      body: const ThemeListScreen(),
    );
  }
}
