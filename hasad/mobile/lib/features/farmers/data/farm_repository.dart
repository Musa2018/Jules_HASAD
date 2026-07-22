import 'package:mobile/features/farmers/domain/farm.dart';

abstract class FarmRepository {
  Future<List<Farm>> getFarmsByFarmer(String farmerId);
  Future<Farm> getFarm(String id);
  Future<Farm> createFarm(Farm farm);
  Future<Farm> updateFarm(Farm farm);
  Future<void> deleteFarm(String id);
}
