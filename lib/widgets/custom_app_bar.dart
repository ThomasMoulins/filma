import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import './custom_search_bar.dart';
import '../pages/options_page.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Function(String) onSearchChanged;
  final Function(bool) onModeChanged;
  final Function(String) onCategorySelected;
  final Function(String) onCompanySelected;
  final TextEditingController searchController;

  const CustomAppBar({
    super.key,
    required this.onSearchChanged,
    required this.onModeChanged,
    required this.onCategorySelected,
    required this.onCompanySelected,
    required this.searchController,
  });

  @override
  CustomAppBarState createState() => CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomAppBarState extends State<CustomAppBar> {
  List<dynamic> _categories = [];
  List<Map<String, dynamic>> _companies = [];
  bool _isLoadingCategories = false;
  bool _isLoadingCompanies = false;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchCompanies();
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

  Future<void> _fetchCompanies() async {
    setState(() {
      _isLoadingCompanies = true;
    });
    try {
      final logoPath = 'https://image.tmdb.org/t/p/w500/';
      _companies = [
        {'id': '420', 'name': 'Marvel', 'logoPath': '${logoPath}hUzeosd33nzE5MCNsZxCGEKTXaQ.png'},
        {'id': '174', 'name': 'Warner Bros', 'logoPath': '${logoPath}zhD3hhtKB5qyv7ZeL4uLpNxgMVU.png'},
        {'id': '2', 'name': 'Walt Disney', 'logoPath': '${logoPath}wdrCwmRnLFJhEoH8GSfymY85KHT.png'},
        {'id': '7', 'name': 'DreamWorks', 'logoPath': '${logoPath}vru2SssLX3FPhnKZGtYw00pVIS9.png'},
        {'id': '33', 'name': 'Universal', 'logoPath': '${logoPath}3wwjVpkZtnog6lSKzWDjvw2Yi00.png'},
        {'id': '5', 'name': 'Columbia', 'logoPath': '${logoPath}71BqEFAF4V3qjjMPCpLuyJFB9A.png'},
        {'id': '4', 'name': 'Paramount', 'logoPath': '${logoPath}gz66EfNoYPqHTYI4q9UEN4CbHRc.png'},
        {'id': '25', 'name': '20th Century Fox', 'logoPath': '${logoPath}qZCc1lty5FzX30aOCVRBLzaVmcp.png'},
        {'id': '21', 'name': 'Metro-Goldwyn-Mayer', 'logoPath': '${logoPath}usUnaYV6hQnlVAXP6r4HwrlLFPG.png'},
        {'id': '1632', 'name': 'Lionsgate', 'logoPath': '${logoPath}cisLn1YAUuptXVBa0xjq7ST9cH0.png'},
        {'id': '12', 'name': 'New Line', 'logoPath': '${logoPath}2ycs64eqV5rqKYHyQK0GVoKGvfX.png'},
      ];
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la récupération des compagnies : $e');
      }
    } finally {
      setState(() {
        _isLoadingCompanies = false;
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
        IconButton(
          icon: Icon(Icons.settings, color: Colors.grey[700]),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OptionsPage())
            );
          })
      ],
    );
  }

  void _showCategoriesDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        if (_isLoadingCategories || _isLoadingCompanies) {
          return const Center(child: CircularProgressIndicator());
        } else if (_categories.isEmpty && _companies.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Aucune catégorie ou compagnie disponible'),
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
                  'Catégories et Compagnies',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                // Section Compagnies
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Compagnies populaires',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 10),
                          GridView.builder(
                            shrinkWrap: true, // Important pour éviter les conflits de défilement
                            physics: const NeverScrollableScrollPhysics(), // Désactive le défilement interne
                            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 120, // Largeur maximale de chaque élément
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: _companies.length,
                            itemBuilder: (context, index) {
                              final company = _companies[index];
                              return ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 120,
                                  maxHeight: 50,
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  onPressed: () {
                                    widget.onCompanySelected(company['id']!);
                                    Navigator.pop(context);
                                  },
                                  child: company['logoPath'] != null
                                      ? Image.network(
                                    company['logoPath']!,
                                    fit: BoxFit.contain,
                                  )
                                      : const Icon(Icons.business, size: 40, color: Colors.grey),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),

                          // Section Catégories
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Catégories',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: _categories.map((category) {
                              String categoryName = category['name'];
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.blueGrey[800],
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
                        ],
                      ),
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