import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/tokens.dart';

class ScenarioScreen extends ConsumerWidget {
  const ScenarioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(AppTokens.space4),
      child: Center(
        child: Text(
          '시나리오 화면은 시간표 플로우와 함께 구현 예정입니다.',
          style: AppTokens.body,
        ),
      ),
    );
  }
}
