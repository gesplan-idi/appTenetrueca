class UbicacionEntity {
  final int id;
  final String puntoLimpio;
  final String direccion;
  final String lat;
  final String lon;
  final String? telefono;
  final String? email;
  final String? horarios;
  final String? indicaciones;
  final int estado;

  UbicacionEntity({
    required this.id,
    required this.puntoLimpio,
    required this.direccion,
    required this.lat,
    required this.lon,
    this.telefono,
    this.email,
    this.horarios,
    this.indicaciones,
    required this.estado,
  });

  factory UbicacionEntity.fromJson(Map<String, dynamic> json) {
    return UbicacionEntity(
      id: json['id'] ?? 0,
      puntoLimpio: json['punto_limpio'] ?? '',
      direccion: json['direccion'] ?? '',
      lat: json['lat'] ?? '0.0',
      lon: json['lon'] ?? '0.0',
      telefono: json['telefono'],
      email: json['email'],
      horarios: json['horarios'],
      indicaciones: json['indicaciones'],
      estado: json['estado'] ?? 0,
    );
  }
}

class UsuarioEntity {
  final String id;
  final String nombre;
  final String apellidos;
  final String email;
  final String? dni;
  final int puntos;
  final String role;
  final bool active;
  final bool estado;
  final String? created;
  final int? ubicacionId;
  final UbicacionEntity? ubicacion;

  UsuarioEntity({
    required this.id,
    required this.nombre,
    required this.apellidos,
    required this.email,
    this.dni,
    required this.puntos,
    required this.role,
    required this.active,
    required this.estado,
    this.created,
    this.ubicacionId,
    this.ubicacion,
  });

  String get nombreCompleto => '$nombre $apellidos'.trim();

  factory UsuarioEntity.fromJson(Map<String, dynamic> json) {
    return UsuarioEntity(
      id: json['id'] ?? '',
      nombre: json['nombre'] ?? 'Sin nombre',
      apellidos: json['apellidos'] ?? '',
      email: json['email'] ?? '',
      dni: json['dni'],
      puntos: json['puntos'] ?? 0,
      role: json['role'] ?? 'user',
      active: json['active'] ?? false,
      estado: json['estado'] ?? false,
      created: json['created'],
      ubicacionId: json['ubicacion_id'],
      ubicacion: json['ubicacion'] != null ? UbicacionEntity.fromJson(json['ubicacion']) : null,
    );
  }
}

