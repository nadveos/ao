// Suggested code may be subject to a license. Learn more: ~LicenseLog:690973953.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:3491088587.
import 'package:almacen_de_ofertas/config/app_theme.dart';
import 'package:almacen_de_ofertas/presentation/screens/products_by_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:almacen_de_ofertas/config/providers/theme_provider.dart';

void main() async{
await dotenv.load(fileName: '.env');
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final isDarkTheme = ref.watch(themeProvider);

    return MaterialApp(
    debugShowCheckedModeBanner: false,
      title: 'Almacén de Ofertas',
      darkTheme: isDarkTheme ? AppTheme.darkTheme:null,
      theme: isDarkTheme ? null: AppTheme.lightTheme,
      home: const ProductsByCategoryPage(title: 'Almacén de Ofertas'),
    );
  }
}

