import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'data/repositories/quiz_repository.dart';
import 'data/repositories/firestore_quiz_repository.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/firebase_auth_repository.dart';

import 'business_logic/blocs/auth_bloc.dart';
import 'business_logic/events/auth_event.dart';
import 'business_logic/states/auth_state.dart';

import 'business_logic/blocs/quiz_bloc.dart';
import 'business_logic/events/quiz_event.dart';

import 'presentation/screens/login_screen.dart';
import 'presentation/screens/home_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5B7CFF)),
    );

    return MultiProvider(
      providers: [
        Provider<AuthRepository>(
          create: (_) => FirebaseAuthRepository(FirebaseAuth.instance),
        ),
        Provider<QuizRepository>(
          create: (_) => FirestoreQuizRepository(FirebaseFirestore.instance),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
            AuthBloc(context.read<AuthRepository>())..add(const AuthStarted()),
          ),
          BlocProvider(
            create: (context) => QuizBloc(context.read<QuizRepository>())
              ..add(const QuizThemesRequested()),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: base,
          home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state.status == AuthStatus.loading ||
                  state.status == AuthStatus.initial) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              if (state.status == AuthStatus.authenticated) {
                return const HomeScreen();
              }
              return const LoginScreen();
            },
          ),
        ),
      ),
    );
  }
}
