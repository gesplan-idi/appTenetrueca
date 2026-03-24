import 'package:flutter/material.dart';
import '../data/scanner_repository.dart';
import '../domain/scan_entity.dart';

class ScannerProvider extends ChangeNotifier {
  final ScannerRepository _repository = ScannerRepository();
  List<ScanEntity> _scans = [];
  bool _isLoading = false;

  List<ScanEntity> get scans => _scans;
  bool get isLoading => _isLoading;

  Future<void> loadScans() async {
    _isLoading = true;
    notifyListeners();

    _scans = await _repository.getScans();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addScan(String code) async {
    final newScan = ScanEntity(
      code: code,
      timestamp: DateTime.now(),
    );
    await _repository.saveScan(newScan);
    await loadScans(); // Recargar la lista
  }
}
