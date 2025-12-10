import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travafa/core/theme/app_pallette.dart';


import 'package:travafa/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:travafa/features/auth/presentation/pages/login_screen.dart';
import 'package:travafa/init_dependencies.dart';

void main() {
  initDependecies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => serviceLocator<AuthBloc>(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppPallete.backgroundColor,
      ),
      home: const LoginPage(),
    );
  }
}
