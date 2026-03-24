import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'usuarios_provider.dart';
import 'usuario_detail_screen.dart';

class UsuariosScreen extends StatefulWidget {
  const UsuariosScreen({super.key});

  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UsuariosProvider>().loadUsuarios();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        context.read<UsuariosProvider>().fetchMoreUsuarios();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UsuariosProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF40543C)));
        }

        if (provider.usuarios.isEmpty) {
          return const Center(child: Text('No se encontraron usuarios.'));
        }

        return RefreshIndicator(
          color: const Color(0xFF40543C),
          onRefresh: () => provider.loadUsuarios(),
          child: ListView.builder(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: provider.usuarios.length + (provider.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == provider.usuarios.length) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator(color: Color(0xFF40543C))),
                );
              }

              final usuario = provider.usuarios[index];
              final initials = usuario.nombre.isNotEmpty ? usuario.nombre[0].toUpperCase() : '?';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF40543C).withOpacity(0.2),
                    child: Text(
                      initials,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF40543C)),
                    ),
                  ),
                  title: Text(
                    usuario.nombreCompleto,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(usuario.email, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                      if (usuario.dni != null)
                        Text('DNI: ${usuario.dni}', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    ],
                  ),
                  trailing: const Icon(Icons.chevron_right, color: Color(0xFF40543C)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UsuarioDetailScreen(usuario: usuario),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}

