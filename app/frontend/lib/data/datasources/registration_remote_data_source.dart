import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_endpoints.dart';
import '../../core/network/dio_client.dart';
import '../dtos/registration_dto.dart';

final registrationRemoteDataSourceProvider = Provider<RegistrationRemoteDataSource>((ref) {
  return RegistrationRemoteDataSource(ref.watch(dioProvider));
});

class RegistrationRemoteDataSource {
  RegistrationRemoteDataSource(this._dio);

  final Dio _dio;

  Future<RegistrationDto> startRegistration({required int scenarioId}) async {
    final resp = await _dio.post(ApiEndpoints.registrations, data: {'scenarioId': scenarioId});
    return RegistrationDto.fromJson(_normalize(resp.data as Map<String, dynamic>));
  }

  Future<RegistrationDto> getRegistration(int id) async {
    final resp = await _dio.get('${ApiEndpoints.registrations}/$id');
    return RegistrationDto.fromJson(_normalize(resp.data as Map<String, dynamic>));
  }

  Future<List<RegistrationDto>> getRegistrations() async {
    final resp = await _dio.get(ApiEndpoints.registrations);
    final data = resp.data as List;
    return data.map((e) => RegistrationDto.fromJson(_normalize(e as Map<String, dynamic>))).toList();
  }

  Future<RegistrationDto> addStep({
    required int registrationId,
    required List<int> succeededCourses,
    required List<int> failedCourses,
    required List<int> canceledCourses,
  }) async {
    final resp = await _dio.post(
      '${ApiEndpoints.registrations}/$registrationId/steps',
      data: {
        'succeededCourses': succeededCourses,
        'failedCourses': failedCourses,
        'canceledCourses': canceledCourses,
      },
    );
    return RegistrationDto.fromJson(_normalize(resp.data as Map<String, dynamic>));
  }

  Future<RegistrationDto> complete(int registrationId) async {
    final resp = await _dio.post('${ApiEndpoints.registrations}/$registrationId/complete');
    return RegistrationDto.fromJson(_normalize(resp.data as Map<String, dynamic>));
  }

  Future<RegistrationDto> cancel(int registrationId) async {
    await _dio.post('${ApiEndpoints.registrations}/$registrationId/cancel');
    final refreshed = await _dio.get('${ApiEndpoints.registrations}/$registrationId');
    return RegistrationDto.fromJson(_normalize(refreshed.data as Map<String, dynamic>));
  }

  Future<void> delete(int registrationId) async {
    await _dio.delete('${ApiEndpoints.registrations}/$registrationId');
  }

  Map<String, dynamic> _normalize(Map<String, dynamic> json) {
    List<int> normalizeList(String key) {
      final raw = json[key] as List?;
      if (raw == null) return const [];
      return raw.where((e) => e != null).map((e) => (e as num).toInt()).toList();
    }

    Map<String, dynamic> normScenario(Map<String, dynamic> m) {
      final timetable = m['timetable'] as Map<String, dynamic>?;
      final children = (m['childScenarios'] as List?) ?? const [];
      final failed = (m['failedCourseIds'] as List?) ?? const [];
      final normalizedTimetable = _normalizeTimetable(timetable ??
          {
            'id': m['timetableId'] ?? 0,
            'name': '알 수 없는 시간표',
            'openingYear': 0,
            'semester': '',
            'excludedCourses': const [],
            'items': const [],
          });
      return {
        ...m,
        'name': m['name'] ?? '알 수 없는 시나리오',
        'parentId': m['parentScenarioId'],
        'timetableId': normalizedTimetable['id'],
        'timetable': normalizedTimetable,
        'failedCourseIds': failed.where((e) => e != null).map((e) => (e as num).toInt()).toList(),
        'children': children.map((e) => normScenario(e as Map<String, dynamic>)).toList(),
      };
    }

    return {
      ...json,
      'startScenario': normScenario(json['startScenario'] as Map<String, dynamic>),
      'currentScenario': normScenario(json['currentScenario'] as Map<String, dynamic>),
      'succeededCourses': normalizeList('succeededCourses'),
      'failedCourses': normalizeList('failedCourses'),
      'canceledCourses': normalizeList('canceledCourses'),
      'steps': ((json['steps'] as List?) ?? const [])
          .map((e) {
            final m = e as Map<String, dynamic>;
            return {
              ...m,
              'succeededCourses': _listFromMap(m, 'succeededCourses'),
              'failedCourses': _listFromMap(m, 'failedCourses'),
              'canceledCourses': _listFromMap(m, 'canceledCourses'),
            };
          })
          .toList(),
    };
  }

  List<int> _listFromMap(Map<String, dynamic> json, String key) {
    final raw = json[key] as List?;
    if (raw == null) return const [];
    return raw.where((e) => e != null).map((e) => (e as num).toInt()).toList();
  }

  Map<String, dynamic> _normalizeTimetable(Map<String, dynamic> t) {
    Map<String, dynamic> normClassTime(Map<String, dynamic> c) => {
          'day': c['day']?.toString() ?? '',
          'startTime': c['startTime']?.toString() ?? '',
          'endTime': c['endTime']?.toString() ?? '',
        };

    Map<String, dynamic> normCourse(Map<String, dynamic> c) => {
          'courseId': (c['courseId'] ?? 0) is num ? (c['courseId'] as num).toInt() : 0,
          'courseName': c['courseName']?.toString() ?? '알 수 없는 과목',
          'professor': c['professor']?.toString() ?? '',
          'classroom': c['classroom']?.toString() ?? '',
          'classTimes': ((c['classTimes'] as List?) ?? const []).map((e) => normClassTime(e as Map<String, dynamic>)).toList(),
        };

    Map<String, dynamic> normItem(Map<String, dynamic> i) => {
          'id': (i['id'] ?? 0) is num ? (i['id'] as num).toInt() : 0,
          'courseId': (i['courseId'] ?? 0) is num ? (i['courseId'] as num).toInt() : 0,
          'courseName': i['courseName']?.toString() ?? '알 수 없는 과목',
          'professor': i['professor']?.toString() ?? '',
          'classroom': i['classroom']?.toString() ?? '',
          'classTimes': ((i['classTimes'] as List?) ?? const []).map((e) => normClassTime(e as Map<String, dynamic>)).toList(),
        };

    return {
      'id': (t['id'] ?? 0) is num ? (t['id'] as num).toInt() : 0,
      'name': t['name']?.toString() ?? '알 수 없는 시간표',
      'openingYear': (t['openingYear'] ?? 0) is num ? (t['openingYear'] as num).toInt() : 0,
      'semester': t['semester']?.toString() ?? '',
      'excludedCourses': ((t['excludedCourses'] as List?) ?? const []).map((e) => normCourse(e as Map<String, dynamic>)).toList(),
      'items': ((t['items'] as List?) ?? const []).map((e) => normItem(e as Map<String, dynamic>)).toList(),
    };
  }
}
