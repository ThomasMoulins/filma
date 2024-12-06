import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController searchController;
  final Function(String) onSearchChanged;
  final Function(bool) onModeChanged;

  const CustomSearchBar({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.onModeChanged,
  });

  @override
  State<CustomSearchBar> createState() => CustomSearchBarState();
}

class CustomSearchBarState extends State<CustomSearchBar> {
  bool isFilmMode = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Bouton de mode (Icône Films/Personnes)
          GestureDetector(
            onTap: () {
              setState(() {
                isFilmMode = !isFilmMode;
              });
              widget.onModeChanged(isFilmMode);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center,
              child: Icon(
                isFilmMode ? Icons.movie : Icons.person,
                color: Colors.grey[700],
                size: 24,
              ),
            ),
          ),
          Container(
            width: 1,
            color: Colors.grey[400]!,
            height: 20,
          ),
          // Champ de recherche
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: TextField(
                controller: widget.searchController,
                onChanged: (value) {
                  widget.onSearchChanged(value);
                },
                decoration: InputDecoration(
                  hintText: isFilmMode
                      ? 'Rechercher des films ...'
                      : 'Rechercher des personnes ...',
                  hintStyle: TextStyle(color: Colors.grey[500]!),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.only(left: 10, bottom: 5),
                ),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
