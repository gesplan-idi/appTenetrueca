import 'package:flutter/foundation.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../domain/objeto_entity.dart';

class CategoriaEntity {
  final int id;
  final String name;
  final int parentId;

  CategoriaEntity({required this.id, required this.name, this.parentId = 0});
}

class ObjetosRepository {
  final DioClient _dioClient = DioClient.instance;

  Future<List<ObjetoEntity>> getObjetos({int page = 1, int? categoriaId}) async {
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
        ApiEndpoints.catalogo,
        queryParameters: queryParams,
      );

      if (response.data != null && response.data['status'] == 'success') {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => ObjetoEntity.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error obteniendo Objetos: $e');
      return [];
    }
  }

  Future<List<CategoriaEntity>> getCategorias() async {
    try {
      final response = await _dioClient.dio.get(ApiEndpoints.categorias);
      if (response.data != null && response.data['status'] == 'success') {
        final List<dynamic> data = response.data['data'] ?? [];
        List<CategoriaEntity> cats = [];
        
        // 1. Filtrar las categorias padre (parent_id == 0)
        final parents = data.where((item) => item['parent_id'] == 0 || item['parent_id'] == null).toList();
        
        for (var parent in parents) {
          cats.add(CategoriaEntity(id: parent['id'], name: parent['categoria'], parentId: 0));
          
          // 2. Buscar las subcategorías cuyo parent_id sea el del padre
          final subs = data.where((item) => item['parent_id'] == parent['id']).toList();
          for (var sub in subs) {
            cats.add(CategoriaEntity(id: sub['id'], name: '  - ${sub['categoria']}', parentId: parent['id']));
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

