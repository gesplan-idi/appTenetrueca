import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../features/auth/presentation/auth_provider.dart';
import '../../../features/scanner/presentation/dashboard_screen.dart';
import '../../../features/scanner/presentation/scanner_screen.dart';
import '../../../features/scanner/presentation/scanner_provider.dart';
import '../../../features/productos/presentation/productos_screen.dart';
import '../../../features/productos/presentation/productos_provider.dart';
import 'widgets/custom_app_bar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ScannerProvider()),
        ChangeNotifierProvider(create: (_) => ProductosProvider()),
      ],
      child: const _MainScreenContent(),
    );
  }
}

class _MainScreenContent extends StatefulWidget {
  const _MainScreenContent();

  @override
  State<_MainScreenContent> createState() => _MainScreenContentState();
}

class _MainScreenContentState extends State<_MainScreenContent> {
  int _currentIndex = 1;

  List<Widget> get _screens => [
    const ProductosScreen(), // 0
    const DashboardScreen(), // 1
    const Center(child: Text('Pantalla de Ajustes Próximamente')), // 2
    ScannerScreen(
      onScanComplete: () {
        setState(() => _currentIndex = 1); // Va al historial tras escanear
      },
    ), // 3
  ];

  final List<String> _titles = [
    'Catálogo de Productos',
    'Historial de Escaneos',
    'Ajustes',
    'Escanear Código QR',
  ];

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF40543C);

    return Scaffold(
      appBar: CustomAppBar(title: _titles[_currentIndex]),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: primaryColor,
              ),
              child: Text(
                'TeneTrueca',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.storefront, color: primaryColor),
              title: const Text('Productos'),
              onTap: () {
                setState(() => _currentIndex = 0);
                Navigator.pop(context); // Close drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.history, color: primaryColor),
              title: const Text('Historial'),
              onTap: () {
                setState(() => _currentIndex = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: primaryColor),
              title: const Text('Ajustes'),
              onTap: () {
                setState(() => _currentIndex = 2);
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: primaryColor),
              title: const Text('Salir'),
              onTap: () {
                Navigator.pop(context);
                context.read<AuthProvider>().logout();
              },
            ),
          ],
        ),
      ),
      body: _screens[_currentIndex],
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        shape: const CircleBorder(),
        onPressed: () {
          if (_currentIndex != 3) {
            setState(() => _currentIndex = 3);
          }
        },
        child: const Icon(Icons.qr_code_scanner, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: SizedBox(height: 60.0), // Empty space allowing the notch to render correctly
      ),
    );
  }
}
