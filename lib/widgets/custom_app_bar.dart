// lib/widgets/custom_app_bar.dart
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function(String) onSearchChanged;
  final Function(String) onCategorySelected;
  final TextEditingController searchController;

  const CustomAppBar({
    super.key,
    required this.onSearchChanged,
    required this.onCategorySelected,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Image.asset('assets/logo.png', height: 40),
      ),
      title: SizedBox(
        height: 40,
        child: TextField(
          controller: searchController,
          onChanged: (value) {
            onSearchChanged(value);
          },
          decoration: InputDecoration(
            hintText: 'Rechercher des films...',
            hintStyle: TextStyle(color: Colors.grey[500]),
            prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
            filled: true,
            fillColor: Colors.grey[200],
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400]!),
              borderRadius: BorderRadius.circular(20),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[200]!),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.category, color: Colors.grey[700]),
          onPressed: () {
            _showCategoriesDialog(context);
          },
        ),
      ],
    );
  }

  void _showCategoriesDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final categories = ['Action', 'Comédie', 'Drame']; // Liste des catégories
        return Container(
          padding: const EdgeInsets.all(16),
          child: ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(categories[index]),
                onTap: () {
                  onCategorySelected(categories[index]);
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
