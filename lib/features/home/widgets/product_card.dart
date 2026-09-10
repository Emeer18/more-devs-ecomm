import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/features/home/controllers/cart_controller.dart';
import 'package:more_devs_do_zero/features/home/models/product_model.dart';
import 'package:more_devs_do_zero/shared/app_text_style.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  void _mostrarDetalhesProduto(BuildContext context, Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      product.imageUrl,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(product.name, style: AppTextStyle.title),
                  const SizedBox(height: 4),

                  Text(product.brand, style: AppTextStyle.smallGrey),
                  const SizedBox(height: 12),

                  Text(
                    product.description ?? 'Sem descrição disponível',
                    style: AppTextStyle.description,
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'R\$ ${product.price.toStringAsFixed(2).replaceAll('.', ',')}',
                    style: AppTextStyle.title,
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<CartController>().addToCart(product);

                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Adicionar no carrinho',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _mostrarDetalhesProduto(context, product),
      child: Container(
        width: 150,
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Skeleton.replace(
                replacement: Bone.square(size: 150),
                width: 150,
                height: 150,
                child: Image.network(
                  product.imageUrl,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(product.brand, style: AppTextStyle.smallGrey),
            Text(product.name, style: AppTextStyle.smallBlack),
            Text(
              'R\$ ${product.price.toStringAsFixed(2).replaceAll('.', ',')}',
              style: AppTextStyle.smallGreen,
            ),
          ],
        ),
      ),
    );
  }
}
