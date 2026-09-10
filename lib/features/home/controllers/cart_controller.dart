import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/features/home/models/cart_item_model.dart';
import 'package:more_devs_do_zero/features/home/models/product_model.dart';

class CartController extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get totalItems => _items.fold(0, (soma, item) => soma + item.quantity);

  double get totalPrice => _items.fold(0, (soma, item) => soma + item.subtotal);

  void addToCart(Product product) {
    final index = _items.indexWhere(
      (item) => item.product.name == product.name,
    );

    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void increaseQuantity(CartItem item) {
    item.quantity++;
    notifyListeners();
  }

  void decreaseQuantity(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.remove(item);
    }
    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
