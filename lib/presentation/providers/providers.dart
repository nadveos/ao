import 'package:almacen_de_ofertas/presentation/services/api_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';

// Provider para la instancia de ApiServices
final apiServiceProvider = Provider<ApiServices>((ref) {
  return ApiServices();
});

// FutureProvider para obtener todos los productos
final allProductsProvider = FutureProvider<List<RecordModel>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return await apiService.getProducts();
});

// FutureProvider para obtener productos filtrados por categoría
final productsByCategoryProvider = FutureProvider.family<RecordModel, String>((ref, category) async {
  final apiService = ref.watch(apiServiceProvider);
  return await apiService.getProductsByCategory(category);
});