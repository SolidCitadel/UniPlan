import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1280),
          margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                '도움말',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'UniPlan 사용 방법을 안내합니다.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 40),

              // Help Sections
              _buildHelpSection(
                '강의 목록 조회',
                '개설된 모든 강의를 조회하고 검색할 수 있습니다.',
                [
                  '• 과목명 또는 교수명으로 검색',
                  '• 캠퍼스, 전공/영역, 강의 시간, 강의실 등으로 필터링',
                  '• 이수구분(전공선택/필수/기초) 및 학점으로 필터링',
                  '• 강의를 클릭하여 강의계획서 조회 또는 희망과목에 추가',
                ],
              ),
              const SizedBox(height: 32),

              _buildHelpSection(
                '희망과목',
                '수강 신청하고자 하는 강의를 관리합니다.',
                [
                  '• 강의 목록에서 희망과목에 추가',
                  '• 우선순위(1-5) 설정',
                  '• 희망과목 목록에서 강의 제거 가능',
                ],
              ),
              const SizedBox(height: 32),

              _buildHelpSection(
                '시간표 계획',
                '희망과목을 바탕으로 시간표를 생성하고 관리합니다.',
                [
                  '• 새 시간표 생성',
                  '• 희망과목에서 강의 추가/제거',
                  '• 시간 충돌 자동 감지',
                  '• 대안 시간표 생성 (특정 과목 제외)',
                  '• 여러 시간표 시나리오 비교',
                ],
              ),
              const SizedBox(height: 32),

              _buildHelpSection(
                '시나리오 계획',
                '수강신청 실패 시나리오를 계획합니다.',
                [
                  '• 시간표에서 실패 가능성이 있는 과목 선택',
                  '• 해당 과목 실패 시 전환할 대안 시간표 지정',
                  '• 시나리오 트리 시각화',
                  '• 여러 실패 시나리오에 대한 대응 전략 수립',
                ],
              ),
              const SizedBox(height: 32),

              _buildHelpSection(
                '수강신청',
                '실제 수강신청을 시뮬레이션합니다.',
                [
                  '• 계획한 시간표 선택',
                  '• 각 과목별 신청 성공/실패 표시',
                  '• 실패 시 자동으로 대안 시간표로 전환',
                  '• 최종 수강신청 결과 확인',
                ],
              ),
              const SizedBox(height: 40),

              // Contact/Support Section
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '문의 및 지원',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '문제가 발생하거나 도움이 필요하신 경우:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '📧 이메일: support@uniplan.ac.kr',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '🌐 웹사이트: https://uniplan.ac.kr',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpSection(String title, String description, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 12),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            )),
      ],
    );
  }
}
