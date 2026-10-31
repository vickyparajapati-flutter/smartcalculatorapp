import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/haptic_service.dart';
import '../../providers/vault_provider.dart';

class VaultSettingsView extends StatelessWidget {
  const VaultSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final vault = context.watch<VaultProvider>();

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Security Status Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: AppColors.emerald,
                    radius: 22,
                    child: Icon(Icons.shield_rounded, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Vault is Protected',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 2),
                        Text(
                          'Type your secret PIN & press = on calculator',
                          style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Change Master PIN
          Card(
            child: ListTile(
              leading: const Icon(Icons.password_rounded, color: AppColors.primary),
              title: const Text('Change Master PIN'),
              subtitle: const Text('Update your 4-digit calculator unlock PIN'),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () => _showChangePinDialog(context, vault),
            ),
          ),
          const SizedBox(height: 10),

          // Setup Decoy / Fake PIN
          Card(
            child: ListTile(
              leading: const Icon(Icons.masks_rounded, color: AppColors.rose),
              title: const Text('Decoy / Fake PIN'),
              subtitle: const Text('If forced to unlock, enter this PIN to open an empty vault!'),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () => _showDecoyPinDialog(context, vault),
            ),
          ),
          const SizedBox(height: 10),

          // Security Recovery Question
          Card(
            child: ListTile(
              leading: const Icon(Icons.help_outline_rounded, color: AppColors.amber),
              title: const Text('Security Recovery Question'),
              subtitle: Text(vault.securityQuestion),
              trailing: const Icon(Icons.verified_user_rounded, color: AppColors.emerald, size: 20),
            ),
          ),
          const SizedBox(height: 24),

          // How to Unlock Guide Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 22),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Secret Vault Shortcut:\nOpen the calculator, enter your 4-digit PIN, and tap the = button. The secret vault will open instantly without anyone knowing!',
                    style: TextStyle(fontSize: 13, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showChangePinDialog(BuildContext context, VaultProvider vault) {
    final oldPinController = TextEditingController();
    final newPinController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Change Master PIN'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 6,
              decoration: const InputDecoration(labelText: 'Current PIN'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: newPinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 6,
              decoration: const InputDecoration(labelText: 'New 4-digit PIN'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              final ok = await vault.changePin(oldPinController.text, newPinController.text);
              if (!context.mounted) return;
              if (ok) {
                HapticService.mediumClick();
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('PIN updated successfully!')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Current PIN is incorrect!')),
                );
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showDecoyPinDialog(BuildContext context, VaultProvider vault) {
    final decoyController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Setup Decoy / Fake PIN'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'A decoy PIN opens a clean, empty vault with zero photos or notes. Useful if someone forces you to enter your password.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: decoyController,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 6,
              decoration: const InputDecoration(labelText: 'Decoy PIN (e.g. 0000)'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              await vault.setDecoyPin(decoyController.text);
              if (!context.mounted) return;
              HapticService.mediumClick();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Decoy PIN saved!')),
              );
            },
            child: const Text('Save Decoy PIN'),
          ),
        ],
      ),
    );
  }
}
