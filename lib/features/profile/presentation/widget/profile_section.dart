import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store_demo_class/common/widgets/buttons/primary_button.dart';
import 'package:store_demo_class/features/auth/domain/models/user_model.dart';
import 'package:store_demo_class/features/auth/presentation/providers/auth_providers.dart';
import 'package:store_demo_class/features/home/presentation/providers/home_providers.dart';
import 'package:store_demo_class/styles/text_styles.dart';

class ProfileSection extends ConsumerStatefulWidget {
  const ProfileSection({super.key});

  @override
  ConsumerState<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends ConsumerState<ProfileSection> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    UserModel currentUser = ref.watch(userProvider);
    _nameController.text = currentUser.user.name;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(currentUser.user.email, style: AppTextStyles.textFieldStyle),
          const SizedBox(height: 20),
          CachedNetworkImage(
            imageUrl: currentUser.user.profilePic,
            imageBuilder: (context, imageProvider) =>
                CircleAvatar(radius: 100, backgroundImage: imageProvider),
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) =>
                CircleAvatar(radius: 100, child: Icon(Icons.error)),
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(labelText: "Ingresa tu nombre"),
            controller: _nameController,
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            onTap: () {
              if (_nameController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("El nombre no puede estar vacío"),
                  ),
                );
                return;
              }

              if (_nameController.text.trim() == currentUser.user.name) {
                return;
              }

              try {
                ref
                    .read(userProvider.notifier)
                    .updateName(_nameController.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Nombre actualizado correctamente"),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error al actualizar el nombre: $e")),
                );
              }
            },
            text: "Actualizar nombre",
          ),
          const SizedBox(height: 16),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              try {
                ref.read(userProvider.notifier).logout();
                ref.read(homeStateProvider.notifier).state = 'home';
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Sesión cerrada, hasta luego!")),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error al cerrar sesión: $e")),
                );
              }
            },
            child: const Text("Cerrar sesión"),
          ),
        ],
      ),
    );
  }
}
