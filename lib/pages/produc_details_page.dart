import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:list_veiw/pages/payment_page.dart';
import 'package:list_veiw/models/product.dart';
import 'package:list_veiw/providers/payment_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final isTablet = screenSize.width >= 600 && screenSize.width < 1200;

    return ChangeNotifierProvider(
      create: (_) => PaymentProvider(),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff667eea), Color(0xff764ba2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Back button
                Padding(
                  padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                      ),
                      SizedBox(width: isSmallScreen ? 4 : 8),
                      Text(
                        'جزئیات محصول',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 20 : 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: isSmallScreen ? 12 : 16),

                // تصویر محصول
                Expanded(
                  child: Center(
                    child: Hero(
                      tag: product.id,
                      child: Container(
                        width: isSmallScreen
                            ? screenSize.width * 0.7
                            : isTablet
                            ? 280
                            : 300,
                        height: isSmallScreen
                            ? screenSize.width * 0.7
                            : isTablet
                            ? 280
                            : 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: product.imageFile != null
                              ? Image.file(
                                  product.imageFile!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                      child: Icon(
                                        product.icon,
                                        size: 80,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                )
                              : product.imagePath != null
                              ? Image.asset(
                                  product.imagePath!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                      child: Icon(
                                        product.icon,
                                        size: 80,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                )
                              : Center(
                                  child: Icon(
                                    product.icon,
                                    size: 80,
                                    color: Colors.grey,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: isSmallScreen ? 20 : 24),

                // عنوان و توضیحات
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 20 : 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 24 : 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 6 : 8),
                      Text(
                        product.description,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: isSmallScreen ? 15 : 16,
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 12 : 16),
                      Text(
                        product.price,
                        style: TextStyle(
                          color: Colors.yellowAccent,
                          fontSize: isSmallScreen ? 20 : 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: isSmallScreen ? 20 : 24),

                // دکمه خرید
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 20 : 24,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: isSmallScreen ? 48 : 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PaymentScreen(product: product),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        'خرید محصول',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: isSmallScreen ? 16 : 18,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: isSmallScreen ? 24 : 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
