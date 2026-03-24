import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../domain/objeto_entity.dart';
import '../data/objetos_repository.dart';
import 'objetos_provider.dart';

class ObjetoDetailScreen extends StatefulWidget {
  final ObjetoEntity objeto;
  final VoidCallback? onBack;

  const ObjetoDetailScreen({super.key, required this.objeto, this.onBack});

  @override
  State<ObjetoDetailScreen> createState() => _ObjetoDetailScreenState();
}

class _ObjetoDetailScreenState extends State<ObjetoDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _objetoController;
  late TextEditingController _descripcionController;
  final ImagePicker _picker = ImagePicker();

  File? _imageFile;
  CategoriaEntity? _selectedCategoria;
  CategoriaEntity? _selectedSubcategoria;
  String? _selectedEstado;

  List<CategoriaEntity> _subcategorias = [];
  final List<String> _estados = ['Nuevo', 'Usado'];

  bool get _isFormValid {
    return _objetoController.text.trim().isNotEmpty &&
        _descripcionController.text.trim().isNotEmpty &&
        _selectedCategoria != null &&
        _selectedSubcategoria != null;
    // El estado y la imagen pueden ser opcionales en edición si ya hay uno previo
  }

  void _updateState() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _objetoController = TextEditingController(text: widget.objeto.objeto);
    _descripcionController = TextEditingController(text: widget.objeto.descripcion);
    _objetoController.addListener(_updateState);
    _descripcionController.addListener(_updateState);

    if (widget.objeto.estadoConservacion == 1) {
      _selectedEstado = 'Nuevo';
    } else if (widget.objeto.estadoConservacion == 2) {
      _selectedEstado = 'Usado';
    } else {
      _selectedEstado = null;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<ObjetosProvider>();
      if (provider.categorias.isEmpty) {
        await provider.loadObjetos();
      }
      _prepopulateDropdowns(provider);
    });
  }

  void _prepopulateDropdowns(ObjetosProvider provider) {
    if (widget.objeto.categoria != null) {
      try {
        final catName = widget.objeto.categoria!;
        // Buscar categoría/subcategoría que coincida con el nombre
        final match = provider.categorias.firstWhere(
          (c) => c.name.replaceAll('  - ', '') == catName,
        );

        setState(() {
          if (match.parentId == 0) {
            _selectedCategoria = match;
            _subcategorias = provider.categorias.where((c) => c.parentId == match.id).toList();
          } else {
            // Es una subcategoría. Buscar al padre.
            final parent = provider.categorias.firstWhere((c) => c.id == match.parentId);
            _selectedCategoria = parent;
            _subcategorias = provider.categorias.where((c) => c.parentId == parent.id).toList();
            _selectedSubcategoria = match;
          }
        });
      } catch (e) {
        // No se encontró coincidencia exacta, ignorar pre-población
      }
    }
  }

  @override
  void dispose() {
    _objetoController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint('Error seleccionando imagen: $e');
    }
  }

  void _showPickOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFF40543C)),
                title: const Text('Hacer foto'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Color(0xFF40543C)),
                title: const Text('Elegir de galería'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFullScreenImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            Positioned.fill(
              child: _imageFile != null
                  ? Image.file(
                      _imageFile!, 
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Container(color: Colors.grey[900], child: const Icon(Icons.broken_image, size: 80, color: Colors.grey)),
                    )
                  : widget.objeto.imageUrl.isNotEmpty
                      ? Image.network(
                          widget.objeto.imageUrl, 
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Container(color: Colors.grey[900], child: const Icon(Icons.broken_image, size: 80, color: Colors.grey)),
                        )
                      : Container(color: Colors.grey[900], child: const Icon(Icons.image_not_supported, size: 80, color: Colors.grey)),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: CircleAvatar(
                backgroundColor: Colors.black54,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _showPickOptions(context);
                  },
                  icon: const Icon(Icons.camera_alt, color: Colors.white),
                  label: const Text('Cambiar imagen', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF40543C),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF40543C);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del objeto'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        leading: widget.onBack != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: widget.onBack,
              )
            : null,
      ),
      body: Consumer<ObjetosProvider>(
        builder: (context, provider, child) {
          final categorias = provider.categorias.where((c) => c.parentId == 0).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Imagen del objeto',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: InkWell(
                      onTap: () => _showFullScreenImage(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: _imageFile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(_imageFile!, width: 150, height: 150, fit: BoxFit.cover),
                              )
                            : widget.objeto.imageUrl.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      widget.objeto.imageUrl,
                                      width: 150,
                                      height: 150,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => _placeholderImg(),
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return const SizedBox(
                                          width: 150,
                                          height: 150,
                                          child: Center(
                                            child: SizedBox(
                                              width: 25,
                                              height: 25,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Color(0xFF40543C),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : _placeholderImg(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Center(child: Text('Toca para cambiar la imagen', style: TextStyle(color: Colors.grey, fontSize: 12))),
                  const SizedBox(height: 24),

                  _buildLabel('Objeto'),
                  TextFormField(
                    controller: _objetoController,
                    decoration: _inputDecoration('Nombre del objeto'),
                  ),
                  const SizedBox(height: 16),

                  _buildLabel('Descripción'),
                  TextFormField(
                    controller: _descripcionController,
                    maxLines: 4,
                    decoration: _inputDecoration('Descripción del objeto'),
                  ),
                  const SizedBox(height: 16),

                  _buildLabel('categorías'),
                  DropdownButtonFormField<CategoriaEntity>(
                    value: _selectedCategoria,
                    hint: const Text('Seleccione categoría'),
                    isExpanded: true,
                    decoration: _inputDecoration(''),
                    items: categorias.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedCategoria = val;
                        _subcategorias = provider.categorias.where((c) => c.parentId == val!.id).toList();
                        _selectedSubcategoria = null;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  _buildLabel('Subcategorías'),
                  DropdownButtonFormField<CategoriaEntity>(
                    value: _selectedSubcategoria,
                    hint: const Text('Seleccione subcategoría'),
                    isExpanded: true,
                    decoration: _inputDecoration(''),
                    items: _subcategorias.map((c) => DropdownMenuItem(value: c, child: Text(c.name.replaceAll('  - ', '')))).toList(),
                    onChanged: _selectedCategoria == null
                        ? null
                        : (val) => setState(() => _selectedSubcategoria = val),
                  ),
                  const SizedBox(height: 16),

                  _buildLabel('Estado de conservación'),
                  DropdownButtonFormField<String>(
                    value: _selectedEstado,
                    hint: const Text('Seleccione estado'),
                    isExpanded: true,
                    decoration: _inputDecoration(''),
                    items: _estados.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (val) => setState(() => _selectedEstado = val),
                  ),
                  const SizedBox(height: 32),

                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: _isFormValid
                          ? () {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cambios guardados (Mockup)')));
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[400],
                        disabledBackgroundColor: Colors.blue[200],
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Guardar cambios', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)));
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
    );
  }

  Widget _placeholderImg() {
    return Container(color: Colors.grey[100], child: Icon(Icons.image_outlined, size: 60, color: Colors.grey[400]));
  }
}

