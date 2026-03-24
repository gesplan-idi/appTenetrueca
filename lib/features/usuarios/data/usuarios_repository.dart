import 'package:flutter/foundation.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../domain/usuario_entity.dart';

class UsuariosRepository {
  final DioClient _dioClient = DioClient.instance;

  Future<List<UsuarioEntity>> getUsuarios({int page = 1}) async {
    try {
      final response = await _dioClient.dio.get(
        ApiEndpoints.usuarios,
        queryParameters: {
          'include_associations': 'Ubicaciones',
          'page': page,
          'orden': 'nombre',
          'direccion': 'asc',
        },
      );

      if (response.data != null && response.data['status'] == 'success') {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => UsuarioEntity.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error obteniendo usuarios: $e');
      return [];
    }
  }
}

