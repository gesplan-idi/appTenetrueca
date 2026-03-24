import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'scanner_provider.dart';
// Import removed

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
                      leading: const Icon(Icons.qr_code, color: Color(0xFF40543C)),
                    );
                  },
                ),
    );
  }
}
