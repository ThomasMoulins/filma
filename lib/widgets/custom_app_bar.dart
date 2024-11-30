import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function(String) onSearchChanged;
  final Function(String) onCategorySelected;
  final TextEditingController searchController;

  const CustomAppBar({super.key,
    required this.onSearchChanged,
    required this.onCategorySelected,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          // Logo de l'application
          Image.asset('assets/logo.png', height: 40),
          const SizedBox(width: 10),
          // Barre de recherche
          Expanded(
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  onSearchChanged(value);
                }
              },
              decoration: InputDecoration(
                hintText: 'Rechercher des films...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    onSearchChanged('');
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Menu des catégories
          PopupMenuButton<String>(
            onSelected: onCategorySelected,
            itemBuilder: (BuildContext context) {
              return ['Action', 'Comédie', 'Drame'] // Liste des catégories
                  .map((String category) {
                return PopupMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList();
            },
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
