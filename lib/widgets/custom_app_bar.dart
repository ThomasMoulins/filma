import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import './custom_search_bar.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Function(String) onSearchChanged;
  final Function(bool) onModeChanged;
  final Function(String) onCategorySelected;
  final TextEditingController searchController;

  const CustomAppBar({
    super.key,
    required this.onSearchChanged,
    required this.onModeChanged,
    required this.onCategorySelected,
    required this.searchController,
  });

  @override
  CustomAppBarState createState() => CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomAppBarState extends State<CustomAppBar> {
  List<dynamic> _categories = [];
  bool _isLoadingCategories = false;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    setState(() {
      _isLoadingCategories = true;
    });
    try {
      _categories = await ApiService().getGenreList();
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la récupération des catégories : $e');
      }
    } finally {
      setState(() {
        _isLoadingCategories = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Image.asset('assets/icon.png', height: 40),
      ),
      title: CustomSearchBar(
        searchController: widget.searchController,
        onSearchChanged: widget.onSearchChanged,
        onModeChanged: widget.onModeChanged,
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
      backgroundColor: Colors.transparent,
      builder: (context) {
        if (_isLoadingCategories) {
          return const Center(child: CircularProgressIndicator());
        } else if (_categories.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Aucune catégorie disponible'),
            ),
          );
        } else {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Catégories',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 1,
                      children: _categories.map((category) {
                        String categoryName = category['name'];
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.blueGrey[800],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {
                            widget.onCategorySelected(categoryName);
                            Navigator.pop(context);
                          },
                          child: Text(categoryName),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}