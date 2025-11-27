import 'package:atena_events_app/core/widgets/primary_button.dart';
import 'package:atena_events_app/core/widgets/social_button.dart';
import 'package:atena_events_app/core/widgets/text_input.dart';
import 'package:atena_events_app/providers/user_provider.dart';
import 'package:atena_events_app/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  final ValueNotifier<bool> acceptedTerms = ValueNotifier(false);

  String? error;

  void _validateAndSubmit() async {
    final name = nameCtrl.text.trim();
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text.trim();

    if (name.isEmpty) {
      setState(() => error = "Digite seu nome.");
      return;
    }

    if (email.isEmpty || !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      setState(() => error = "Digite um email válido.");
      return;
    }

    if (pass.length < 6) {
      setState(() => error = "A senha precisa ter ao menos 6 caracteres.");
      return;
    }

    if (!acceptedTerms.value) {
      setState(() => error = "Você precisa aceitar os termos.");
      return;
    }

    setState(() => error = null);

    try {
      final provider = context.read<UserProvider>();
      await provider.signUp(name, email, pass);

      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, AppRouter.home, (_) => false);
    } catch (e) {
      setState(() => error = "Erro ao criar conta: $e");
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
              const Text('Crie sua conta', style: TextStyle(fontSize: 32)),
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
                'OU CONTINUE COM SEU EMAIL',
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(color: Colors.black54),
              ),
              const SizedBox(height: 12),

              TextInput(hint: 'Nome', controller: nameCtrl),
              const SizedBox(height: 12),

              TextInput(
                hint: 'Email',
                controller: emailCtrl,
                keyboard: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),

              TextInput(hint: 'Senha', controller: passCtrl, obscure: true),
              const SizedBox(height: 8),

              Row(
                children: [
                  ValueListenableBuilder<bool>(
                    valueListenable: acceptedTerms,
                    builder: (_, value, __) {
                      return Checkbox(
                        value: value,
                        onChanged: (v) => acceptedTerms.value = v ?? false,
                      );
                    },
                  ),
                  const Flexible(child: Text('Li e aceito os termos')),
                ],
              ),

              const SizedBox(height: 12),

              if (error != null)
                Text(
                  error!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                  textAlign: TextAlign.center,
                ),

              const SizedBox(height: 12),

              PrimaryButton(
                label: loading ? 'CARREGANDO...' : 'CRIAR CONTA',
                onPressed: loading ? null : _validateAndSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
