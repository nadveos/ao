

import 'package:almacen_de_ofertas/config/const/env.dart';
import 'package:pocketbase/pocketbase.dart';

final pb = PocketBase(Enviroment.baseUrl);

class ApiServices {
  Future<List<RecordModel>> getProducts() async {
      final auth = await pb.collection('_superusers').authWithPassword(Enviroment.email, Enviroment.password);
    try {
      auth;
      final response = await pb.collection('products').getFullList();
      if (pb.authStore.isValid) {
        response;
      } else {
      }
    } catch (e) {
      return [];
    }

    final response = await pb.collection('products').getFullList();
    return response;
  }

  Future<RecordModel> getProductsByCategory(String category) async {
    try {
      final auth = await pb.collection('_superusers').authWithPassword(Enviroment.email, Enviroment.password);
      auth;
      final response = await pb.collection('products').getList(filter: 'category = "$category"');
      if (pb.authStore.isValid) {
        return response.items.first; // Assuming response contains a list and you want to return the first item
      } else {
        throw Exception('Authentication failed');
      }
    } catch (e) {
      throw Exception('Failed to fetch products by category');
    }
  }
}
