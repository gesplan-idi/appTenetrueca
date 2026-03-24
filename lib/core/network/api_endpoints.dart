class ApiEndpoints {
  static const String baseUrl = 'https://www.tenetrueca.com';
  
  // Servicios / Rutas
  static const String serviciosUrl = '$baseUrl/services';
  static const String apiUrl = '$serviciosUrl/api';
  
  // Productos / Catálogo
  static const String catalogo = '$apiUrl/objetos/catalogo';
  static const String categorias = '$apiUrl/categorias';
  
  // Usuarios
  static const String usuarios = '$apiUrl/usuarios';
  
  // Imágenes
  static String getImageUrl(String directorio, String archivo) {
    return '$serviciosUrl/$directorio$archivo';
  }
}
