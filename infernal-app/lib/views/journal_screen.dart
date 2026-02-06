import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isExporting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Message motivant
          _buildMotivationalHeader(),

          // Zone texte
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 16,
                  height: 1.5,
                ),
                decoration: InputDecoration(
                  hintText: 'Ecris ce que tu veux...',
                  hintStyle: TextStyle(color: AppColors.muted),
                  border: InputBorder.none,
                  filled: false,
                ),
                onChanged: (text) {
                  // TODO: Auto-save avec debounce
                },
              ),
            ),
          ),

          // Bouton export
          _buildExportButton(),
        ],
      ),
    );
  }

  Widget _buildMotivationalHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.lg),
      color: AppColors.surface,
      child: Column(
        children: [
          Text(
            'Libere-toi. Lache-toi. Ecris.',
            style: TextStyle(
              color: AppColors.text,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            'Cet espace est le tien. Pas de jugement, pas de filtre.',
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildExportButton() {
    return Padding(
      padding: const EdgeInsets.all(Spacing.md),
      child: ElevatedButton.icon(
        onPressed: _isExporting ? null : _showExportSheet,
        icon: _isExporting
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.background,
                ),
              )
            : const Icon(Icons.share),
        label: Text(_isExporting ? 'Export...' : 'Exporter pour psy'),
      ),
    );
  }

  void _showExportSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Spacing.radiusLg)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          // TODO: Generer le vrai export depuis DayEntry
          final exportText = '''
==================================================
JOURNAL - 2024-02-06
==================================================

--- SOMMEIL ---
Reveil: 10:30
Duree: 7h30
Qualite: Bon (8/10)

--- ADDICTIONS ---
🚬 Cigarettes: 5 (1ere a +45min du reveil)
🍺 Bieres: 2

--- NOTES LIBRES ---
${_controller.text}

==================================================
''';

          return Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: Spacing.sm),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.all(Spacing.md),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Apercu export',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Contenu
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(Spacing.md),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(Spacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(Spacing.radiusMd),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: SelectableText(
                      exportText,
                      style: TextStyle(
                        color: AppColors.text,
                        fontFamily: 'monospace',
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ),

              // Actions
              Padding(
                padding: const EdgeInsets.all(Spacing.md),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: exportText));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Copie dans le presse-papier'),
                              backgroundColor: AppColors.accent,
                            ),
                          );
                        },
                        icon: const Icon(Icons.copy),
                        label: const Text('Copier'),
                      ),
                    ),
                    const SizedBox(width: Spacing.sm),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Share.share(exportText)
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.share),
                        label: const Text('Partager'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
