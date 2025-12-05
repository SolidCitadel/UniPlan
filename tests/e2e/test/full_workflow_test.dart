import 'package:test/test.dart';
import 'package:uniplan_models/uniplan_models.dart';

import 'helpers/http_client.dart';
import 'helpers/test_context.dart';

void main() {
  final env = EnvConfig.load();
  late E2eContext ctx;

  setUpAll(() async {
    ctx = E2eContext(env);
    await ctx.signup(); // 새 계정 생성 포함
    await ctx.seedCourse(); // fixture course 생성
  });

  tearDownAll(() async {
    await ctx.cleanup();
  });

  test('alternative timetable respects excludedCourseIds contract', () async {
    expect(ctx.fixtureCourseId > 0, isTrue, reason: 'Fixture course must be seeded');
    final courseId = ctx.fixtureCourseId;

    final base = await ctx.createTimetable(
      name: 'E2E Base Timetable',
      openingYear: DateTime.now().year,
      semester: '1',
    );

    await ctx.addCourse(base.id, courseId);

    final alt = await ctx.createAlternativeTimetable(
      baseTimetableId: base.id,
      name: 'E2E Alternative',
      excludedCourseIds: {courseId},
    );

    // Contract: excludedCourseIds -> excludedCourses with courseId preserved
    expect(alt.excludedCourses.map((c) => c.courseId), contains(courseId));
    expect(alt.excludedCourses.firstWhere((c) => c.courseId == courseId).courseId, equals(courseId));
  });
}
