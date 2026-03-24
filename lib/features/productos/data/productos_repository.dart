import 'package:flutter/foundation.dart';
import '../../../core/network/dio_client.dart';
import '../domain/producto_entity.dart';

class CategoriaEntity {
  final int id;
  final String name;

  CategoriaEntity({required this.id, required this.name});
}

class ProductosRepository {
  final DioClient _dioClient = DioClient.instance;

  Future<List<ProductoEntity>> getProductos({int page = 1, int? categoriaId}) async {
    try {
      final Map<String, dynamic> queryParams = {
        'page': page,
        'sort': 'Objetos.fecha',
        'direction': 'DESC',
      };

      if (categoriaId != null) {
        queryParams['categoria'] = categoriaId;
      }

      final response = await _dioClient.dio.get(
        'https://www.tenetrueca.com/services/api/objetos/catalogo',
        queryParameters: queryParams,
      );

      if (response.data != null && response.data['status'] == 'success') {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => ProductoEntity.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error obteniendo productos: $e');
      return [];
    }
  }

  Future<List<CategoriaEntity>> getCategorias() async {
    try {
      final response = await _dioClient.dio.get('https://www.tenetrueca.com/assets/data/category.json');
      if (response.data != null && response.data['data'] != null) {
        final List<dynamic> data = response.data['data'];
        List<CategoriaEntity> cats = [];
        for (var item in data) {
          cats.add(CategoriaEntity(id: item['id'], name: item['name']));
          if (item['subcategories'] != null) {
            for (var sub in item['subcategories']) {
              cats.add(CategoriaEntity(id: sub['id'], name: '  - ${sub['name']}'));
            }
          }
        }
        return cats;
      }
      return [];
    } catch (e) {
      debugPrint('Error obteniendo categorias: $e');
      return [];
    }
  }
}
