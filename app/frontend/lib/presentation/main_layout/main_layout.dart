import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo and Tabs
                  Row(
                    children: [
                      // Logo
                      Row(
                        children: [
                          Icon(Icons.school, size: 32, color: Colors.blue[700]),
                          const SizedBox(width: 12),
                          const Text(
                            'UniPlan',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 32),

                      // Navigation Tabs
                      _buildTab(context, '강의 목록 조회', '/courses', location),
                      _buildTab(context, '희망과목', '/wishlist', location),
                      _buildTab(context, '시간표 계획', '/planner', location),
                      _buildTab(context, '시나리오 계획', '/scenario-planner', location),
                      _buildTab(context, '수강신청', '/course-registration', location),
                      _buildTab(context, '도움말', '/help', location),
                    ],
                  ),

                  // User Menu
                  PopupMenuButton<String>(
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.person, color: Colors.blue[800]),
                    ),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'profile',
                        child: Row(
                          children: [
                            Icon(Icons.person_outline, size: 18),
                            SizedBox(width: 8),
                            Text('마이페이지'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'logout',
                        child: Row(
                          children: [
                            Icon(Icons.logout, size: 18, color: Colors.red),
                            SizedBox(width: 8),
                            Text('로그아웃', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'logout') {
                        context.go('/login');
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          // Content
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildTab(BuildContext context, String label, String path, String currentPath) {
    final isSelected = currentPath == path;

    return GestureDetector(
      onTap: () => context.go(path),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE3F2FD) : Colors.transparent,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? const Color(0xFF1565C0) : Colors.grey[700],
          ),
        ),
      ),
    );
  }
}
