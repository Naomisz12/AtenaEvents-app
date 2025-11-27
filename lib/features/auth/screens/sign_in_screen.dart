import 'package:atena_events_app/core/widgets/primary_button.dart';
import 'package:atena_events_app/core/widgets/social_button.dart';
import 'package:atena_events_app/core/widgets/text_input.dart';
import 'package:atena_events_app/providers/user_provider.dart';
import 'package:atena_events_app/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  Future<void> _login() async {
    final provider = context.read<UserProvider>();

    try {
      await provider.login(emailCtrl.text, passCtrl.text);

      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, AppRouter.home, (_) => false);

    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Falha no login: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = context.watch<UserProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Text('Bem vindo de volta!', style: TextStyle(fontSize: 32)),
              const SizedBox(height: 24),

              const SocialButton(
                icon: Icons.facebook,
                label: 'CONTINUAR COM FACEBOOK',
              ),
              const SizedBox(height: 12),

              const SocialButton(
                icon: Icons.g_mobiledata_outlined,
                label: 'CONTINUAR COM GOOGLE',
              ),

              const SizedBox(height: 24),
              Text(
                'OU ENTRE COM O SEU EMAIL',
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(color: Colors.black54),
              ),
              const SizedBox(height: 12),

              TextInput(
                hint: 'Email',
                controller: emailCtrl,
                keyboard: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),

              TextInput(hint: 'Senha', controller: passCtrl, obscure: true),
              const SizedBox(height: 16),

              PrimaryButton(
                label: loading ? "CARREGANDO..." : "ENTRAR",
                onPressed: loading ? null : _login,
              ),

              const SizedBox(height: 10),
              TextButton(
                onPressed: () {},
                child: const Text('Esqueceu a senha?'),
              ),

              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Não tem conta? '),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/signup'),
                    child: const Text('CADASTRE-SE'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
