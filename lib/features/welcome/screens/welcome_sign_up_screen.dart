import 'package:atena_events_app/core/widgets/app_logo.dart';
import 'package:atena_events_app/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';


class WelcomeSignUpScreen extends StatelessWidget {
  const WelcomeSignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              const AppLogo(),
              const SizedBox(height: 24),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  'https://picsum.photos/600/380',
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'O que fazemos?',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                'Organizamos seus eventos e compromissos, e guardamos suas lembranças',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.black54),
              ),
              const Spacer(),
              PrimaryButton(
                label: 'CADASTRAR',
                onPressed: () => Navigator.pushNamed(context, '/signup'),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Já possui conta? '),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/signin'),
                    child: const Text('ENTRAR AQUI'),
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