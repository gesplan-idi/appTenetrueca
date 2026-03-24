import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/objetos_repository.dart';
import 'objetos_provider.dart';
import 'objeto_detail_screen.dart';
import '../domain/objeto_entity.dart';

class ObjetosScreen extends StatefulWidget {
  final Function(bool)? onViewChanged;
  const ObjetosScreen({super.key, this.onViewChanged});

  @override
  State<ObjetosScreen> createState() => _ObjetosScreenState();
}

class _ObjetosScreenState extends State<ObjetosScreen> {
  final ScrollController _scrollController = ScrollController();
  ObjetoEntity? _selectedObjeto;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ObjetosProvider>().loadObjetos();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<ObjetosProvider>().fetchMoreObjetos();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ObjetosProvider>();

    if (_selectedObjeto != null) {
      return ObjetoDetailScreen(
        objeto: _selectedObjeto!,
        onBack: () {
          widget.onViewChanged?.call(false);
          setState(() => _selectedObjeto = null);
        },
      );
    }

    return Scaffold(
      body: Column(
        children: [
          _buildFilterBar(provider),
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF40543C)))
          : provider.objetos.isEmpty
              ? const Center(child: Text('No hay Objetos en el catálogo.'))
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: provider.objetos.length + (provider.isFetchingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == provider.objetos.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: CircularProgressIndicator(color: Color(0xFF40543C)),
                        ),
                      );
                    }
                    final p = provider.objetos[index];
                    return InkWell(
                      onTap: () {
                        setState(() { _selectedObjeto = p; });
                        widget.onViewChanged?.call(true);
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          children: [
                            Hero(
                              tag: 'objeto_image_${p.id}',
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12),
                                ),
                                child: p.imageUrl.isNotEmpty
                                    ? Image.network(
                                        p.imageUrl,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) =>
                                            _buildPlaceholder(),
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return const SizedBox(
                                            width: 100,
                                            height: 100,
                                            child: Center(
                                              child: SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: Color(0xFF40543C),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : _buildPlaceholder(),
                              ),
                            ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p.objeto,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    p.descripcion,
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 14,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (p.categoria != null) ...[
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF40543C).withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        p.categoria!,
                                        style: const TextStyle(
                                          color: Color(0xFF40543C),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ]
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(ObjetosProvider provider) {
    if (provider.categorias.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: Colors.white,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Filtrar por categoría',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<CategoriaEntity>(
            isExpanded: true,
            value: provider.selectedCategoria,
            items: [
              const DropdownMenuItem<CategoriaEntity>(
                value: null,
                child: Text('Todas las categorías'),
              ),
              ...provider.categorias.map((cat) {
                return DropdownMenuItem<CategoriaEntity>(
                  value: cat,
                  child: Text(cat.name),
                );
              }),
            ],
            onChanged: (val) {
              provider.setCategoria(val);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 100,
      height: 100,
      color: Colors.grey[300],
      child: const Icon(Icons.image_not_supported, color: Colors.grey),
    );
  }
}

