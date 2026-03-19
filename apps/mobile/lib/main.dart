import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'l10n/app_localizations.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: const String.fromEnvironment('SUPABASE_URL',
        defaultValue: 'https://sdrwwhtszsyktiervicb.supabase.co'),
    anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY',
        defaultValue: 'sb_publishable_jvjvFQ_3RvQDAuRUKOo06A_ksA0Hx6K'),
  );

  final prefs = await SharedPreferences.getInstance();
  final savedLocale = prefs.getString('app_locale');

  runApp(MyApp(initialLocale: savedLocale));
}

final supabase = Supabase.instance.client;

class MyApp extends StatefulWidget {
  final String? initialLocale;
  const MyApp({super.key, this.initialLocale});

  static MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<MyAppState>();

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    if (widget.initialLocale != null) {
      final parts = widget.initialLocale!.split('_');
      _locale = Locale(parts[0], parts.length > 1 ? parts[1] : null);
    } else {
      _locale = const Locale.fromSubtags(languageCode: 'zh', countryCode: 'TW');
    }
  }

  Locale get locale => _locale;

  Future<void> toggleLocale() async {
    setState(() {
      if (_locale.languageCode == 'zh') {
        _locale = const Locale('en');
      } else {
        _locale = const Locale.fromSubtags(languageCode: 'zh', countryCode: 'TW');
      }
    });
    final prefs = await SharedPreferences.getInstance();
    final tag = _locale.countryCode != null
        ? '${_locale.languageCode}_${_locale.countryCode}'
        : _locale.languageCode;
    await prefs.setString('app_locale', tag);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rental Suite Manager',
      debugShowCheckedModeBanner: false,
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
        ),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          scrolledUnderElevation: 0,
          backgroundColor: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)).surface,
          surfaceTintColor: Colors.transparent,
        ),
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: supabase.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = supabase.auth.currentSession;
        if (session != null) {
          return const HomeScreen();
        }
        return const LoginScreen();
      },
    );
  }
}
