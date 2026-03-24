import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'scanner_provider.dart';

class ScannerScreen extends StatefulWidget {
  final VoidCallback? onScanComplete;
  
  const ScannerScreen({super.key, this.onScanComplete});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MobileScanner(
        controller: _controller,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            final code = barcode.rawValue;
            if (code != null) {
              // Guardar el escaneo
              context.read<ScannerProvider>().addScan(code);
              
              // Notificar al usuario y volver
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Código escaneado: $code')),
                );
              }

              if (widget.onScanComplete != null) {
                widget.onScanComplete!();
              }
              break;
            }
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
