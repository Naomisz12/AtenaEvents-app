import 'package:atena_events_app/features/home/widgets/edit_profile_page.dart';
import 'package:atena_events_app/providers/user_provider.dart';
import 'package:atena_events_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  String? userName;
  String? userEmail;
  String? profileImageUrl;

  bool loading = true;
  final UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUser();
    });
  }

  Future<void> _loadUser() async {
    try {
      final userId = context.read<UserProvider>().userId;

      if (userId == null) throw Exception("Usuário inválido");

      final data = await userService.getUser(userId);

      if (data == null) throw Exception("Deslogado");

      setState(() {
        userName = data["name"];
        userEmail = data["email"];
        profileImageUrl = "https://picsum.photos/200";
      });
    } catch (e) {
      setState(() {
        userName = "Usuário";
        userEmail = "email@exemplo.com";
        profileImageUrl = "https://picsum.photos/200";
      });
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Meu Perfil',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),

        const SizedBox(height: 24),

        Center(
          child: CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(
              profileImageUrl ??
                  "https://picsum.photos/200",
            ),
            backgroundColor: Colors.grey.shade300,
          ),
        ),

        const SizedBox(height: 24),

        Text(
          loading ? "Carregando..." : userName ?? "Usuário",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),

        const SizedBox(height: 4),

        Text(
          loading ? "..." : userEmail ?? "email@exemplo.com",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black54),
        ),

        const SizedBox(height: 40),

        SizedBox(
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfilePage(
                  userName: userName ?? "Usuário",
                  userEmail: userEmail ?? "email@exemplo.com",
                  profileImageUrl: profileImageUrl ?? "https://picsum.photos/200",)
                ),
              );
            },
            icon: const Icon(Icons.edit),
            label: const Text(
              'Editar Informações',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
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
