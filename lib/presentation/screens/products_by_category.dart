import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/providers.dart';

class ProductsByCategoryPage extends ConsumerStatefulWidget {
  final String title;

  const ProductsByCategoryPage({super.key, required this.title});

  @override
  ConsumerState<ProductsByCategoryPage> createState() => _ProductsByCategoryPageState();
}

class _ProductsByCategoryPageState extends ConsumerState<ProductsByCategoryPage> {
  final Map<RecordModel, int> cart = {}; // Carrito temporal

  @override
  Widget build(BuildContext context) {
    final allProductsAsyncValue = ref.watch(allProductsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  // Mostrar el contenido del carrito en un modal
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      double total = 0.0;

                      return Column(
                        children: [
                          Expanded(
                            child: ListView(
                              children:
                                  cart.entries.map((entry) {
                                    final product = entry.key;
                                    final quantity = entry.value;
                                    final price = product.data['price'] ?? 0.0;
                                    final discountedPrice = price * 0.9;
                                    final totalPrice = discountedPrice * quantity;

                                    total += totalPrice;

                                    return ListTile(
                                      title: Text(product.data['name'] ?? 'Producto'),
                                      subtitle: Text(
                                        'Cantidad: $quantity\nPrecio con descuento: \$${discountedPrice.toStringAsFixed(2)}\nTotal: \$${totalPrice.toStringAsFixed(2)}',
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Total a pagar: \$${total.toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    final message = generateWhatsAppMessage();
                                    onLaunch('https://wa.me/543875152627?text=${Uri.encodeComponent(message)}');
                                  },
                                  icon: const Icon(Icons.send),
                                  label: const Text('Enviar Pedido por WhatsApp'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              if (cart.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      '${cart.values.fold<int>(0, (sum, quantity) => sum + quantity)}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: allProductsAsyncValue.when(
        data: (products) {
          final productsByCategory = <String, List<RecordModel>>{};
          for (var product in products) {
            final category = product.data['category'] ?? 'Sin Categoría';
            if (!productsByCategory.containsKey(category)) {
              productsByCategory[category] = [];
            }
            productsByCategory[category]!.add(product);
          }

          return ListView(
            children:
                productsByCategory.entries.map((entry) {
                  final category = entry.key;
                  final categoryProducts = entry.value;

                  return ExpansionTile(
                    title: Text(category == '' ? 'Sin Categoría' : category),
                    children:
                        categoryProducts.map((product) {
                          final price = product.data['price'] ?? 0.0;
                          final discountedPrice = price * 0.9;

                          return ListTile(
                            title: Text(
                              product.data['name'] ?? 'Producto sin nombre',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Precio original: \$${price.toStringAsFixed(2)}',
                                  style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.red),
                                ),
                                Text(
                                  'Precio con descuento: \$${discountedPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    setState(() {
                                      if (cart.containsKey(product) && cart[product]! > 0) {
                                        cart[product] = cart[product]! - 1;
                                        if (cart[product] == 0) {
                                          cart.remove(product);
                                        }
                                      }
                                    });
                                  },
                                ),
                                Text('${cart[product] ?? 0}', style: const TextStyle(fontSize: 16)),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    setState(() {
                                      cart[product] = (cart[product] ?? 0) + 1;
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                  );
                }).toList(),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  String generateWhatsAppMessage() {
    if (cart.isEmpty) {
      return 'No hay productos en el carrito.';
    }

    String message = 'Nuevo Pedido:\n';
    cart.forEach((product, quantity) {
      final price = product.data['price'] ?? 0.0;
      final discountedPrice = price * 0.9;
      final totalPrice = discountedPrice * quantity;

      message +=
          '- ${product.data['name']}: \$${discountedPrice.toStringAsFixed(2)} x $quantity = \$${totalPrice.toStringAsFixed(2)}\n';
    });

    final total = cart.entries.fold<double>(
      0.0,
      (sum, entry) => sum + ((entry.key.data['price'] ?? 0.0) * 0.9 * entry.value),
    );
    message += '\nTotal: \$${total.toStringAsFixed(2)}';

    return message;
  }

  onLaunch(url, {mode = LaunchMode.externalApplication}) async {
    await launchUrl(Uri.parse(url), mode: mode);
  }

  void sendWhatsAppMessage(String message) async {
    final whatsappUrl = 'https://wa.me/543875152627?text=${Uri.encodeComponent(message)}';

    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(Uri.parse(whatsappUrl));
    } else {
      throw 'No se pudo abrir WhatsApp';
    }
  }
}
