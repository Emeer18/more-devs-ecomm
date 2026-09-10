import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/features/home/models/product_model.dart';
import 'package:more_devs_do_zero/shared/mocks.dart';

enum ProductsByCategoryViewState { loading, success, error }

class ProductsByCategoryController extends ChangeNotifier {
  List<Product> _categoryProducts = [];
  String _query = '';

  List<Product> get categoryProducts => _categoryProducts;

  ProductsByCategoryViewState state = ProductsByCategoryViewState.loading;

  void changeState(ProductsByCategoryViewState newState) {
    state = newState;
    notifyListeners();
  }

  Future<void> getProductsByCategory(String category) async {
    changeState(ProductsByCategoryViewState.loading);
    await Future.delayed(const Duration(seconds: 3)); // simula a API

    try {
      _categoryProducts = productsJson
          .map((item) => Product.fromJson(item))
          .where((product) => product.category == category)
          .toList();

      changeState(ProductsByCategoryViewState.success);
    } catch (e) {
      changeState(ProductsByCategoryViewState.error);
    }
  }
}
