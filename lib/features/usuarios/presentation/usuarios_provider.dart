import 'package:flutter/material.dart';
import '../data/usuarios_repository.dart';
import '../domain/usuario_entity.dart';

class UsuariosProvider extends ChangeNotifier {
  final UsuariosRepository _repository = UsuariosRepository();
  final List<UsuarioEntity> _usuarios = [];
  bool _isLoading = false;
  bool _isFetchingMore = false;
  int _currentPage = 1;
  bool _hasMore = true;

  List<UsuarioEntity> get usuarios => _usuarios;
  bool get isLoading => _isLoading;
  bool get isFetchingMore => _isFetchingMore;
  bool get hasMore => _hasMore;

  Future<void> loadUsuarios() async {
    if (_isLoading) return;

    _isLoading = true;
    _currentPage = 1;
    _hasMore = true;
    _usuarios.clear();
    notifyListeners();

    final newItems = await _repository.getUsuarios(page: _currentPage);
    
    if (newItems.isEmpty) {
      _hasMore = false;
    } else {
      _usuarios.addAll(newItems);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMoreUsuarios() async {
    if (_isFetchingMore || !_hasMore) return;

    _isFetchingMore = true;
    notifyListeners();

    _currentPage++;
    final newItems = await _repository.getUsuarios(page: _currentPage);
    
    if (newItems.isEmpty) {
      _hasMore = false;
    } else {
      _usuarios.addAll(newItems);
    }

    _isFetchingMore = false;
    notifyListeners();
  }
}

