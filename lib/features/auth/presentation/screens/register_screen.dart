import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:store_demo_class/common/image_assets/image_assets.dart';
import 'package:store_demo_class/common/widgets/buttons/primary_button.dart';
import 'package:store_demo_class/common/widgets/screens/loading_screen.dart';
import 'package:store_demo_class/common/widgets/text_fields/primary_text_field.dart';
import 'package:store_demo_class/features/auth/presentation/providers/auth_providers.dart';
import 'package:store_demo_class/styles/app_colors.dart';
import 'package:store_demo_class/styles/text_styles.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  bool isLoading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return LoadingScreen();
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 16,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(ImageAssets.store, height: 80, width: 80),
              Text("Mi Tienda - Registro", style: AppTextStyles.textTitleStyle),
              SizedBox(height: 24),
              PrimaryTextField(
                hintText: "Ingrese tu correo electrónico",
                labelText: "Correo electrónico",
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
              ),
              PrimaryTextField(
                hintText: "Ingrese tu contraseña",
                labelText: "Contraseña",
                isPassword: true,
                controller: passwordController,
              ),
              PrimaryTextField(
                hintText: "Confirma tu contraseña",
                labelText: "Confirmar contraseña",
                isPassword: true,
                controller: confirmPasswordController,
              ),
              SizedBox(height: 24),
              PrimaryButton(
                text: "REGISTRAR",
                onTap: () {
                  if (emailController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("El correo no puede estar vacio."),
                      ),
                    );
                    return;
                  }

                  if (passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("La contraseña no puede estar vacia."),
                      ),
                    );
                    return;
                  }

                  if (confirmPasswordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Por favor, confirma tu contraseña."),
                      ),
                    );
                    return;
                  }

                  if (passwordController.text !=
                      confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Las contraseñas no coinciden.")),
                    );
                    return;
                  }

                  registerUserWithEmailAndPassword(ref);
                },
              ),
              Spacer(),
              Text(
                "¿Ya tienes una cuenta?",
                style: AppTextStyles.textDescriptionStyle,
              ),
              GestureDetector(
                child: Text("INGRESAR", style: AppTextStyles.textButtonStyle),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> registerUserWithEmailAndPassword(WidgetRef ref) async {
    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      ref.read(userProvider.notifier).register(emailController.text.trim());
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Error desconocido. Por favor, inténtalo de nuevo.";
      if (e.code == 'email-already-in-use') {
        errorMessage = "El correo electrónico ya está en uso.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "El correo electrónico no es válido.";
      } else if (e.code == 'weak-password') {
        errorMessage = "La contraseña es demasiado débil.";
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
