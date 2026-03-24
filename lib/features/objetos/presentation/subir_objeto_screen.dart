import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/rendering.dart';
import '../data/objetos_repository.dart';
import 'objetos_provider.dart';

class SubirObjetoScreen extends StatefulWidget {
  final Function(bool)? onFabVisibilityChanged;
  const SubirObjetoScreen({super.key, this.onFabVisibilityChanged});

  @override
  State<SubirObjetoScreen> createState() => _SubirObjetoScreenState();
}

class _SubirObjetoScreenState extends State<SubirObjetoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _objetoController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final ScrollController _scrollController = ScrollController();

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
        _selectedSubcategoria != null &&
        _selectedEstado != null &&
        _imageFile != null;
  }

  void _updateState() {
    setState(() {}); // Forzar reconstrucción para validar botón
  }

  @override
  void initState() {
    super.initState();
    _objetoController.addListener(_updateState);
    _descripcionController.addListener(_updateState);

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        widget.onFabVisibilityChanged?.call(false);
      } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
        widget.onFabVisibilityChanged?.call(true);
      }
    });

    // Cargar categorías si la lista es vacía
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ObjetosProvider>();
      if (provider.categorias.isEmpty) {
        provider.loadObjetos();
      }
    });
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

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Consumer<ObjetosProvider>(
        builder: (context, provider, child) {
          final categorias = provider.categorias.where((c) => c.parentId == 0).toList();

          return SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Subir Archivo
                  const Center(
                    child: Text(
                      'Subir archivo',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: InkWell(
                      onTap: () => _showPickOptions(context),
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
                                child: Image.file(
                                  _imageFile!,
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(Icons.image_outlined, size: 60, color: Colors.grey[400]),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'Máximo 10 MB por imagen',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Objeto (Nombre)
                  _buildLabel('Objeto'),
                  TextFormField(
                    controller: _objetoController,
                    decoration: _inputDecoration('Nombre del objeto'),
                  ),
                  const SizedBox(height: 16),

                  // Descripción
                  _buildLabel('Descripción'),
                  TextFormField(
                    controller: _descripcionController,
                    maxLines: 4,
                    decoration: _inputDecoration('Descripción del objeto'),
                  ),
                  const SizedBox(height: 16),

                  // Categorías
                  _buildLabel('Categorías'),
                  DropdownButtonFormField<CategoriaEntity>(
                    value: _selectedCategoria,
                    hint: const Text('Seleccione categoría'),
                    isExpanded: true,
                    decoration: _inputDecoration(''),
                    items: categorias.map((c) {
                      return DropdownMenuItem(value: c, child: Text(c.name));
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedCategoria = val;
                        // Filtrar subcategorías dependientes
                        _subcategorias = provider.categorias
                            .where((c) => c.parentId == val!.id)
                            .toList();
                        _selectedSubcategoria = null; // Resetear hijo
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Subcategorías
                  _buildLabel('Subcategorías'),
                  DropdownButtonFormField<CategoriaEntity>(
                    value: _selectedSubcategoria,
                    hint: const Text('Seleccione subcategoría'),
                    isExpanded: true,
                    decoration: _inputDecoration(''),
                    items: _subcategorias.map((c) {
                      // Quitar el prefijo visual '  - ' si existe
                      final cleanName = c.name.replaceAll('  - ', '');
                      return DropdownMenuItem(value: c, child: Text(cleanName));
                    }).toList(),
                    onChanged: _selectedCategoria == null
                        ? null // Deshabilitado si no hay categoría
                        : (val) {
                            setState(() => _selectedSubcategoria = val);
                          },
                  ),
                  const SizedBox(height: 16),

                  // Estado de Conservación
                  _buildLabel('Estado de conservación'),
                  DropdownButtonFormField<String>(
                    value: _selectedEstado,
                    hint: const Text('Seleccione estado'),
                    isExpanded: true,
                    decoration: _inputDecoration(''),
                    items: _estados.map((e) {
                      return DropdownMenuItem(value: e, child: Text(e));
                    }).toList(),
                    onChanged: (val) {
                      setState(() => _selectedEstado = val);
                    },
                  ),
                  const SizedBox(height: 32),

                  // Botón Subir Objeto
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: _isFormValid
                          ? () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Objeto listo para subir (Mockup)')),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[400],
                        disabledBackgroundColor: Colors.blue[200],
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Subir objeto', style: TextStyle(color: Colors.white, fontSize: 16)),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
    );
  }
}

