import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/haptic_service.dart';
import '../../models/vault_item.dart';
import '../../providers/vault_provider.dart';

class VaultNotesView extends StatelessWidget {
  const VaultNotesView({super.key});

  @override
  Widget build(BuildContext context) {
    final vault = context.watch<VaultProvider>();
    final notes = vault.notes;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final df = DateFormat('dd MMM yyyy, hh:mm a');

    return Scaffold(
      body: notes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.note_alt_outlined, size: 72, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No Secret Notes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  const Text('Save secret passwords, PINs, or diary notes',
                      style: TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add Secret Note'),
                    onPressed: () => _showNoteDialog(context, vault),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: notes.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final note = notes[index];
                return Card(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => _showNoteDialog(context, vault, note: note),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  note.title,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    tooltip: 'Copy Note Content',
                                    icon: const Icon(Icons.copy_rounded, size: 18),
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(text: note.content));
                                      HapticService.lightClick();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Note copied to clipboard!'),
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    tooltip: 'Delete Note',
                                    icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.danger),
                                    onPressed: () => vault.deleteNote(note.id),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            note.content,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            df.format(note.updatedAt),
                            style: const TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'New Secret Note',
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.edit_note_rounded, color: Colors.white),
        onPressed: () => _showNoteDialog(context, vault),
      ),
    );
  }

  void _showNoteDialog(BuildContext context, VaultProvider vault, {VaultNote? note}) {
    final titleController = TextEditingController(text: note?.title ?? '');
    final contentController = TextEditingController(text: note?.content ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(note == null ? 'New Secret Note' : 'Edit Note'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title / Subject',
                  hintText: 'e.g. Bank ATM PIN, Crypto Key, Diary...',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: contentController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Secret Content',
                  hintText: 'Write confidential info here...',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (note == null) {
                vault.addNote(titleController.text, contentController.text);
              } else {
                vault.updateNote(note.id, titleController.text, contentController.text);
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
