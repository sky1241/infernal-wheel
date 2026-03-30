import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'server/local_server.dart';
import 'theme/app_theme.dart';
import 'views/dashboard_webview.dart';

/// Serveur local — singleton global
final localServer = LocalServer();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Force dark mode system UI
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF14171A),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const InfernalWheelApp());
}

class InfernalWheelApp extends StatelessWidget {
  const InfernalWheelApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Wire localization into MaterialApp (localizationsDelegates,
    // supportedLocales, locale) once generated l10n files are up to date.
    return MaterialApp(
      title: 'InfernalWheel',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      home: const AppLauncher(),
    );
  }
}

/// Ecran de lancement : demarre le serveur local puis ouvre le dashboard
class AppLauncher extends StatefulWidget {
  const AppLauncher({super.key});

  @override
  State<AppLauncher> createState() => _AppLauncherState();
}

class _AppLauncherState extends State<AppLauncher> {
  String _status = 'Demarrage...';
  bool _ready = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _startServer();
  }

  Future<void> _startServer() async {
    try {
      setState(() => _status = 'Lancement du serveur...');
      await localServer.start();
      setState(() {
        _status = 'Pret sur port ${localServer.port}';
        _ready = true;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _status = 'Erreur';
      });
    }
  }

  @override
  void dispose() {
    localServer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      return DashboardWebView(serverUrl: localServer.url);
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0E1319),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_error == null) ...[
              const CircularProgressIndicator(color: Color(0xFF35D99A)),
              const SizedBox(height: 24),
              Text(
                _status,
                style: const TextStyle(color: Color(0xFFE7EDF3), fontSize: 16),
              ),
            ] else ...[
              const Icon(Icons.error_outline, color: Color(0xFFFF7A7A), size: 48),
              const SizedBox(height: 16),
              Text(
                'Erreur: $_error',
                style: const TextStyle(color: Color(0xFFFF7A7A), fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _startServer,
                child: const Text('Reessayer'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
