import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store_demo_class/common/image_assets/image_assets.dart';
import 'package:store_demo_class/features/cart/presentation/widgets/cart_section.dart';
import 'package:store_demo_class/features/home/presentation/providers/home_providers.dart';
import 'package:store_demo_class/features/home/presentation/widgets/bottom_navigator_bar.dart';
import 'package:store_demo_class/features/products/presentation/widgets/products_section.dart';
import 'package:store_demo_class/features/profile/presentation/widget/profile_section.dart';
import 'package:store_demo_class/styles/app_colors.dart';
import 'package:store_demo_class/styles/text_styles.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeStateProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: Row(
          spacing: 8,
          children: [
            if (homeState == 'home')
              Image.asset(ImageAssets.storeImage, height: 32, width: 32),

            if (homeState == 'home')
              Text("Mi Tienda", style: AppTextStyles.textButtonStyle),

            if (homeState == 'cart')
              Text("Carrito", style: AppTextStyles.textButtonStyle),

            if (homeState == 'profile')
              Text("Perfil", style: AppTextStyles.textButtonStyle),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (homeState == 'home') Expanded(child: ProductsSection()),
            if (homeState == 'cart') Expanded(child: CartSection()),
            if (homeState == 'profile') Expanded(child: ProfileSection()),
            BottomNavigatorBar(),
          ],
        ),
      ),
    );
  }
}
