import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report_attachment.dart';
import 'package:mobile/features/damage_reports/presentation/providers/damage_reports_providers.dart';
import 'package:mobile/features/auth/presentation/auth_providers.dart';
import 'package:mobile/core/config/app_config.dart';
import 'package:mobile/core/storage/storage_providers.dart';

class AttachmentGalleryScreen extends ConsumerWidget {
  final String reportId;

  const AttachmentGalleryScreen({super.key, required this.reportId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // [LEGACY_MANUAL_REFRESH]
    // final attachmentsAsync = ref.watch(attachmentsByReportProvider(reportId));
    final reportAsync = ref.watch(damageReportStreamProvider(reportId));

    return Scaffold(
      appBar: AppBar(title: const Text('Evidence Attachments')),
      body: reportAsync.when(
        data: (report) {
          final attachments = report?.attachments ?? [];
          if (attachments.isEmpty) {
            return const Center(child: Text('No attachments yet.'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: attachments.length,
            itemBuilder: (context, index) {
              final attachment = attachments[index];
              return _AttachmentTile(attachment: attachment);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addAttachment(context, ref),
        child: const Icon(Icons.camera_alt),
      ),
    );
  }

  Future<void> _addAttachment(BuildContext context, WidgetRef ref) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );

    if (image != null) {
      final attachment = DamageReportAttachment(
        id: '',
        damageReportId: reportId,
        localPath: image.path,
      );
      await ref.read(attachmentRepositoryProvider).uploadAttachment(attachment);
      // [LEGACY_MANUAL_REFRESH]
      // ref.invalidate(attachmentsByReportProvider(reportId));
    }
  }
}

class _AttachmentTile extends ConsumerWidget {
  final DamageReportAttachment attachment;

  const _AttachmentTile({required this.attachment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        Positioned.fill(
          child: _buildPreview(ref),
        ),
        if (attachment.uploadStatus == 'pending')
          Container(
            color: Colors.black26,
            child: const Center(child: CircularProgressIndicator()),
          ),
        Positioned(
          right: 0,
          top: 0,
          child: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              await ref
                  .read(attachmentRepositoryProvider)
                  .deleteAttachment(attachment.id);
              // [LEGACY_MANUAL_REFRESH]
              // ref.invalidate(
              //   attachmentsByReportProvider(attachment.damageReportId),
              // );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPreview(WidgetRef ref) {
    // 1. Try local file first
    if (attachment.localPath.isNotEmpty && File(attachment.localPath).existsSync()) {
      return Image.file(File(attachment.localPath), fit: BoxFit.cover);
    }

    // 2. Try remote URL
    if (attachment.remotePath != null && attachment.remotePath!.isNotEmpty) {
      final String baseUrl = EnvironmentConfig.config.apiBaseUrl;
      final String serverRoot = baseUrl.endsWith('/api')
          ? baseUrl.substring(0, baseUrl.length - 4)
          : baseUrl;

      String remotePath = attachment.remotePath!;
      if (!remotePath.startsWith('/') && !remotePath.startsWith('http')) {
        remotePath = '/$remotePath';
      }

      final String fullUrl = remotePath.startsWith('http')
          ? remotePath
          : "$serverRoot$remotePath";

      final auth = ref.watch(authProvider);
      final token = auth.session?.token;

      return Image.network(
        fullUrl,
        fit: BoxFit.cover,
        headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Icon(Icons.broken_image, color: Colors.grey),
        ),
      );
    }

    return const Center(child: Icon(Icons.image_not_supported, color: Colors.grey));
  }
}
