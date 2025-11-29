import '../entities/registration.dart';

abstract class RegistrationRepository {
  Future<Registration?> getCurrent();
  Future<List<Registration>> getAll();
  Future<Registration> getById(int id);
  Future<Registration> start(int scenarioId);
  Future<Registration> addStep({
    required int registrationId,
    required List<int> succeeded,
    required List<int> failed,
    required List<int> canceled,
  });
  Future<Registration> complete(int registrationId);
  Future<Registration> cancel(int registrationId);
  Future<void> delete(int registrationId);
}
