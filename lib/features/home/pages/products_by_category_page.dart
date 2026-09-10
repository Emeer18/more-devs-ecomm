import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/features/home/controllers/cart_controller.dart';
import 'package:more_devs_do_zero/features/home/controllers/products_by_category_controller.dart';
import 'package:more_devs_do_zero/features/home/widgets/product_card.dart';
import 'package:more_devs_do_zero/shared/app_text_style.dart';
import 'package:provider/provider.dart';

class ProductsByCategoryPage extends StatefulWidget {
  const ProductsByCategoryPage({super.key, required this.categoryName});

  static const String route = '/products_by_category';

  final String categoryName;

  @override
  State<ProductsByCategoryPage> createState() => _ProductsByCategoryPageState();
}

class _ProductsByCategoryPageState extends State<ProductsByCategoryPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductsByCategoryController>().getProductsByCategory(
        widget.categoryName,
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProductsByCategoryController>();
    final marcasDisponiveis = [
      'Todas as opções',
      ...controller.categoryProducts.map((p) => p.brand).toSet(),
    ];
    String _marcaSelecionada = 'Todas as opções';

    final produtosFiltrados = controller.categoryProducts
        .where(
          (product) =>
              product.name.toLowerCase().contains(_searchTerm.toLowerCase()) &&
              (_marcaSelecionada == 'Todas as opções' ||
                  product.brand == _marcaSelecionada),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryName)),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchTerm = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Buscar',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _marcaSelecionada,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items: marcasDisponiveis.map((marca) {
                return DropdownMenuItem(value: marca, child: Text(marca));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _marcaSelecionada = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: switch (controller.state) {
                ProductsByCategoryViewState.loading => const Center(
                  child: CircularProgressIndicator(),
                ),
                ProductsByCategoryViewState.error => const Center(
                  child: Text('Problema ao resgatar produtos'),
                ),
                ProductsByCategoryViewState.success =>
                  produtosFiltrados.isEmpty
                      ? const Center(child: Text('Nenhum produto encontrado'))
                      : GridView.builder(
                          itemCount: produtosFiltrados.length,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 0.6,
                              ),
                          itemBuilder: (context, index) {
                            return ProductCard(
                              product: produtosFiltrados[index],
                            );
                          },
                        ),
              },
            ),
          ],
        ),
      ),
    );
  }
}
