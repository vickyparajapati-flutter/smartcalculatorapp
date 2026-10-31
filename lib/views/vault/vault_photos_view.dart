import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/haptic_service.dart';
import '../../models/vault_item.dart';
import '../../providers/vault_provider.dart';

class VaultPhotosView extends StatelessWidget {
  const VaultPhotosView({super.key});

  @override
  Widget build(BuildContext context) {
    final vault = context.watch<VaultProvider>();
    final photos = vault.photos;

    return Scaffold(
      body: photos.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.photo_library_outlined, size: 72, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No Hidden Photos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  const Text(
                    'Photos added here are hidden from phone gallery',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    icon: const Icon(Icons.add_a_photo_rounded),
                    label: const Text('Add Private Photo'),
                    onPressed: () => _pickImage(context, vault),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: photos.length,
              itemBuilder: (context, index) {
                final photo = photos[index];
                return GestureDetector(
                  onTap: () => _showPhotoDetail(context, vault, photo),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(photo.path),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey.withValues(alpha: 0.2),
                        child: const Icon(Icons.broken_image),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Hide Photo',
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add_photo_alternate_rounded, color: Colors.white),
        onPressed: () => _pickImage(context, vault),
      ),
    );
  }

  void _pickImage(BuildContext context, VaultProvider vault) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_rounded),
              title: const Text('Take Photo with Camera'),
              onTap: () async {
                Navigator.pop(ctx);
                final picker = ImagePicker();
                final file = await picker.pickImage(source: ImageSource.camera);
                if (file != null) {
                  await vault.addPhoto(file);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(ctx);
                final picker = ImagePicker();
                final file = await picker.pickImage(source: ImageSource.gallery);
                if (file != null) {
                  await vault.addPhoto(file);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPhotoDetail(BuildContext context, VaultProvider vault, VaultPhoto photo) {
    HapticService.selectionClick();
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton.filledTonal(
                  icon: const Icon(Icons.delete_forever_rounded, color: AppColors.danger),
                  onPressed: () {
                    vault.deletePhoto(photo.id);
                    Navigator.pop(ctx);
                  },
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(
                File(photo.path),
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
