import 'package:flutter/material.dart';

import 'dart:io';

class Product {
  final String id;
  final String title;
  final String description;
  final String price;
  final String? imagePath; // برای asset images
  final File? imageFile; // برای عکس‌های انتخاب شده از گالری
  final IconData icon;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.imagePath,
    this.imageFile,
    required this.icon,
  });

  bool get hasImage => imageFile != null || imagePath != null;

  Product copyWith({
    String? id,
    String? title,
    String? description,
    String? price,
    String? imagePath,
    File? imageFile,
    IconData? icon,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imagePath: imagePath ?? this.imagePath,
      imageFile: imageFile ?? this.imageFile,
      icon: icon ?? this.icon,
    );
  }
}
