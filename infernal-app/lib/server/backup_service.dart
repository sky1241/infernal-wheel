import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../security/crypto_service.dart';
import 'data_store.dart';

/// Service de backup/restore chiffre
/// Permet de migrer les donnees vers un nouveau telephone
class BackupService {
  static final BackupService _instance = BackupService._internal();
  factory BackupService() => _instance;
  BackupService._internal();

  final _crypto = CryptoService();
  final _store = DataStore();

  /// Exporte toutes les donnees dans un fichier chiffre
  /// Le user choisit un mot de passe pour le backup (different du PIN)
  Future<String?> exportBackup(String backupPassword) async {
    try {
      await _store.init();

      // Collecter toutes les donnees
      final data = <String, dynamic>{};

      // Settings
      data['settings'] = await _store.loadSettings();

      // Engine state
      data['state'] = await _store.loadState();

      // Notes
      data['notes'] = await _store.loadAllNotes();

      // Quick note + action note
      data['quicknote'] = await _store.loadQuickNote();
      data['actionnote'] = await _store.loadActionNote();

      // Drinks CSV (raw content)
      final drinksFile = File('${(await getApplicationDocumentsDirectory()).path}/infernal_data/drinks.csv');
      if (await drinksFile.exists()) {
        data['drinks_csv'] = await drinksFile.readAsString();
      }

      // Log CSV (raw content)
      final logFile = File('${(await getApplicationDocumentsDirectory()).path}/infernal_data/log.csv');
      if (await logFile.exists()) {
        data['log_csv'] = await logFile.readAsString();
      }

      // Chiffrer avec le mot de passe backup
      final encrypted = await _crypto.exportBackup(backupPassword, data);

      // Ecrire dans un fichier temporaire
      final dir = await getTemporaryDirectory();
      final timestamp = DateTime.now().toIso8601String().substring(0, 10);
      final backupFile = File('${dir.path}/infernal_backup_$timestamp.enc');
      await backupFile.writeAsString(encrypted);

      return backupFile.path;
    } catch (e) {
      return null;
    }
  }

  /// Partage le fichier de backup (via le share sheet Android)
  Future<void> shareBackup(String filePath) async {
    await Share.shareXFiles([XFile(filePath)], text: '-1+ Backup');
  }

  /// Importe un backup depuis un fichier
  Future<bool> importBackup(String filePath, String backupPassword) async {
    try {
      await _store.init();
      final file = File(filePath);
      if (!await file.exists()) return false;

      final encrypted = await file.readAsString();
      final data = await _crypto.importBackup(backupPassword, encrypted);
      if (data == null) return false;

      // Restaurer settings
      if (data['settings'] != null) {
        await _store.saveSettings(data['settings'] as Map<String, dynamic>);
      }

      // Restaurer state
      if (data['state'] != null) {
        await _store.saveState(data['state'] as Map<String, dynamic>);
      }

      // Restaurer notes
      final notes = data['notes'] as List?;
      if (notes != null) {
        for (final note in notes) {
          final m = note as Map<String, dynamic>;
          await _store.saveNote(m['day'] as String, m['content'] as String);
        }
      }

      // Restaurer quick/action notes
      if (data['quicknote'] != null) {
        await _store.saveQuickNote(data['quicknote'] as String);
      }
      if (data['actionnote'] != null) {
        await _store.saveActionNote(data['actionnote'] as String);
      }

      // Restaurer CSV files
      final appDir = await getApplicationDocumentsDirectory();
      final dataDir = '${appDir.path}/infernal_data';

      if (data['drinks_csv'] != null) {
        await File('$dataDir/drinks.csv').writeAsString(data['drinks_csv'] as String);
      }
      if (data['log_csv'] != null) {
        await File('$dataDir/log.csv').writeAsString(data['log_csv'] as String);
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
