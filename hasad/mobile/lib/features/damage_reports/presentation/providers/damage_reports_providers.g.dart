// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'damage_reports_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$damageReportAuditLogHash() =>
    r'3b86e222376dce97ec6bfdf474cdbf279fe240dd';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [damageReportAuditLog].
@ProviderFor(damageReportAuditLog)
const damageReportAuditLogProvider = DamageReportAuditLogFamily();

/// See also [damageReportAuditLog].
class DamageReportAuditLogFamily
    extends Family<AsyncValue<List<AuditLogEntry>>> {
  /// See also [damageReportAuditLog].
  const DamageReportAuditLogFamily();

  /// See also [damageReportAuditLog].
  DamageReportAuditLogProvider call(
    String reportId,
  ) {
    return DamageReportAuditLogProvider(
      reportId,
    );
  }

  @override
  DamageReportAuditLogProvider getProviderOverride(
    covariant DamageReportAuditLogProvider provider,
  ) {
    return call(
      provider.reportId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'damageReportAuditLogProvider';
}

/// See also [damageReportAuditLog].
class DamageReportAuditLogProvider
    extends AutoDisposeFutureProvider<List<AuditLogEntry>> {
  /// See also [damageReportAuditLog].
  DamageReportAuditLogProvider(
    String reportId,
  ) : this._internal(
          (ref) => damageReportAuditLog(
            ref as DamageReportAuditLogRef,
            reportId,
          ),
          from: damageReportAuditLogProvider,
          name: r'damageReportAuditLogProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$damageReportAuditLogHash,
          dependencies: DamageReportAuditLogFamily._dependencies,
          allTransitiveDependencies:
              DamageReportAuditLogFamily._allTransitiveDependencies,
          reportId: reportId,
        );

  DamageReportAuditLogProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.reportId,
  }) : super.internal();

  final String reportId;

  @override
  Override overrideWith(
    FutureOr<List<AuditLogEntry>> Function(DamageReportAuditLogRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DamageReportAuditLogProvider._internal(
        (ref) => create(ref as DamageReportAuditLogRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        reportId: reportId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<AuditLogEntry>> createElement() {
    return _DamageReportAuditLogProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DamageReportAuditLogProvider && other.reportId == reportId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, reportId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DamageReportAuditLogRef
    on AutoDisposeFutureProviderRef<List<AuditLogEntry>> {
  /// The parameter `reportId` of this provider.
  String get reportId;
}

class _DamageReportAuditLogProviderElement
    extends AutoDisposeFutureProviderElement<List<AuditLogEntry>>
    with DamageReportAuditLogRef {
  _DamageReportAuditLogProviderElement(super.provider);

  @override
  String get reportId => (origin as DamageReportAuditLogProvider).reportId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
