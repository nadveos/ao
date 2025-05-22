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
  bool isZoomed = true; // Estado para el zoom de la imagen
  @override
  Widget build(BuildContext context) {
    final allProductsAsyncValue = ref.watch(allProductsProvider);

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart, size: 40),
              onPressed: () {
                // Mostrar el contenido del carrito en un modal
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    double total = 0.0;
                    double newRealTotal = 0.0;

                    return Column(
                      children: [
                        Expanded(
                          child: ListView(
                            children:
                                cart.entries.map((entry) {
                                  final product = entry.key;
                                  final quantity = entry.value;
                                  final price = product.data['promo_price'] ?? 0.0;
                                  final realPrice = product.data['price'] ?? 0.0;
                                  final realTotal = realPrice * quantity;

                                  final totalPrice = price * quantity;
                                  newRealTotal += realTotal;
                                  total += totalPrice;

                                  return ListTile(
                                    title: Text(product.data['name'] ?? 'Producto'),
                                    subtitle: Text(
                                      'Cantidad: $quantity\nPrecio con descuento: \$${price.toStringAsFixed(2)}\nPrecio Real : \$$realPrice\nTotal: \$${totalPrice.toStringAsFixed(2)}',
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
                              Text(
                                'Estás AHORRANDO \$${(newRealTotal - total).toStringAsFixed(2)}, ',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.greenAccent,
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    cart.clear(); // Limpiar el carrito
                                  });
                                  Navigator.pop(context); // Cerrar el modal
                                },
                                icon: const Icon(Icons.delete),
                                label: const Text('Limpiar Carrito'),
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Agrega más widgets aquí, por ejemplo, un banner o un título
            Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isZoomed = !isZoomed; // Alternar entre Zoom In y Zoom Out
                  });
                },
                child: AnimatedScale(
                  scale: isZoomed ? 1.5 : 1.0, // Escala de la animación
                  duration: const Duration(milliseconds: 1200), // Duración de la animación
                  curve: Curves.easeInOut, // Curva de animación
                  child: Image.asset('assets/images/logo.png', width: double.infinity, height: 500, fit: BoxFit.fill),
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: Text(
            //     'Bienvenidos a ${widget.title}',
            //     style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            //   ),
            // ),
            const SizedBox(height: 16),
            Center(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                  color: Colors.grey.shade200,
                ),
                position: DecorationPosition.background,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Si estas en zona sur de la ciudad de Salta, hace tu pedido y recibilo en la comidad de tu hogar GRAITS.\nOtras zonas de la ciudad , con envio BONIFICADO.\nRecordá enviar tu dirección/ubicación exacta y un número de contacto alternativo para coordinar la entrega.',
                        softWrap: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                          text: '* Envío gratis en compras mayores a \$15.000',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // Ensure text color is set
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: RichText(
                        text: TextSpan(
                          text: '** Los envios son despachados por Uber Envios',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Aquí se renderiza el contenido de allProductsAsyncValue
            allProductsAsyncValue.when(
              data: (products) {
                final productsByCategory = <String, List<RecordModel>>{};
                for (var product in products) {
                  final category = product.data['category'] ?? 'Sin Categoría';
                  if (!productsByCategory.containsKey(category)) {
                    productsByCategory[category] = [];
                  }
                  productsByCategory[category]!.add(product);
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children:
                        productsByCategory.entries.map((entry) {
                          final category = entry.key;
                          final categoryProducts = entry.value;

                          return ExpansionTile(
                            title: Text(category == '' ? 'Sin Categoría' : category),
                            maintainState: true, // Mantiene el estado cuando se colapsa
                            initiallyExpanded: false,
                            children: [
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  return GridView.builder(
                                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 250,
                                      childAspectRatio: 0.8,
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 8,
                                    ),
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: categoryProducts.length,
                                    cacheExtent: 500, // Mejora el rendimiento del scroll
                                    addAutomaticKeepAlives: false, // Optimización de memoria
                                    addRepaintBoundaries: true, // Mejora el rendimiento de renderizado
                                    itemBuilder: (context, index) {
                                      final product = categoryProducts[index];
                                      final price = product.data['price'] ?? 0.0;
                                      final promoPrice = product.data['promo_price'] ?? 0.0;

                                      return Card(
                                        margin: const EdgeInsets.all(8.0),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              const Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
                                              Flexible(
                                                child: Text(
                                                  product.data['name'] ?? 'Producto sin nombre',
                                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  'Precio original: \$${price.toStringAsFixed(2)}',
                                                  style: const TextStyle(
                                                    decoration: TextDecoration.lineThrough,
                                                    color: Colors.redAccent,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  'Precio con descuento: \$${promoPrice.toStringAsFixed(2)}',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.greenAccent,
                                                  ),
                                                ),
                                              ),
                                              FittedBox(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    IconButton(
                                                      icon: const Icon(Icons.remove),
                                                      iconSize: 20,
                                                      padding: EdgeInsets.zero,
                                                      constraints: const BoxConstraints(),
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
                                                      iconSize: 20,
                                                      onPressed: () {
                                                        setState(() {
                                                          cart[product] = (cart[product] ?? 0) + 1;
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          );
                        }).toList(),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ],
        ),
      ),
    );
  }

  String generateWhatsAppMessage() {
    if (cart.isEmpty) {
      return 'No hay productos en el carrito.';
    }

    String message = 'Nuevo Pedido:\n';
    cart.forEach((product, quantity) {
      final price = product.data['promo_price'] ?? 0.0;
      final totalPrice = price * quantity;

      message += '- ${product.data['name']} x $quantity = \$${totalPrice.toStringAsFixed(2)}\n';
    });

    final total = cart.entries.fold<double>(
      0.0,
      (sum, entry) => sum + ((entry.key.data['promo_price'] ?? 0.0) * entry.value),
    );
    final realTotal = cart.entries.fold<double>(
      0.0,
      (sum, entry) => sum + ((entry.key.data['price'] ?? 0.0) * entry.value),
    );
    final discount = realTotal - total;
    message += '\nTotal Sin Descuentos: \$${realTotal.toStringAsFixed(2)}';
    message += '\nTotal: \$${total.toStringAsFixed(2)}';
    message += '\nEstás AHORRANDO \$${discount.toStringAsFixed(2)}';
    message += '\n\nPor favor, envíame tu dirección y número de contacto para coordinar la entrega.';

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
