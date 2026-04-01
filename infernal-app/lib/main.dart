import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'security/crypto_service.dart';
import 'server/local_server.dart';
import 'theme/app_theme.dart';
import 'views/dashboard_webview.dart';
import 'views/onboarding_screen.dart';

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

  runApp(const PlusMinusOneApp());
}

class PlusMinusOneApp extends StatelessWidget {
  const PlusMinusOneApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Localization will be wired once l10n files are finalized.
    return MaterialApp(
      title: '-1+',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      home: const AppLauncher(),
    );
  }
}

/// Ecran de lancement : setup auto → serveur → dashboard
class AppLauncher extends StatefulWidget {
  const AppLauncher({super.key});

  @override
  State<AppLauncher> createState() => _AppLauncherState();
}

class _AppLauncherState extends State<AppLauncher> {
  final _crypto = CryptoService();

  // States: checking → onboarding → loading → ready
  String _phase = 'checking';
  String? _error;

  @override
  void initState() {
    super.initState();
    _checkSetup();
  }

  Future<void> _checkSetup() async {
    try {
      final isSetup = await _crypto.isSetup();
      if (isSetup) {
        // Deja configure — deverrouiller auto et lancer
        await _crypto.unlockAuto();
        await _startServer();
      } else {
        // Premier lancement — montrer onboarding
        setState(() => _phase = 'onboarding');
      }
    } catch (e) {
      setState(() { _phase = 'error'; _error = e.toString(); });
    }
  }

  Future<void> _onOnboardingDone() async {
    setState(() => _phase = 'loading');
    try {
      // Generer la cle AES automatiquement (transparent pour le user)
      await _crypto.setupAuto();
      await _startServer();
    } catch (e) {
      setState(() { _phase = 'error'; _error = e.toString(); });
    }
  }

  Future<void> _startServer() async {
    setState(() => _phase = 'loading');
    try {
      await localServer.start();
      setState(() => _phase = 'ready');
    } catch (e) {
      setState(() { _phase = 'error'; _error = e.toString(); });
    }
  }

  @override
  void dispose() {
    localServer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (_phase) {
      case 'ready':
        return DashboardWebView(serverUrl: localServer.url);

      case 'onboarding':
        return OnboardingScreen(onContinue: _onOnboardingDone);

      case 'loading':
        return _buildLoading('Demarrage...');

      case 'error':
        return _buildError();

      default: // checking
        return _buildLoading('Demarrage...');
    }
  }

  Widget _buildLoading(String message) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1319),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Color(0xFF35D99A)),
            const SizedBox(height: 24),
            Text(message, style: const TextStyle(color: Color(0xFFE7EDF3), fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildError() {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1319),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Color(0xFFFF7A7A), size: 48),
            const SizedBox(height: 16),
            Text(
              'Erreur: $_error',
              style: const TextStyle(color: Color(0xFFFF7A7A), fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _checkSetup,
              child: const Text('Reessayer'),
            ),
          ],
        ),
      ),
    );
  }
}
