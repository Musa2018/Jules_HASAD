import '../domain/reference_data.dart';

abstract class ReferenceDataRepository {
  Future<ReferenceData> getReferenceData({bool forceRefresh = false});
}
