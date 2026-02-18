
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'screens/splash_screen.dart';
import 'theme/app_motion.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: const FixmateApp(),
    ),
  );
}

class FixmateApp extends StatelessWidget {
  const FixmateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, app, _) => MaterialApp(
        title: 'Fixmate',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(context),
        darkTheme: AppTheme.dark(context),
        themeMode: app.themeMode,
        onGenerateRoute: (settings) {
          if (settings.name == Navigator.defaultRouteName) {
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const SplashScreen(),
              transitionDuration: AppMotion.maybe(AppMotion.normal, context),
              reverseTransitionDuration: AppMotion.maybe(AppMotion.normal, context),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                final curve = AppMotion.maybeCurve(AppMotion.standard(context), context);
                final fade = CurvedAnimation(parent: animation, curve: curve);
                final slide = Tween<Offset>(
                  begin: const Offset(0, 0.04),
                  end: Offset.zero,
                ).animate(fade);
                return FadeTransition(
                  opacity: fade,
                  child: SlideTransition(position: slide, child: child),
                );
              },
            );
          }
          return null;
        },
        home: const SplashScreen(),
      ),
    );
  }
}
