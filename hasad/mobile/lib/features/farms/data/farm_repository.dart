import 'package:mobile/features/auth/domain/auth_session.dart';
import 'package:mobile/features/farms/domain/farm.dart';

abstract class FarmRepository {
  Future<List<Farm>> getFarmsByFarmer(String farmerId);
  Future<Farm> getFarm(String id);
  Future<Farm> createFarm(Farm farm, {AuthSession? session});
  Future<Farm> updateFarm(Farm farm, {AuthSession? session});
  Future<void> deleteFarm(String id, {AuthSession? session});
}
