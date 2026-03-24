class ProductoEntity {
  final int id;
  final String objeto;
  final String descripcion;
  final String? directorio;
  final String? archivo;
  final String fecha;
  final String? categoria;

  ProductoEntity({
    required this.id,
    required this.objeto,
    required this.descripcion,
    this.directorio,
    this.archivo,
    required this.fecha,
    this.categoria,
  });

  String get imageUrl {
    if (directorio != null && archivo != null) {
      return 'https://www.tenetrueca.com/services/$directorio$archivo';
    }
    return ''; // URL vacía si no hay imagen
  }

  factory ProductoEntity.fromJson(Map<String, dynamic> json) {
    return ProductoEntity(
      id: json['id'] ?? 0,
      objeto: json['objeto'] ?? 'Sin nombre',
      descripcion: json['descripcion'] ?? 'Sin descripción',
      directorio: json['directorio'],
      archivo: json['archivo'],
      fecha: json['fecha'] ?? '',
      categoria: json['categoria'] != null ? json['categoria']['categoria'] : null,
    );
  }
}
