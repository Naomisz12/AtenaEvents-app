import 'package:atena_events_app/providers/user_provider.dart';
import 'package:atena_events_app/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfigTab extends StatelessWidget {
  const ConfigTab({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    final userProvider = context.read<UserProvider>();
    await userProvider.logout();

    if (!context.mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRouter.welcome,
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Configurações',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          'Ajuste suas preferências e gerencie sua conta.',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.black54),
        ),
        const SizedBox(height: 30),

        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.notifications_none, color: Colors.black87),
          title: const Text('Notificações',
              style: TextStyle(fontWeight: FontWeight.w500)),
          subtitle: const Text('Gerenciar alertas e e-mails'),
          trailing: const Icon(Icons.chevron_right, color: Colors.black38),
          onTap: () {},
        ),
        const Divider(),

        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.lock_outline, color: Colors.black87),
          title: const Text('Privacidade e Segurança',
              style: TextStyle(fontWeight: FontWeight.w500)),
          subtitle: const Text('Alterar senha e gerenciar dados'),
          trailing: const Icon(Icons.chevron_right, color: Colors.black38),
          onTap: () {},
        ),
        const Divider(),

        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.info_outline, color: Colors.black87),
          title: const Text('Sobre o Aplicativo',
              style: TextStyle(fontWeight: FontWeight.w500)),
          subtitle: const Text('Versão, termos e licenças'),
          trailing: const Icon(Icons.chevron_right, color: Colors.black38),
          onTap: () {},
        ),
        const SizedBox(height: 30),

        SizedBox(
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () => _handleLogout(context),
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text(
              'Sair da Conta',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }
}
