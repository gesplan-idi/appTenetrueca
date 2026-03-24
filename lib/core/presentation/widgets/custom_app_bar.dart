import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF40543C);

    return AppBar(
      title: Text(
        title, 
        style: const TextStyle(
          color: Colors.white, 
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: primaryColor,
      iconTheme: const IconThemeData(color: Colors.white),
      elevation: 0,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
