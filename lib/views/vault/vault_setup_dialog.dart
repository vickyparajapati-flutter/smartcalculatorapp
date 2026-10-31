import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/haptic_service.dart';
import '../../providers/vault_provider.dart';
import 'vault_home_screen.dart';

class VaultSetupDialog extends StatefulWidget {
  const VaultSetupDialog({super.key});

  static Future<void> show(BuildContext context) async {
    final vault = context.read<VaultProvider>();
    if (!vault.isConfigured) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => const VaultSetupDialog(),
      );
    } else {
      // Prompt for PIN
      await showDialog(
        context: context,
        builder: (ctx) => const _VaultUnlockDialog(),
      );
    }
  }

  @override
  State<VaultSetupDialog> createState() => _VaultSetupDialogState();
}

class _VaultSetupDialogState extends State<VaultSetupDialog> {
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  final _questionController = TextEditingController(text: 'What was your first school or pet name?');
  final _answerController = TextEditingController();

  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary,
            radius: 16,
            child: Icon(Icons.lock_rounded, color: Colors.white, size: 18),
          ),
          SizedBox(width: 10),
          Text('Setup Secret Vault', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Set a 4-digit PIN. To open the secret vault anytime, simply type your PIN on the calculator and tap = !',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _pinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 6,
              decoration: const InputDecoration(labelText: 'Set 4-Digit PIN (e.g. 7788)'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _confirmPinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 6,
              decoration: const InputDecoration(labelText: 'Confirm PIN'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _questionController,
              decoration: const InputDecoration(labelText: 'Security Question'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _answerController,
              decoration: const InputDecoration(labelText: 'Secret Answer (for PIN recovery)'),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                style: const TextStyle(color: AppColors.danger, fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(
          onPressed: _saveSetup,
          child: const Text('Enable Vault'),
        ),
      ],
    );
  }

  void _saveSetup() async {
    final pin = _pinController.text.trim();
    final confirm = _confirmPinController.text.trim();
    final question = _questionController.text.trim();
    final answer = _answerController.text.trim();

    if (pin.length < 4) {
      setState(() => _errorMessage = 'PIN must be at least 4 digits!');
      return;
    }
    if (pin != confirm) {
      setState(() => _errorMessage = 'PINs do not match!');
      return;
    }
    if (answer.isEmpty) {
      setState(() => _errorMessage = 'Please provide an answer for PIN recovery!');
      return;
    }

    final vault = context.read<VaultProvider>();
    await vault.setupVault(pin, question, answer);
    HapticService.mediumClick();

    if (mounted) {
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (_) => const VaultHomeScreen()));
    }
  }
}

class _VaultUnlockDialog extends StatefulWidget {
  const _VaultUnlockDialog();

  @override
  State<_VaultUnlockDialog> createState() => _VaultUnlockDialogState();
}

class _VaultUnlockDialogState extends State<_VaultUnlockDialog> {
  final _pinController = TextEditingController();
  String? _error;

  @override
  Widget build(BuildContext context) {
    final vault = context.watch<VaultProvider>();

    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.lock_rounded, color: AppColors.primary),
          SizedBox(width: 8),
          Text('Enter Vault PIN'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _pinController,
            keyboardType: TextInputType.number,
            obscureText: true,
            autofocus: true,
            maxLength: 6,
            decoration: const InputDecoration(hintText: 'Enter 4-digit PIN'),
          ),
          if (_error != null)
            Text(_error!, style: const TextStyle(color: AppColors.danger, fontSize: 12)),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => _showForgotPasswordDialog(context, vault),
              child: const Text('Forgot PIN?', style: TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            final res = vault.unlock(_pinController.text);
            if (res != VaultUnlockResult.failed) {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const VaultHomeScreen()));
            } else {
              setState(() => _error = 'Incorrect PIN!');
            }
          },
          child: const Text('Unlock'),
        ),
      ],
    );
  }

  void _showForgotPasswordDialog(BuildContext context, VaultProvider vault) {
    final answerController = TextEditingController();
    final newPinController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Vault PIN'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Question: ${vault.securityQuestion}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(
              controller: answerController,
              decoration: const InputDecoration(labelText: 'Your Answer'),
            ),
            const SizedBox(height: 12),
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
              final ok = await vault.resetPinWithSecurity(answerController.text, newPinController.text);
              if (!context.mounted) return;
              if (ok) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('PIN reset successfully!')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Incorrect answer!')),
                );
              }
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
