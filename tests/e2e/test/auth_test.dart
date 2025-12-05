import 'package:test/test.dart';

import 'helpers/http_client.dart';

void main() {
  late EnvConfig env;
  late GatewayClient client;

  setUpAll(() async {
    env = EnvConfig.load();
    client = GatewayClient(baseUrl: env.baseUrl);

    final email = 'auth_${DateTime.now().millisecondsSinceEpoch}@test.com';
    const password = 'Test1234!';
    const name = 'E2E Auth User';
    await client.signup(email: email, password: password, name: name);
  });

  test('signup/login returns access token and me endpoint works', () async {
    expect(client.token, isNotNull);
    final me = await client.get('/api/v1/users/me');
    expect(me.statusCode, equals(200));
  });
}
