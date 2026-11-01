import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/haptic_service.dart';
import '../../providers/vault_provider.dart';
import 'vault_photos_view.dart';
import 'vault_notes_view.dart';
import 'vault_contacts_view.dart';
import 'vault_settings_view.dart';

class VaultHomeScreen extends StatefulWidget {
  const VaultHomeScreen({super.key});

  @override
  State<VaultHomeScreen> createState() => _VaultHomeScreenState();
}

class _VaultHomeScreenState extends State<VaultHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _views = const [
    VaultPhotosView(),
    VaultNotesView(),
    VaultContactsView(),
    VaultSettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    final vault = context.watch<VaultProvider>();

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        vault.lock();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_rounded, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                vault.isDecoyMode ? 'Guest Vault' : 'Secret Vault',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            IconButton(
              tooltip: 'Lock & Exit',
              icon: const Icon(Icons.lock_outline_rounded, color: AppColors.danger),
              onPressed: () {
                HapticService.mediumClick();
                vault.lock();
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: _views,
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            HapticService.selectionClick();
            setState(() => _currentIndex = index);
          },
          backgroundColor: AppColors.darkBackground,
          indicatorColor: AppColors.primary,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.photo_library_outlined, color: Color(0xFF94A3B8)),
              selectedIcon: Icon(Icons.photo_library_rounded, color: Colors.white),
              label: 'Photos',
            ),
            NavigationDestination(
              icon: Icon(Icons.note_alt_outlined, color: Color(0xFF94A3B8)),
              selectedIcon: Icon(Icons.note_alt_rounded, color: Colors.white),
              label: 'Notes',
            ),
            NavigationDestination(
              icon: Icon(Icons.contact_phone_outlined, color: Color(0xFF94A3B8)),
              selectedIcon: Icon(Icons.contact_phone_rounded, color: Colors.white),
              label: 'Contacts',
            ),
            NavigationDestination(
              icon: Icon(Icons.shield_outlined, color: Color(0xFF94A3B8)),
              selectedIcon: Icon(Icons.shield_rounded, color: Colors.white),
              label: 'Security',
            ),
          ],
        ),
      ),
    );
  }
}

