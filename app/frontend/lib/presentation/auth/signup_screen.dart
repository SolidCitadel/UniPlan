import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/tokens.dart';
import '../../domain/entities/user.dart';
import 'auth_view_model.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscure = true;
  bool _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    await ref.read(authViewModelProvider.notifier).signup(
          _emailController.text.trim(),
          _passwordController.text,
          _nameController.text.trim(),
        );
    if (mounted) setState(() => _submitting = false);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<User?>>(authViewModelProvider, (previous, next) {
      next.whenOrNull(
        error: (e, _) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입 실패: $e')),
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
                      Text('회원가입', style: AppTokens.heading, textAlign: TextAlign.center),
                      const SizedBox(height: AppTokens.space2),
                      Text(
                        '새 계정을 만들어 UniPlan을 시작하세요',
                        style: AppTokens.body.copyWith(color: AppTokens.textWeak),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppTokens.space5),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: '이름',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (v) => (v == null || v.isEmpty) ? '이름을 입력하세요' : null,
                      ),
                      const SizedBox(height: AppTokens.space4),
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
                        validator: (v) => (v == null || v.length < 8) ? '8자 이상 입력하세요' : null,
                      ),
                      const SizedBox(height: AppTokens.space5),
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: isBusy ? null : _handleSignup,
                          child: isBusy
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text('가입하기'),
                        ),
                      ),
                      const SizedBox(height: AppTokens.space3),
                      TextButton(
                        onPressed: () => context.go('/login'),
                        child: const Text('이미 계정이 있나요? 로그인'),
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
