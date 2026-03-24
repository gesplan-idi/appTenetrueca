import 'package:flutter/material.dart';
import '../domain/usuario_entity.dart';

class UsuarioDetailScreen extends StatelessWidget {
  final UsuarioEntity usuario;

  const UsuarioDetailScreen({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF40543C);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Usuario'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header con inicial y nombre
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: primaryColor.withOpacity(0.1),
                    child: Text(
                      usuario.nombre.isNotEmpty ? usuario.nombre[0].toUpperCase() : '?',
                      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: primaryColor),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    usuario.nombreCompleto,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Chip(
                    label: Text(
                      usuario.role.toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: primaryColor,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Sección: Información Básica
            _buildSectionTitle('Información Básica'),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _buildListTile(Icons.email, 'Correo', usuario.email),
                  if (usuario.dni != null) _buildListTile(Icons.badge, 'DNI', usuario.dni!),
                  _buildListTile(Icons.stars, 'Puntos', '${usuario.puntos} pts'),
                  _buildListTile(
                    usuario.active ? Icons.check_circle : Icons.cancel,
                    'Estado',
                    usuario.active ? 'Activo' : 'Inactivo',
                    color: usuario.active ? Colors.green : Colors.red,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Sección: Ubicación Asociada
            if (usuario.ubicacion != null) ...[
              _buildSectionTitle('Ubicación Asociada'),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        usuario.ubicacion!.puntoLimpio,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor),
                      ),
                      const Divider(height: 20),
                      _buildDetailRow(Icons.location_on, 'Dirección', usuario.ubicacion!.direccion),
                      if (usuario.ubicacion!.horarios != null)
                        _buildDetailRow(Icons.access_time, 'Horarios', usuario.ubicacion!.horarios!),
                      if (usuario.ubicacion!.indicaciones != null)
                        _buildDetailRow(Icons.info_outline, 'Indicaciones', usuario.ubicacion!.indicaciones!),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, String subtitle, {Color color = const Color(0xFF40543C)}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
      dense: true,
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFF40543C)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

