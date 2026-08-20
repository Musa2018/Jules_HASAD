import 'package:flutter/material.dart';
import 'package:mobile/features/reporting/domain/models/report_metadata.dart';
import 'package:intl/intl.dart';

class DynamicFilterForm extends StatefulWidget {
  final ReportDefinitionMetadata metadata;
  final Function(List<ReportFilter>) onFiltersChanged;

  const DynamicFilterForm({
    super.key,
    required this.metadata,
    required this.onFiltersChanged,
  });

  @override
  State<DynamicFilterForm> createState() => _DynamicFilterFormState();
}

class _DynamicFilterFormState extends State<DynamicFilterForm> {
  final Map<String, List<String>> _filterValues = {};

  @override
  Widget build(BuildContext context) {
    final filterableFields = widget.metadata.allowedFields.values
        .where((field) => field.isFilterable)
        .toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'الفلاتر',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          ...filterableFields.map((field) => _buildFieldInput(field)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final filters = _filterValues.entries
                  .where((e) => e.value.any((v) => v.isNotEmpty))
                  .map((e) {
                final field = widget.metadata.allowedFields[e.key]!;
                return ReportFilter(
                  field: e.key,
                  operator: field.allowedOperators.first,
                  values: e.value.where((v) => v.isNotEmpty).toList(),
                );
              }).toList();
              widget.onFiltersChanged(filters);
            },
            child: const Text('تطبيق الفلاتر'),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldInput(ReportFieldMetadata field) {
    if (field.dataType == 'date') {
      return _buildDateInput(field);
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: field.fieldName,
          border: const OutlineInputBorder(),
        ),
        onChanged: (value) {
          _filterValues[field.fieldName] = [value];
        },
      ),
    );
  }

  Widget _buildDateInput(ReportFieldMetadata field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Expanded(
            child: Text(field.fieldName),
          ),
          TextButton(
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (date != null) {
                setState(() {
                  _filterValues[field.fieldName] = [DateFormat('yyyy-MM-dd').format(date)];
                });
              }
            },
            child: Text(_filterValues[field.fieldName]?.first ?? 'اختر التاريخ'),
          ),
        ],
      ),
    );
  }
}
