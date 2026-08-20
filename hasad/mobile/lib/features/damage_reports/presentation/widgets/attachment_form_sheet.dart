import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report_attachment.dart';
import 'package:mobile/features/farms/presentation/lookup_providers.dart';

class AttachmentFormSheet extends ConsumerStatefulWidget {
  final String reportId;

  const AttachmentFormSheet({super.key, required this.reportId});

  @override
  ConsumerState<AttachmentFormSheet> createState() => _AttachmentFormSheetState();
}

class _AttachmentFormSheetState extends ConsumerState<AttachmentFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dateController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  int? _selectedTypeId;
  File? _selectedFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source, imageQuality: 70);
    if (pickedFile != null) {
      setState(() {
        _selectedFile = File(pickedFile.path);
        if (_nameController.text.isEmpty) {
          _nameController.text = pickedFile.name;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("إضافة مرفق جديد", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "اسم الوثيقة", border: OutlineInputBorder()),
                validator: (v) => v == null || v.isEmpty ? "هذا الحقل مطلوب" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: "تاريخ الوثيقة",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() => _dateController.text = DateFormat('yyyy-MM-dd').format(picked));
                  }
                },
              ),
              const SizedBox(height: 16),
              ref.watch(documentTypesProvider).when(
                data: (types) {
                   if (_selectedTypeId == null && types.isNotEmpty) {
                     Future.microtask(() => setState(() => _selectedTypeId = types.first.id));
                   }
                   return DropdownButtonFormField<int>(
                    initialValue: _selectedTypeId,
                    decoration: const InputDecoration(labelText: "نوع الوثيقة", border: OutlineInputBorder()),
                    items: types.map((t) => DropdownMenuItem(
                      value: t.id,
                      child: Text(Localizations.localeOf(context).languageCode == 'ar' ? t.nameAr : t.nameEn),
                    )).toList(),
                    onChanged: (v) => setState(() => _selectedTypeId = v),
                    validator: (v) => v == null ? "هذا الحقل مطلوب" : null,
                  );
                },
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text("خطأ في تحميل الأنواع: $e"),
              ),
              const SizedBox(height: 16),
              if (_selectedFile != null)
                Container(
                  height: 150,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(image: FileImage(_selectedFile!), fit: BoxFit.cover),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("كاميرا"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text("المعرض"),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _selectedFile == null ? null : () {
                  if (_formKey.currentState!.validate()) {
                    final attachment = DamageReportAttachment(
                      id: '', // Generated in repo
                      damageReportId: widget.reportId,
                      documentName: _nameController.text.trim(),
                      documentDate: DateTime.tryParse(_dateController.text),
                      documentTypeId: _selectedTypeId ?? 0,
                      localPath: _selectedFile!.path,
                    );
                    Navigator.pop(context, attachment);
                  }
                },
                style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                child: const Text("حفظ المرفق"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
