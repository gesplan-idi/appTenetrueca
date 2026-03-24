import 'package:flutter/material.dart';
import '../data/productos_repository.dart';
import '../domain/producto_entity.dart';

class ProductosProvider extends ChangeNotifier {
  final ProductosRepository _repository = ProductosRepository();
  final List<ProductoEntity> _productos = [];
  bool _isLoading = false;
  bool _isFetchingMore = false;
  int _currentPage = 1;
  bool _hasMore = true;

  List<CategoriaEntity> _categorias = [];
  CategoriaEntity? _selectedCategoria;

  List<ProductoEntity> get productos => _productos;
  bool get isLoading => _isLoading;
  bool get isFetchingMore => _isFetchingMore;
  bool get hasMore => _hasMore;
  List<CategoriaEntity> get categorias => _categorias;
  CategoriaEntity? get selectedCategoria => _selectedCategoria;

  Future<void> loadProductos() async {
    _isLoading = true;
    _currentPage = 1;
    _hasMore = true;
    _productos.clear();
    notifyListeners();

    if (_categorias.isEmpty) {
      _categorias = await _repository.getCategorias();
    }

    final newItems = await _repository.getProductos(
      page: _currentPage,
      categoriaId: _selectedCategoria?.id,
    );
    
    if (newItems.isEmpty) {
      _hasMore = false;
    } else {
      _productos.addAll(newItems);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMoreProductos() async {
    if (_isFetchingMore || !_hasMore) return;

    _isFetchingMore = true;
    notifyListeners();

    _currentPage++;
    final newItems = await _repository.getProductos(
      page: _currentPage,
      categoriaId: _selectedCategoria?.id,
    );
    
    if (newItems.isEmpty) {
      _hasMore = false;
    } else {
      _productos.addAll(newItems);
    }

    _isFetchingMore = false;
    notifyListeners();
  }

  void setCategoria(CategoriaEntity? categoria) {
    _selectedCategoria = categoria;
    loadProductos(); // Recarga los productos con el nuevo filtro
  }
}
