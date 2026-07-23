import 'package:mobile/features/auth/domain/auth_session.dart';
import 'package:mobile/features/farms/domain/farm.dart';
import 'package:mobile/features/farms/domain/farm_filter.dart';

abstract class FarmRepository {
  Future<List<Farm>> getFarmsByFarmer(String farmerId);
  Future<Farm> getFarm(String id);
  Stream<Farm?> watchFarm(String id);
  Stream<List<Farm>> watchFarms({FarmFilter filter = const FarmFilter(), AuthSession? session});
  Future<Farm> createFarm(Farm farm, {AuthSession? session});
  Future<Farm> updateFarm(Farm farm, {AuthSession? session});
  Future<void> deleteFarm(String id, {AuthSession? session});
  Future<void> cancelDeleteFarm(String id);
}
