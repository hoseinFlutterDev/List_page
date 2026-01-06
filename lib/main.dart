import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:list_veiw/pages/home_page.dart';
import 'package:list_veiw/providers/auth_provider.dart';
import 'package:list_veiw/providers/product_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: MaterialApp(
        title: 'فروشگاه',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff667eea)),
        ),
        home: const OnboardingScreen(),
      ),
    );
  }
}
