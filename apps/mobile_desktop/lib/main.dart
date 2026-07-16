import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sonaura_app/core/theme/app_theme.dart';
import 'package:sonaura_app/core/router/app_router.dart';
import 'package:sonaura_app/core/network/api_client.dart';
import 'package:sonaura_app/core/storage/session_service.dart';
import 'package:sonaura_app/features/auth/data/auth_repository.dart';
import 'package:sonaura_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sonaura_app/features/player/presentation/bloc/player_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: SonauraColors.surface,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  final secureStorage = const FlutterSecureStorage();
  final sessionService = SessionService(secureStorage: secureStorage);
  await sessionService.initialize();
  final apiClient = ApiClient(secureStorage: secureStorage);
  final authRepository = AuthRepository(apiClient: apiClient, sessionService: sessionService);
  final authBloc = AuthBloc(authRepository: authRepository, sessionService: sessionService);
  final playerBloc = PlayerBloc(apiClient: apiClient, sessionService: sessionService);
  final persistedTheme = await sessionService.themeMode;
  SonauraThemeMode initialTheme;
  switch (persistedTheme) {
    case 'light': initialTheme = SonauraThemeMode.light; break;
    case 'amoled': initialTheme = SonauraThemeMode.amoled; break;
    default: initialTheme = SonauraThemeMode.dark; break;
  }
  authBloc.add(const CheckAuthStatus());
  final router = createRouter(authBloc: authBloc, sessionService: sessionService, apiClient: apiClient);
  runApp(SonauraApp(authBloc: authBloc, playerBloc: playerBloc, sessionService: sessionService, router: router, initialTheme: initialTheme));
}

class SonauraApp extends StatefulWidget {
  final AuthBloc authBloc;
  final PlayerBloc playerBloc;
  final SessionService sessionService;
  final GoRouter router;
  final SonauraThemeMode initialTheme;
  const SonauraApp({super.key, required this.authBloc, required this.playerBloc, required this.sessionService, required this.router, required this.initialTheme});
  @override State<SonauraApp> createState() => _SonauraAppState();
}

class _SonauraAppState extends State<SonauraApp> {
  late SonauraThemeMode _themeMode;
  @override void initState() { super.initState(); _themeMode = widget.initialTheme; }
  void _updateThemeFromUser(SonauraThemeMode mode) { if (_themeMode != mode) { setState(() { _themeMode = mode; }); widget.sessionService.setThemeMode(mode.name); } }
  @override Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [BlocProvider<AuthBloc>.value(value: widget.authBloc), BlocProvider<PlayerBloc>.value(value: widget.playerBloc)], child: BlocListener<AuthBloc, AuthState>(listener: (context, state) { if (state is Authenticated) { final pref = state.user.themePref; if (pref == 'amoled') { _updateThemeFromUser(SonauraThemeMode.amoled); } else if (pref == 'light') { _updateThemeFromUser(SonauraThemeMode.light); } else { _updateThemeFromUser(SonauraThemeMode.dark); } } }, child: MaterialApp.router(title: 'Sonaura', debugShowCheckedModeBanner: false, theme: SonauraLightTheme.theme, darkTheme: SonauraDarkTheme.theme, themeMode: _themeMode == SonauraThemeMode.light ? ThemeMode.light : ThemeMode.dark, routerConfig: widget.router, builder: (context, child) { if (_themeMode == SonauraThemeMode.amoled && child != null) { return Theme(data: SonauraAmoledTheme.theme, child: MediaQuery(data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling), child: child)); } return MediaQuery(data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling), child: child ?? const SizedBox.shrink()); }));
  }
}