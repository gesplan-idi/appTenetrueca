import '../../../core/network/api_endpoints.dart';

class ObjetoEntity {
  final int id;
  final String objeto;
  final String descripcion;
  final String? directorio;
  final String? archivo;
  final String fecha;
  final String? categoria;
  final int? estadoConservacion;

  ObjetoEntity({
    required this.id,
    required this.objeto,
    required this.descripcion,
    this.directorio,
    this.archivo,
    required this.fecha,
    this.categoria,
    this.estadoConservacion,
  });

  String get imageUrl {
    if (directorio != null && archivo != null) {
      return ApiEndpoints.getImageUrl(directorio!, archivo!);
    }
    return ''; // URL vacía si no hay imagen
  }

  factory ObjetoEntity.fromJson(Map<String, dynamic> json) {
    return ObjetoEntity(
      id: json['id'] ?? 0,
      objeto: json['objeto'] ?? 'Sin nombre',
      descripcion: json['descripcion'] ?? 'Sin descripción',
      directorio: json['directorio'],
      archivo: json['archivo'],
      fecha: json['fecha'] ?? '',
      categoria: json['categoria'] != null ? json['categoria']['categoria'] : null,
      estadoConservacion: json['estado_conservacion'] != null 
          ? int.tryParse(json['estado_conservacion'].toString()) 
          : null,
    );
  }
}

