import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:store_demo_class/common/image_assets/image_assets.dart';
import 'package:store_demo_class/common/widgets/buttons/primary_button.dart';
import 'package:store_demo_class/common/widgets/screens/loading_screen.dart';
import 'package:store_demo_class/common/widgets/text_fields/primary_text_field.dart';
import 'package:store_demo_class/features/auth/presentation/providers/auth_providers.dart';
import 'package:store_demo_class/features/auth/presentation/screens/register_screen.dart';
import 'package:store_demo_class/styles/app_colors.dart';
import 'package:store_demo_class/styles/text_styles.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool isLoading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
              Text("Mi Tienda", style: AppTextStyles.textTitleStyle),
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
              SizedBox(height: 24),
              PrimaryButton(
                text: "INGRESAR",
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

                  loginUserWithEmailAndPassword(ref);
                },
              ),
              Spacer(),
              Text(
                "¿No estás registrado?",
                style: AppTextStyles.textDescriptionStyle,
              ),
              GestureDetector(
                child: Text(
                  "REGISTRARSE",
                  style: AppTextStyles.textButtonStyle,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loginUserWithEmailAndPassword(WidgetRef ref) async {
    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      ref.read(userProvider.notifier).login(emailController.text);
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Error desconocido. Por favor, inténtalo de nuevo.";
      if (e.code == 'invalid-credential') {
        errorMessage =
            "Correo o contraseña incorrectos. Por favor, inténtalo de nuevo.";
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
