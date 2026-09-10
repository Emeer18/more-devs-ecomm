import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/features/home/controllers/cart_controller.dart';
import 'package:more_devs_do_zero/features/home/controllers/home_controller.dart';
import 'package:more_devs_do_zero/features/home/widgets/categories_section.dart';
import 'package:more_devs_do_zero/features/home/widgets/products_section.dart';
import 'package:more_devs_do_zero/features/login/controllers/login_controller.dart';
import 'package:more_devs_do_zero/shared/app_text_style.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static String route = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<HomeController>()
        ..getCategories()
        ..getProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<LoginController>(
          builder: (context, loginController, child) {
            return Text(
              'Olá ${loginController.user!.nome}',
              style: AppTextStyle.title,
            );
          },
        ),
        actions: [
          Consumer<CartController>(
            builder: (context, cartController, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined),
                    onPressed: () {},
                  ),
                  if (cartController.totalItems > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${cartController.totalItems}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<HomeController>(
        builder: (context, homeController, child) {
          return Column(
            children: [
              CategoriesSection(
                state: homeController.categoriesState,
                categories: homeController.categories,
              ),
              ProductsSection(
                state: homeController.productsState,
                products: homeController.products,
              ),
            ],
          );
        },
      ),
    );
  }
}
