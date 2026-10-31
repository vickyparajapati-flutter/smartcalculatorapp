import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/haptic_service.dart';
import '../../models/vault_item.dart';
import '../../providers/vault_provider.dart';

class VaultContactsView extends StatelessWidget {
  const VaultContactsView({super.key});

  @override
  Widget build(BuildContext context) {
    final vault = context.watch<VaultProvider>();
    final contacts = vault.contacts;

    return Scaffold(
      body: contacts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.contact_phone_outlined, size: 72, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No Secret Contacts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  const Text('Contacts saved here are hidden from your phonebook',
                      style: TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    icon: const Icon(Icons.person_add_rounded),
                    label: const Text('Add Private Contact'),
                    onPressed: () => _showContactDialog(context, vault),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: contacts.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                      child: Text(
                        contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(contact.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(contact.phone, style: const TextStyle(color: Colors.grey)),
                        if (contact.note != null && contact.note!.isNotEmpty)
                          Text('Note: ${contact.note!}',
                              style: const TextStyle(fontSize: 12, color: AppColors.amber)),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.copy_rounded, size: 18),
                          tooltip: 'Copy Number',
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: contact.phone));
                            HapticService.lightClick();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Phone number copied!'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.danger),
                          onPressed: () => vault.deleteContact(contact.id),
                        ),
                      ],
                    ),
                    onTap: () => _showContactDialog(context, vault, contact: contact),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'New Secret Contact',
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.person_add_rounded, color: Colors.white),
        onPressed: () => _showContactDialog(context, vault),
      ),
    );
  }

  void _showContactDialog(BuildContext context, VaultProvider vault, {VaultContact? contact}) {
    final nameController = TextEditingController(text: contact?.name ?? '');
    final phoneController = TextEditingController(text: contact?.phone ?? '');
    final noteController = TextEditingController(text: contact?.note ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(contact == null ? 'Add Private Contact' : 'Edit Contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(labelText: 'Private Note (optional)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (contact == null) {
                vault.addContact(nameController.text, phoneController.text, noteController.text);
              } else {
                vault.updateContact(contact.id, nameController.text, phoneController.text, noteController.text);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
