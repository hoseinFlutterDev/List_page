import 'dart:io';
import 'package:flutter/material.dart';
import 'package:list_veiw/models/product.dart';

class ProductProvider extends ChangeNotifier {
  final List<Product> _products = [];
  final Set<String> _favorites = {};
  String _searchQuery = '';

  List<Product> get products => _products;
  Set<String> get favorites => _favorites;
  String get searchQuery => _searchQuery;

  List<Product> get filteredProducts {
    if (_searchQuery.isEmpty) {
      return _products;
    }
    return _products.where((product) {
      return product.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.price.contains(_searchQuery);
    }).toList();
  }

  bool isFavorite(String productId) {
    return _favorites.contains(productId);
  }

  void toggleFavorite(String productId) {
    if (_favorites.contains(productId)) {
      _favorites.remove(productId);
    } else {
      _favorites.add(productId);
    }
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void addProduct({
    required String title,
    required String price,
    required String description,
    String? imagePath,
    File? imageFile,
    required IconData icon,
  }) {
    final product = Product(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      price: price,
      description: description,
      imagePath: imagePath,
      imageFile: imageFile,
      icon: icon,
    );
    _products.add(product);
    notifyListeners();
  }

  void removeProduct(String id) {
    _products.removeWhere((product) => product.id == id);
    notifyListeners();
  }

  Product? getProductById(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }
}
