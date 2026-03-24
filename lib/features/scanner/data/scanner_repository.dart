import 'package:flutter/foundation.dart';
import '../../../core/database/database_helper.dart';
import '../../../core/network/dio_client.dart';
import '../domain/scan_entity.dart';

class ScannerRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final DioClient _dioClient = DioClient.instance;

  Future<List<ScanEntity>> getScans() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('scans', orderBy: 'id DESC');

    return List.generate(maps.length, (i) {
      return ScanEntity.fromMap(maps[i]);
    });
  }

  Future<void> saveScan(ScanEntity scan) async {
    final db = await _dbHelper.database;
    await db.insert('scans', scan.toMap());
    
    // Opcional: intentamos sincronizar con la API inmediatamente
    await syncScan(scan);
  }

  Future<void> syncScan(ScanEntity scan) async {
    try {
      await _dioClient.dio.post('/scans', data: scan.toMap());
    } catch (e) {
      // Manejar error de sincronización, por ejemplo, marcar como no sincronizado en DB
      debugPrint('Error al sincronizar escaneo: $e');
    }
  }
}

