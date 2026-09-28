// SPDX-FileCopyrightText: 2024-Present Aerogram Contributors
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluffychat/config/premium_settings.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_modal_action_popup.dart';
import 'package:fluffychat/utils/file_selector.dart';
import 'package:file_picker/file_picker.dart';

class ProfileBannerWidget extends StatefulWidget {
  final VoidCallback? onBannerChanged;
  final bool isEditable;

  const ProfileBannerWidget({
    super.key,
    this.onBannerChanged,
    this.isEditable = false,
  });

  @override
  State<ProfileBannerWidget> createState() => _ProfileBannerWidgetState();
}

class _ProfileBannerWidgetState extends State<ProfileBannerWidget> {
  String? bannerPath;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadBanner();
  }

  Future<void> _loadBanner() async {
    final path = await PremiumSettings.getProfileBannerPath();
    if (mounted) {
      setState(() => bannerPath = path);
    }
  }

  Future<void> _pickImage() async {
    try {
      XFile? imageFile;

      final actions = [
        AdaptiveModalAction(
          value: 'camera',
          label: 'Камера',
          icon: const Icon(Icons.camera_alt_outlined),
        ),
        AdaptiveModalAction(
          value: 'gallery',
          label: 'Галерея',
          icon: const Icon(Icons.photo_outlined),
        ),
      ];

      final action = await showModalActionPopup<String>(
        context: context,
        title: 'Выберите источник',
        cancelLabel: 'Отмена',
        actions: actions,
      );

      if (action == null) return;

      if (action == 'camera') {
        imageFile = await ImagePicker().pickImage(
          source: ImageSource.camera,
          imageQuality: 80,
        );
      } else {
        final result = await selectFiles(context, type: FileType.image);
        if (result.isNotEmpty) {
          imageFile = XFile(result.first.path);
        }
      }

      if (imageFile == null) return;

      setState(() => isLoading = true);

      await PremiumSettings.setProfileBannerPath(imageFile.path);
      
      setState(() {
        bannerPath = imageFile.path;
        isLoading = false;
      });

      widget.onBannerChanged?.call();
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e')),
        );
      }
    }
  }

  Future<void> _removeBanner() async {
    await PremiumSettings.removeProfileBanner();
    setState(() => bannerPath = null);
    widget.onBannerChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 140,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
          ),
          child: bannerPath != null && File(bannerPath!).existsSync()
              ? ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(16),
                  ),
                  child: Image.file(
                    File(bannerPath!),
                    fit: BoxFit.cover,
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_outlined,
                        size: 40,
                        color: Colors.grey[600],
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Профильный баннер',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
        ),
        if (widget.isEditable)
          Positioned(
            bottom: 8,
            right: 8,
            child: isLoading
                ? const CircularProgressIndicator()
                : FloatingActionButton.small(
                    onPressed: _pickImage,
                    child: const Icon(Icons.edit),
                  ),
          ),
        if (widget.isEditable && bannerPath != null)
          Positioned(
            bottom: 8,
            left: 8,
            child: FloatingActionButton.small(
              onPressed: _removeBanner,
              backgroundColor: Colors.red,
              child: const Icon(Icons.delete),
            ),
          ),
      ],
    );
  }
}
