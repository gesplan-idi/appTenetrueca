import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../features/auth/auth.dart';
import '../../../features/scanner/scanner.dart';
import '../../../features/objetos/objetos.dart';
import '../../../features/usuarios/usuarios.dart';
import 'widgets/custom_app_bar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ScannerProvider()),
        ChangeNotifierProvider(create: (_) => ObjetosProvider()),
        ChangeNotifierProvider(create: (_) => UsuariosProvider()),
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
  bool _isDetailViewOpen = false;

  List<Widget> get _screens => [
    ObjetosScreen(
      onViewChanged: (isOpen) => setState(() => _isDetailViewOpen = isOpen),
    ), // 0
    const DashboardScreen(), // 1
    const Center(child: Text('Pantalla de Ajustes PrÃ³ximamente')), // 2
    ScannerScreen(
      onScanComplete: () {
        setState(() { _currentIndex = 1; _isDetailViewOpen = false; });
      },
    ), // 3
    const UsuariosScreen(), // 4
    const SubirObjetoScreen(), // 5
  ];

  final List<String> _titles = [
    'Catálogo de Objetos',
    'Historial de Escaneos',
    'Ajustes',
    'Escanear Código QR',
    'Listado de Usuarios',
    'Subir Objeto',
  ];

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF40543C);

    return Scaffold(
      appBar: _isDetailViewOpen ? null : CustomAppBar(title: _titles[_currentIndex]),
      drawer: _isDetailViewOpen ? null : Drawer(
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
                setState(() { _currentIndex = 0; _isDetailViewOpen = false; });
                Navigator.pop(context); // Close drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.history, color: primaryColor),
              title: const Text('Historial'),
              onTap: () {
                setState(() { _currentIndex = 1; _isDetailViewOpen = false; });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: primaryColor),
              title: const Text('Ajustes'),
              onTap: () {
                setState(() { _currentIndex = 2; _isDetailViewOpen = false; });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.people, color: primaryColor),
              title: const Text('Usuarios'),
              onTap: () {
                setState(() { _currentIndex = 4; _isDetailViewOpen = false; });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_photo_alternate_rounded, color: primaryColor),
              title: const Text('Subir Producto'),
              onTap: () {
                setState(() { _currentIndex = 5; _isDetailViewOpen = false; });
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
            setState(() {
              _currentIndex = 3;
              _isDetailViewOpen = false;
            });
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

