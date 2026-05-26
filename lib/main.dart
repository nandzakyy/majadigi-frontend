import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:majadigi/core/theme/app_colors.dart';
import 'package:majadigi/features/auth/presentation/auth_provider.dart';
import 'package:majadigi/features/home/presentation/dynamic_loader_provider.dart';
import 'package:majadigi/features/onboarding/presentation/welcome_screen.dart';
import 'package:majadigi/features/home/presentation/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DynamicLoaderProvider()),
      ],
      child: const MajadigiApp(),
    ),
  );
}

class MajadigiApp extends StatefulWidget {
  const MajadigiApp({Key? key}) : super(key: key);

  @override
  State<MajadigiApp> createState() => _MajadigiAppState();
}

class _MajadigiAppState extends State<MajadigiApp> {
  Future<void>? _initFuture;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Hot-reload safe: existing State objects don't re-run initState, so lazily init here.
    _initFuture ??= Provider.of<AuthProvider>(context, listen: false).initializeAuth();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initFuture,
      builder: (context, snapshot) {
        return MaterialApp(
          title: 'Majadigi Superapp',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            primaryColor: AppColors.primary,
            scaffoldBackgroundColor: AppColors.background,
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
            textTheme: GoogleFonts.poppinsTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          home: snapshot.connectionState != ConnectionState.done
              ? const Scaffold(body: Center(child: CircularProgressIndicator()))
              : Consumer<AuthProvider>(
                  builder: (context, auth, _) {
                    return auth.isLoggedIn ? const HomeScreen() : const WelcomeScreen();
                  },
                ),
        );
      },
    );
  }
}
