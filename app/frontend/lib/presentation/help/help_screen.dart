import 'package:flutter/material.dart';

import '../../core/theme/tokens.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = _helpSections;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTokens.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('UniPlan 가이드', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: AppTokens.space3),
          Text('복잡한 수강신청, UniPlan과 함께 체계적으로 준비하세요.\n강의 탐색부터 시나리오 설계, 실전 대응까지 단계별로 안내합니다.',
              style: AppTokens.body),
          const SizedBox(height: AppTokens.space4),
          ...sections.map((s) => _HelpSection(section: s)),
        ],
      ),
    );
  }
}

class _HelpSection extends StatelessWidget {
  const _HelpSection({required this.section});

  final _Section section;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTokens.radius5)),
      margin: const EdgeInsets.only(bottom: AppTokens.space3),
      child: Padding(
        padding: const EdgeInsets.all(AppTokens.space3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(section.icon, color: AppTokens.primary),
                const SizedBox(width: AppTokens.space2),
                Text(section.title, style: AppTokens.body.copyWith(fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: AppTokens.space2),
            ...section.items.map((i) => Padding(
                  padding: const EdgeInsets.only(bottom: AppTokens.space2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('• ', style: AppTokens.body),
                      Expanded(
                        child: Text(i, style: AppTokens.body),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class _Section {
  const _Section({required this.title, required this.icon, required this.items});
  final String title;
  final IconData icon;
  final List<String> items;
}

const _helpSections = <_Section>[
  _Section(
    title: '1. 시작하기 (로그인)',
    icon: Icons.login,
    items: [
      '이메일 계정으로 로그인하여 서비스를 시작합니다.',
      '인증이 만료된 경우 다시 로그인 화면으로 이동할 수 있습니다.',
    ],
  ),
  _Section(
    title: '2. 강의 탐색',
    icon: Icons.search,
    items: [
      '과목명, 교수명, 학수번호 등으로 원하는 강의를 검색하세요.',
      '각 강의 카드의 + 버튼을 눌러 관심 있는 강의를 위시리스트에 담을 수 있습니다.',
      '담을 때 1(낮음) ~ 5(높음) 사이의 우선순위를 지정합니다.',
    ],
  ),
  _Section(
    title: '3. 위시리스트 관리',
    icon: Icons.bookmark_outline,
    items: [
      '담아둔 강의들을 우선순위별로 한눈에 확인하세요.',
      '우선순위를 변경하거나 더 이상 필요 없는 강의를 삭제하여 목록을 정비할 수 있습니다.',
    ],
  ),
  _Section(
    title: '4. 시간표 생성',
    icon: Icons.calendar_month,
    items: [
      '여러 가지 경우의 수를 대비해 다양한 시간표를 생성합니다.',
      '시간표 목록 탭에서 새 시간표를 만들고 관리하세요.',
    ],
  ),
  _Section(
    title: '5. 시간표 편집',
    icon: Icons.edit_calendar,
    items: [
      '좌측 패널: 위시리스트 과목을 상태별로 필터링하여 보여줍니다. (추가 가능: 시간 충돌 없음 / 시간 겹침: 현재 시간표와 충돌 / 제외됨: 목록에서 숨김)',
      '미리보기: 목록의 과목에 마우스를 올리면 시간표상 위치를 미리 볼 수 있습니다.',
      '배치: 과목을 클릭하여 시간표에 확정하거나 제거합니다.',
      '대안 생성: 특정 과목의 수강신청 실패를 가정하고, 해당 과목을 제외한 복사본(대안 시간표)을 생성합니다.',
    ],
  ),
  _Section(
    title: '6. 시나리오 (플랜 B)',
    icon: Icons.account_tree,
    items: [
      '수강신청 실패 상황을 가정한 대응책을 트리 구조로 시각화합니다.',
      '부모 시간표에서 특정 과목이 실패했을 때, 어떤 자식(대안) 시간표로 넘어갈지 설정합니다.',
      '실패 흐름은 붉은색 화살표로 표시되어 직관적으로 파악할 수 있습니다.',
    ],
  ),
  _Section(
    title: '7. 수강신청 실전/모의',
    icon: Icons.flag_outlined,
    items: [
      '작성한 시나리오를 바탕으로 실제 수강신청 세션을 생성합니다.',
      '진행 상태(성공/대기/실패)를 실시간으로 기록하며 다음 행동 지침을 안내받을 수 있습니다.',
    ],
  ),
  _Section(
    title: '8. 진행 상세 가이드',
    icon: Icons.checklist,
    items: [
      '상태 체크: 각 과목의 신청 결과를 클릭하여 상태(성공/대기/실패)를 변경합니다.',
      '자동 안내: 과목 실패 처리 시, 미리 설정해둔 시나리오에 따라 다음 대안 시간표를 자동으로 불러옵니다.',
      '단계 저장: 현재 시간표의 성공/실패 여부를 모두 확정한 뒤 누르세요. 결과가 저장되고 다음 시나리오(대안)로 넘어갑니다.',
    ],
  ),
];
