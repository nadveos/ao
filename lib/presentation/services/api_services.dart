// ignore_for_file: avoid_print

import 'package:pocketbase/pocketbase.dart';

final pb = PocketBase('https://negocio.meapp.com.ar');

class ApiServices {
  Future<List<RecordModel>> getProducts() async {
      final auth = await pb.collection('_superusers').authWithPassword('guta.flores@gmail.com', 'a9pvQDz4.8pua6s');
    try {
      auth;
      final response = await pb.collection('products').getFullList();
      if (pb.authStore.isValid) {
        print('User authenticated successfully');
        response;
      } else {
        print('Authentication failed');
      }
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }

    final response = await pb.collection('products').getFullList();
    return response;
  }

  Future<RecordModel> getProductsByCategory(String category) async {
    try {
      final auth = await pb.collection('_superusers').authWithPassword('guta.flores@gmail.com', 'a9pvQDz4.8pua6s');
      auth;
      final response = await pb.collection('products').getList(filter: 'category = "$category"');
      if (pb.authStore.isValid) {
        print('User authenticated successfully');
        print(response);
        return response.items.first; // Assuming response contains a list and you want to return the first item
      } else {
        print('Authentication failed');
        throw Exception('Authentication failed');
      }
    } catch (e) {
      print('Error fetching products: $e');
      throw Exception('Failed to fetch products by category');
    }
  }
}
