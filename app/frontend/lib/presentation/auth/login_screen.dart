import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/tokens.dart';
import '../../domain/entities/user.dart';
import 'auth_view_model.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscure = true;
  bool _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    await ref.read(authViewModelProvider.notifier).login(
          _emailController.text.trim(),
          _passwordController.text,
        );
    if (mounted) setState(() => _submitting = false);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<User?>>(authViewModelProvider, (previous, next) {
      next.whenOrNull(
        error: (e, _) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('로그인 실패: $e')),
        ),
        data: (user) {
          if (user != null) context.go('/app/courses');
        },
      );
    });

    final vm = ref.watch(authViewModelProvider);
    final isBusy = _submitting || vm.isLoading;

    return Scaffold(
      backgroundColor: AppTokens.surface,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTokens.space5),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTokens.radius5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppTokens.space5),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('UniPlan', style: AppTokens.heading, textAlign: TextAlign.center),
                      const SizedBox(height: AppTokens.space2),
                      Text(
                        '시나리오 기반 수강 등록 내비게이션',
                        style: AppTokens.body.copyWith(color: AppTokens.textWeak),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppTokens.space5),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: '이메일',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) => (v == null || v.isEmpty) ? '이메일을 입력하세요' : null,
                      ),
                      const SizedBox(height: AppTokens.space4),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: '비밀번호',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                            onPressed: () => setState(() => _obscure = !_obscure),
                          ),
                        ),
                        obscureText: _obscure,
                        validator: (v) => (v == null || v.isEmpty) ? '비밀번호를 입력하세요' : null,
                      ),
                      const SizedBox(height: AppTokens.space5),
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: isBusy ? null : _handleLogin,
                          child: isBusy
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text('로그인'),
                        ),
                      ),
                      const SizedBox(height: AppTokens.space3),
                      TextButton(
                        onPressed: () => context.go('/signup'),
                        child: const Text('회원가입으로 이동'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
