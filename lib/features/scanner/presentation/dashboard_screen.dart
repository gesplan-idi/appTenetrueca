import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'scanner_provider.dart';
import 'scanner_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ScannerProvider>().loadScans();
    });
  }

  @override
  Widget build(BuildContext context) {
    final scannerProvider = context.watch<ScannerProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Historial de Escaneos')),
      body: scannerProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : scannerProvider.scans.isEmpty
              ? const Center(child: Text('No hay escaneos todavía.'))
              : ListView.builder(
                  itemCount: scannerProvider.scans.length,
                  itemBuilder: (context, index) {
                    final scan = scannerProvider.scans[index];
                    return ListTile(
                      title: Text(scan.code),
                      subtitle: Text(scan.timestamp.toString()),
                      leading: const Icon(Icons.qr_code),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ScannerScreen()),
          );
        },
        child: const Icon(Icons.qr_code_scanner),
      ),
    );
  }
}
