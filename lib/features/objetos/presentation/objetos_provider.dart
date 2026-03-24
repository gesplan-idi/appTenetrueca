import 'package:flutter/material.dart';
import '../data/objetos_repository.dart';
import '../domain/objeto_entity.dart';

class ObjetosProvider extends ChangeNotifier {
  final ObjetosRepository _repository = ObjetosRepository();
  final List<ObjetoEntity> _objetos = [];
  bool _isLoading = false;
  bool _isFetchingMore = false;
  int _currentPage = 1;
  bool _hasMore = true;

  List<CategoriaEntity> _categorias = [];
  CategoriaEntity? _selectedCategoria;

  List<ObjetoEntity> get objetos => _objetos;
  bool get isLoading => _isLoading;
  bool get isFetchingMore => _isFetchingMore;
  bool get hasMore => _hasMore;
  List<CategoriaEntity> get categorias => _categorias;
  CategoriaEntity? get selectedCategoria => _selectedCategoria;

  Future<void> loadObjetos() async {
    _isLoading = true;
    _currentPage = 1;
    _hasMore = true;
    _objetos.clear();
    notifyListeners();

    if (_categorias.isEmpty) {
      _categorias = await _repository.getCategorias();
    }

    final newItems = await _repository.getObjetos(
      page: _currentPage,
      categoriaId: _selectedCategoria?.id,
    );
    
    if (newItems.isEmpty) {
      _hasMore = false;
    } else {
      _objetos.addAll(newItems);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMoreObjetos() async {
    if (_isFetchingMore || !_hasMore) return;

    _isFetchingMore = true;
    notifyListeners();

    _currentPage++;
    final newItems = await _repository.getObjetos(
      page: _currentPage,
      categoriaId: _selectedCategoria?.id,
    );
    
    if (newItems.isEmpty) {
      _hasMore = false;
    } else {
      _objetos.addAll(newItems);
    }

    _isFetchingMore = false;
    notifyListeners();
  }

  void setCategoria(CategoriaEntity? categoria) {
    _selectedCategoria = categoria;
    loadObjetos(); // Recarga los Objetos con el nuevo filtro
  }
}

