import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/session_provider.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  static const _tabs = [
    _NavTab(label: '강의 검색', path: '/app/courses', icon: Icons.search),
    _NavTab(label: '위시리스트', path: '/app/wishlist', icon: Icons.bookmark_outline),
    _NavTab(label: '시간표', path: '/app/timetables', icon: Icons.calendar_month),
    _NavTab(label: '시나리오', path: '/app/scenario', icon: Icons.account_tree),
    _NavTab(label: '수강 신청', path: '/app/registrations', icon: Icons.flag_outlined),
    _NavTab(label: '도움말', path: '/app/help', icon: Icons.help_outline),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.path;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      body: SafeArea(
        child: Column(
          children: [
            _AppHeader(
              tabs: _tabs,
              location: location,
              onLogout: () async {
                await ref.read(authStatusProvider.notifier).logout();
                // ignore: use_build_context_synchronously
                context.go('/login');
              },
            ),
            const Divider(height: 1),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppHeader extends StatelessWidget {
  const _AppHeader({required this.tabs, required this.location, required this.onLogout});

  final List<_NavTab> tabs;
  final String location;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          Row(
            children: [
              const Icon(Icons.school, color: Color(0xFF2257D8)),
              const SizedBox(width: 8),
              Text(
                'UniPlan',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(width: 24),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: tabs
                    .map(
                      (tab) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _NavChip(
                          tab: tab,
                          selected: location.startsWith(tab.path),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          IconButton(
            onPressed: onLogout,
            icon: const Icon(Icons.logout),
            tooltip: '로그아웃',
          ),
        ],
      ),
    );
  }
}

class _NavChip extends StatelessWidget {
  const _NavChip({required this.tab, required this.selected});

  final _NavTab tab;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: () => context.go(tab.path),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE6EEFF) : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          children: [
            Icon(tab.icon, size: 18, color: selected ? const Color(0xFF2257D8) : Colors.grey[700]),
            const SizedBox(width: 6),
            Text(
              tab.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? const Color(0xFF2257D8) : Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavTab {
  const _NavTab({required this.label, required this.path, required this.icon});

  final String label;
  final String path;
  final IconData icon;
}
