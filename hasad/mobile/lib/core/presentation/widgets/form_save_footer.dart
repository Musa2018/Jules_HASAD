import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';

class FormSaveFooter extends StatelessWidget {
  final bool isLoading;
  final bool isValid;
  final VoidCallback? onSave;
  final String? label;

  const FormSaveFooter({
    super.key,
    required this.isLoading,
    this.isValid = true,
    this.onSave,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -4),
            blurRadius: 8,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onSave,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(16),
          backgroundColor: isValid ? null : Colors.red,
          foregroundColor: isValid ? null : Colors.white,
          minimumSize: const Size(double.infinity, 54),
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                label ?? l10n.save,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
