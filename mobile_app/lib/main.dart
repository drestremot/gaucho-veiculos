import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme.dart';
import 'providers/app_state.dart';
import 'screens/main_navigation.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.bgSurface,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const GauchoVeiculosApp());
}

class GauchoVeiculosApp extends StatefulWidget {
  const GauchoVeiculosApp({super.key});

  @override
  State<GauchoVeiculosApp> createState() => _GauchoVeiculosAppState();
}

class _GauchoVeiculosAppState extends State<GauchoVeiculosApp> {
  final AppState _appState = AppState();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _appState,
      builder: (context, _) {
        return MaterialApp(
          title: 'Gaúcho Veículos',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          home: MainNavigation(state: _appState),
        );
      },
    );
  }
}
