import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:list_veiw/pages/produc_details_page.dart';
import 'package:list_veiw/providers/product_provider.dart';
import 'package:list_veiw/models/product.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  late AnimationController _fabAnimationController;
  bool _isFabExpanded = false;

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _searchController.addListener(() {
      final provider = Provider.of<ProductProvider>(context, listen: false);
      provider.setSearchQuery(_searchController.text);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _searchController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 70,
      );
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطا در انتخاب عکس: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showAddProductDialog(BuildContext context) {
    _nameController.clear();
    _priceController.clear();
    _descriptionController.clear();
    _selectedImage = null;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('افزودن محصول'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_selectedImage != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(_selectedImage!, fit: BoxFit.cover),
                    ),
                  ),
                OutlinedButton.icon(
                  onPressed: () async {
                    await _pickImage();
                    setDialogState(() {});
                  },
                  icon: const Icon(Icons.image),
                  label: Text(
                    _selectedImage == null ? 'انتخاب عکس' : 'تغییر عکس',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'نام محصول',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'قیمت',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'توضیحات',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _selectedImage = null;
                Navigator.pop(context);
              },
              child: const Text('انصراف'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff667eea),
              ),
              onPressed: () {
                if (_nameController.text.isNotEmpty &&
                    _priceController.text.isNotEmpty) {
                  final productProvider = Provider.of<ProductProvider>(
                    context,
                    listen: false,
                  );
                  productProvider.addProduct(
                    title: _nameController.text,
                    price: _priceController.text,
                    description: _descriptionController.text.isEmpty
                        ? 'توضیحات کامل محصول شما اینجا قرار می‌گیرد.'
                        : _descriptionController.text,
                    imageFile: _selectedImage,
                    imagePath: _selectedImage == null
                        ? 'assets/images/image${(productProvider.products.length % 3) + 1}.png'
                        : null,
                    icon: Icons.shopping_bag,
                  );
                  _selectedImage = null;
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('لطفاً نام و قیمت محصول را وارد کنید'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text(
                'افزودن',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleFab() {
    setState(() {
      _isFabExpanded = !_isFabExpanded;
      if (_isFabExpanded) {
        _fabAnimationController.forward();
      } else {
        _fabAnimationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final products = productProvider.filteredProducts;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff667eea),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.white,
          ),
        ),
      ),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Search
              Padding(
                padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'فروشگاه',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 24 : 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () => _showAddProductDialog(context),
                          icon: const Icon(
                            Icons.add_shopping_cart,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Search Bar
                    TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'جستجوی محصول...',
                        hintStyle: const TextStyle(color: Colors.white60),
                        prefixIcon: const Icon(Icons.search, color: Colors.white70),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, color: Colors.white70),
                                onPressed: () {
                                  _searchController.clear();
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Products List
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                  ),
                  child: products.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 80,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                productProvider.searchQuery.isEmpty
                                    ? 'محصولی وجود ندارد'
                                    : 'نتیجه‌ای یافت نشد',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                productProvider.searchQuery.isEmpty
                                    ? 'برای افزودن محصول روی آیکون بالا کلیک کنید'
                                    : 'لطفاً کلمه دیگری جستجو کنید',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            await Future.delayed(const Duration(seconds: 1));
                            // Refresh will happen automatically through provider
                          },
                          child: ListView.builder(
                            padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              final product = products[index];
                              return ProductCard(
                                product: product,
                                isSmallScreen: isSmallScreen,
                                productProvider: productProvider,
                              );
                            },
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildFloatingActionButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_isFabExpanded) ...[
          _buildFabItem(
            icon: Icons.favorite,
            label: 'محصولات مورد علاقه',
            onTap: () {
              _toggleFab();
              // TODO: Navigate to favorites
            },
          ),
          const SizedBox(height: 8),
          _buildFabItem(
            icon: Icons.share,
            label: 'اشتراک‌گذاری',
            onTap: () {
              _toggleFab();
              final productProvider =
                  Provider.of<ProductProvider>(context, listen: false);
              if (productProvider.products.isNotEmpty) {
                Share.share(
                  'فروشگاه من: ${productProvider.products.length} محصول موجود است!',
                );
              }
            },
          ),
          const SizedBox(height: 8),
        ],
        FloatingActionButton(
          onPressed: _toggleFab,
          backgroundColor: const Color(0xff667eea),
          child: AnimatedRotation(
            turns: _isFabExpanded ? 0.125 : 0,
            duration: const Duration(milliseconds: 300),
            child: Icon(_isFabExpanded ? Icons.close : Icons.menu),
          ),
        ),
      ],
    );
  }

  Widget _buildFabItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return FloatingActionButton.extended(
      onPressed: onTap,
      backgroundColor: Colors.white,
      icon: Icon(icon, color: const Color(0xff667eea)),
      label: Text(
        label,
        style: const TextStyle(
          color: Color(0xff667eea),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isSmallScreen;
  final ProductProvider productProvider;

  const ProductCard({
    super.key,
    required this.product,
    required this.isSmallScreen,
    required this.productProvider,
  });

  @override
  Widget build(BuildContext context) {
    final isFavorite = productProvider.isFavorite(product.id);

    return Dismissible(
      key: Key(product.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: EdgeInsets.only(bottom: isSmallScreen ? 12 : 16),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 32,
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('حذف محصول'),
            content: const Text('آیا مطمئن هستید که می‌خواهید این محصول را حذف کنید؟'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('انصراف'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('حذف', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        productProvider.removeProduct(product.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${product.title} حذف شد'),
            action: SnackBarAction(
              label: 'بازگردانی',
              onPressed: () {
                // TODO: Implement undo
              },
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: isSmallScreen ? 12 : 16),
        padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xff667eea), Color(0xff764ba2)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // نمایش عکس یا آیکون
            if (product.hasImage)
              Container(
                width: isSmallScreen ? 50 : 60,
                height: isSmallScreen ? 50 : 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white.withOpacity(0.2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: product.imageFile != null
                      ? Image.file(
                          product.imageFile!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              product.icon,
                              color: Colors.white,
                              size: isSmallScreen ? 24 : 28,
                            );
                          },
                        )
                      : product.imagePath != null
                          ? Image.asset(
                              product.imagePath!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  product.icon,
                                  color: Colors.white,
                                  size: isSmallScreen ? 24 : 28,
                                );
                              },
                            )
                          : Icon(
                              product.icon,
                              color: Colors.white,
                              size: isSmallScreen ? 24 : 28,
                            ),
                ),
              )
            else
              Icon(
                product.icon,
                color: Colors.white,
                size: isSmallScreen ? 32 : 36,
              ),
            SizedBox(width: isSmallScreen ? 12 : 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isSmallScreen ? 16 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 4 : 6),
                  Text(
                    product.price,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: isSmallScreen ? 14 : 16,
                    ),
                  ),
                ],
              ),
            ),
            // Favorite button
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.white70,
              ),
              onPressed: () {
                productProvider.toggleFavorite(product.id);
              },
            ),
            // Buy button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 16 : 20,
                  vertical: isSmallScreen ? 10 : 12,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailsScreen(product: product),
                  ),
                );
              },
              child: Text(
                'خرید',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: isSmallScreen ? 14 : 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
