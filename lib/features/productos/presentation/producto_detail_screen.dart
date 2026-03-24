import 'package:flutter/material.dart';
import '../domain/producto_entity.dart';

class ProductoDetailScreen extends StatelessWidget {
  final ProductoEntity producto;

  const ProductoDetailScreen({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    String formattedDate = producto.fecha;
    try {
      final DateTime date = DateTime.parse(producto.fecha);
      formattedDate = "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
    } catch (e) {
      // Mantiene el formato original si falla el parseo
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            backgroundColor: const Color(0xFF40543C),
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                producto.objeto,
                style: const TextStyle(
                  color: Colors.white,
                  shadows: [Shadow(color: Colors.black87, blurRadius: 8)],
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Hero(
                tag: 'producto_image_${producto.id}',
                child: producto.imageUrl.isNotEmpty
                    ? Image.network(
                        producto.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _placeholderImg(),
                      )
                    : _placeholderImg(),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (producto.categoria != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF40543C).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        producto.categoria!,
                        style: const TextStyle(
                          color: Color(0xFF40543C),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  const Text(
                    'Descripción',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF40543C),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    producto.descripcion,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.grey, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Publicado el $formattedDate',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholderImg() {
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
      ),
    );
  }
}
