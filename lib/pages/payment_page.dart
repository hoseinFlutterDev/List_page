import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:list_veiw/models/product.dart';
import 'package:list_veiw/providers/payment_provider.dart';

class PaymentScreen extends StatelessWidget {
  final Product product;

  const PaymentScreen({super.key, required this.product});

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
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isSmallScreen
                      ? double.infinity
                      : isTablet
                      ? 600
                      : 500,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                    ),

                    SizedBox(height: isSmallScreen ? 12 : 16),

                    // Product info
                    Hero(
                      tag: product.id,
                      child: Container(
                        height: isSmallScreen ? 120 : 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: product.imageFile != null
                              ? Image.file(
                                  product.imageFile!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[300],
                                      child: Icon(
                                        product.icon,
                                        size: 50,
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
                                    return Container(
                                      color: Colors.grey[300],
                                      child: Icon(
                                        product.icon,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  color: Colors.grey[300],
                                  child: Icon(
                                    product.icon,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    Text(
                      product.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 22 : 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 6 : 8),
                    Text(
                      product.price,
                      style: TextStyle(
                        color: Colors.yellowAccent,
                        fontSize: isSmallScreen ? 20 : 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: isSmallScreen ? 24 : 32),

                    // Payment form
                    Consumer<PaymentProvider>(
                      builder: (context, paymentProvider, _) {
                        return Column(
                          children: [
                            _paymentField(
                              controller: paymentProvider.cardNumberController,
                              hint: 'شماره کارت',
                              icon: Icons.credit_card,
                              isSmallScreen: isSmallScreen,
                              keyboardType: TextInputType.number,
                            ),
                            SizedBox(height: isSmallScreen ? 12 : 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _paymentField(
                                    controller:
                                        paymentProvider.expiryController,
                                    hint: 'تاریخ انقضا',
                                    icon: Icons.date_range,
                                    isSmallScreen: isSmallScreen,
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                SizedBox(width: isSmallScreen ? 12 : 16),
                                Expanded(
                                  child: _paymentField(
                                    controller: paymentProvider.cvvController,
                                    hint: 'CVV',
                                    icon: Icons.lock,
                                    isSmallScreen: isSmallScreen,
                                    keyboardType: TextInputType.number,
                                    obscureText: true,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: isSmallScreen ? 24 : 32),

                            // Pay button
                            SizedBox(
                              width: double.infinity,
                              height: isSmallScreen ? 48 : 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 2,
                                ),
                                onPressed: paymentProvider.isProcessing
                                    ? null
                                    : () async {
                                        final success = await paymentProvider
                                            .processPayment();
                                        if (success && context.mounted) {
                                          showDialog(
                                            context: context,
                                            builder: (_) => AlertDialog(
                                              title: const Text('پرداخت موفق'),
                                              content: const Text(
                                                'پرداخت شما با موفقیت انجام شد!',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('باشه'),
                                                ),
                                              ],
                                            ),
                                          );
                                        } else if (context.mounted &&
                                            paymentProvider.errorMessage !=
                                                null) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                paymentProvider.errorMessage!,
                                              ),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      },
                                child: paymentProvider.isProcessing
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.black87,
                                              ),
                                        ),
                                      )
                                    : Text(
                                        'پرداخت',
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                          fontSize: isSmallScreen ? 16 : 18,
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
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _paymentField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required bool isSmallScreen,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: isSmallScreen ? 14 : 16,
        ),
      ),
    );
  }
}
