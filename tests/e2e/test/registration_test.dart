import 'package:test/test.dart';
import 'package:uniplan_models/uniplan_models.dart';

import 'helpers/http_client.dart';
import 'helpers/test_context.dart';

void main() {
  final env = EnvConfig.load();
  late E2eContext ctx;

  setUpAll(() async {
    ctx = E2eContext(env);
    await ctx.signup();
  });

  tearDownAll(() async {
    await ctx.cleanup();
  });

  test('registration start returns full tree with timetable and scenarios', () async {
    final timetable = await ctx.createTimetable(
      name: 'E2E Registration Timetable',
      openingYear: DateTime.now().year,
      semester: '1',
    );

    final scenario = await ctx.createScenario(
      name: 'E2E Registration Scenario',
      timetableId: timetable.id,
    );

    final registration = await ctx.startRegistration(scenarioId: scenario.id);

    expect(registration.status, equals(RegistrationStatus.inProgress));
    expect(registration.startScenario.timetable.id, equals(timetable.id));
    expect(registration.currentScenario.timetable.excludedCourses, isNotNull);
    expect(registration.steps, isEmpty);
  });
}
