import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/registration.dart';
import '../../domain/repositories/registration_repository.dart';
import '../datasources/registration_remote_data_source.dart';
import '../mappers/registration_mapper.dart';
import '../dtos/registration_dto.dart';

final registrationRepositoryProvider = Provider<RegistrationRepository>((ref) {
  return RegistrationRepositoryImpl(ref.watch(registrationRemoteDataSourceProvider));
});

class RegistrationRepositoryImpl implements RegistrationRepository {
  RegistrationRepositoryImpl(this._remote);

  final RegistrationRemoteDataSource _remote;

  @override
  Future<Registration> start(int scenarioId) async {
    final dto = await _remote.startRegistration(scenarioId: scenarioId);
    return dto.toDomain();
  }

  @override
  Future<Registration?> getCurrent() async {
    final list = await _remote.getRegistrations();
    if (list.isEmpty) return null;
    list.sort((a, b) => b.id.compareTo(a.id));
    final inProgress = list.firstWhere(
      (e) => e.status == RegistrationStatusDto.inProgress,
      orElse: () => list.first,
    );
    return inProgress.toDomain();
  }

  @override
  Future<List<Registration>> getAll() async {
    final list = await _remote.getRegistrations();
    return list.map((e) => e.toDomain()).toList();
  }

  @override
  Future<Registration> getById(int id) async {
    final dto = await _remote.getRegistration(id);
    return dto.toDomain();
  }

  @override
  Future<Registration> addStep({
    required int registrationId,
    required List<int> succeeded,
    required List<int> failed,
    required List<int> canceled,
  }) async {
    final dto = await _remote.addStep(
      registrationId: registrationId,
      succeededCourses: succeeded,
      failedCourses: failed,
      canceledCourses: canceled,
    );
    return dto.toDomain();
  }

  @override
  Future<Registration> complete(int registrationId) async {
    final dto = await _remote.complete(registrationId);
    return dto.toDomain();
  }

  @override
  Future<Registration> cancel(int registrationId) async {
    final dto = await _remote.cancel(registrationId);
    return dto.toDomain();
  }

  @override
  Future<void> delete(int registrationId) {
    return _remote.delete(registrationId);
  }
}
