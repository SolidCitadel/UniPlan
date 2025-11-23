import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:frontend/domain/entities/user.dart';
import 'package:frontend/domain/entities/course.dart';
import 'package:frontend/domain/entities/timetable.dart';
import 'package:frontend/domain/entities/wishlist_item.dart';

const baseUrl = 'http://localhost:8080/api/v1';

void main() async {
  print('🚀 Starting STRICT API Integration Test...');

  final client = HttpClient();
  String? accessToken;
  int? createdTimetableId;
  int? firstCourseId;

  // Helper to make requests
  Future<dynamic> request(String method, String path, {Map<String, dynamic>? body, bool auth = true}) async {
    print('\n[$method] $path');
    final url = Uri.parse('$baseUrl$path');
    final req = await client.openUrl(method, url);
    req.headers.contentType = ContentType.json;
    if (auth && accessToken != null) {
      req.headers.add('Authorization', 'Bearer $accessToken');
    }
    if (body != null) {
      req.write(jsonEncode(body));
    }
    final resp = await req.close();
    final respBody = await resp.transform(utf8.decoder).join();
    
    print('Status: ${resp.statusCode}');
    if (respBody.isNotEmpty) {
      try {
        final json = jsonDecode(respBody);
        // Pretty print JSON
        // const encoder = JsonEncoder.withIndent('  ');
        // print('Response: ${encoder.convert(json)}');
        return json;
      } catch (e) {
        print('Response (Raw): $respBody');
        return respBody;
      }
    }
    return null;
  }

  try {
    // 1. Signup
    final randomId = Random().nextInt(10000);
    final username = 'user$randomId';
    final email = 'user$randomId@example.com';
    final password = 'Password123!';

    print('\n--- 1. Auth: Signup ---');
    await request('POST', '/auth/signup', body: {
      'username': username,
      'email': email,
      'password': password,
      'name': 'Test User $randomId'
    }, auth: false);

    // 2. Login
    print('\n--- 2. Auth: Login ---');
    final loginResp = await request('POST', '/auth/login', body: {
      'email': email,
      'password': password
    }, auth: false);

    if (loginResp != null && loginResp['accessToken'] != null) {
      accessToken = loginResp['accessToken'];
      print('✅ Login Successful. Token acquired.');
    } else {
      throw Exception('Login failed');
    }

    // 3. Get Profile (Validate User DTO)
    print('\n--- 3. User: Get Profile (Validate User DTO) ---');
    final userResp = await request('GET', '/users/me');
    try {
      final user = User.fromJson(userResp);
      print('✅ User DTO Validated: ${user.displayName} (${user.email})');
    } catch (e) {
      print('❌ User DTO Validation Failed: $e');
      print('JSON: $userResp');
      throw e;
    }

    // 4. Get Courses (Validate Course DTO & Search Params)
    print('\n--- 4. Courses: List & Search (Validate Course DTO) ---');
    
    // 4.1 Basic List
    print('  [4.1] Fetching all courses...');
    final coursesResp = await request('GET', '/courses');
    if (coursesResp is Map && coursesResp['content'] is List) {
      final list = coursesResp['content'] as List;
      if (list.isNotEmpty) {
        try {
          // Validate first 5 courses
          for (var i = 0; i < min(5, list.length); i++) {
            Course.fromJson(list[i]);
          }
          firstCourseId = list[0]['id'];
          final firstCourseName = list[0]['courseName'];
          print('  ✅ Course DTOs Validated. First ID: $firstCourseId, Name: $firstCourseName');

        } catch (e) {
          print('❌ Course DTO Validation Failed: $e');
          print('JSON Sample: ${list[0]}');
          throw e;
        }
      } else {
        print('⚠️ No courses found. Skipping course-related tests.');
      }
    }

    // 5. Create Timetable (Validate Timetable DTO)
    print('\n--- 5. Timetable: Create (Validate Timetable DTO) ---');
    final timetableResp = await request('POST', '/timetables', body: {
      'name': 'Test Timetable $randomId',
      'openingYear': 2025,
      'semester': '2학기'
    });
    
    if (timetableResp != null) {
      try {
        final timetable = Timetable.fromJson(timetableResp);
        createdTimetableId = timetable.id;
        print('✅ Timetable DTO Validated. ID: $createdTimetableId');
      } catch (e) {
        print('❌ Timetable DTO Validation Failed: $e');
        print('JSON: $timetableResp');
        throw e;
      }
    }

    // 6. Add Course to Timetable (Validate TimetableItem DTO)
    if (createdTimetableId != null && firstCourseId != null) {
      print('\n--- 6. Timetable: Add Course (Validate TimetableItem DTO) ---');
      final itemResp = await request('POST', '/timetables/$createdTimetableId/courses', body: {
        'courseId': firstCourseId
      });
      
      try {
        final item = TimetableItem.fromJson(itemResp);
        print('✅ TimetableItem DTO Validated: ${item.courseName}');
      } catch (e) {
        print('❌ TimetableItem DTO Validation Failed: $e');
        print('JSON: $itemResp');
        throw e;
      }
    }

    // 7. Get Timetable Details (Validate Timetable DTO with Items)
    if (createdTimetableId != null) {
      print('\n--- 7. Timetable: Get Details (Validate Timetable DTO) ---');
      final detailResp = await request('GET', '/timetables/$createdTimetableId');
      try {
        final timetable = Timetable.fromJson(detailResp);
        print('✅ Timetable Detail DTO Validated. Items: ${timetable.items.length}');
      } catch (e) {
        print('❌ Timetable Detail DTO Validation Failed: $e');
        print('JSON: $detailResp');
        throw e;
      }
    }

    // 8. Wishlist (Validate WishlistItem DTO)
    if (firstCourseId != null) {
      print('\n--- 8. Wishlist: Add (Validate WishlistItem DTO) ---');
      final wishlistResp = await request('POST', '/wishlist', body: {
        'courseId': firstCourseId,
        'priority': 1
      });
      
      try {
        final item = WishlistItem.fromJson(wishlistResp);
        print('✅ WishlistItem DTO Validated: ${item.courseName}');
      } catch (e) {
        print('❌ WishlistItem DTO Validation Failed: $e');
        print('JSON: $wishlistResp');
        throw e;
      }

      print('\n--- 9. Wishlist: List (Validate List<WishlistItem>) ---');
      final listResp = await request('GET', '/wishlist');
      if (listResp is List) {
        try {
          for (var json in listResp) {
            WishlistItem.fromJson(json);
          }
          print('✅ Wishlist List DTO Validated. Count: ${listResp.length}');
        } catch (e) {
          print('❌ Wishlist List DTO Validation Failed: $e');
          print('JSON Sample: ${listResp.isNotEmpty ? listResp[0] : "empty"}');
          throw e;
        }
      }
    }

    print('\n🎉 ALL STRICT API TESTS PASSED!');

  } catch (e) {
    print('\n❌ Test Failed: $e');
    exit(1);
  } finally {
    client.close();
  }
}
