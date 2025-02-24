import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import '../services/api_service.dart';

class OptionsPage extends StatefulWidget {
  const OptionsPage({super.key});

  @override
  State<OptionsPage> createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
  List<String> filmTitles = [];
  bool isLoading = true;
  bool showAllFilms = true;
  double maxCrossAxisExtent = 200;
  double crossAxisSpacing = 10;

  @override
  void initState() {
    super.initState();
    _loadFilmTitles();
    _loadPreferences();
  }

  Future<void> _loadFilmTitles() async {
    try {
      final titles = await ApiService().fetchFilmTitles();
      setState(() {
        filmTitles = titles;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement des titres: $e')),
      );
    }
  }

  // Chargement des préférences sauvegardées
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      maxCrossAxisExtent = prefs.getDouble('maxCrossAxisExtent') ?? 200;
      crossAxisSpacing = prefs.getDouble('crossAxisSpacing') ?? 10;
    });
  }

  // Sauvegarde des préférences
  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('maxCrossAxisExtent', maxCrossAxisExtent);
    await prefs.setDouble('crossAxisSpacing', crossAxisSpacing);
  }

  // Fonction pour choisir un dossier, récupérer récursivement les noms des fichiers vidéo et les envoyer à l'API
  Future<void> _pickDirectoryAndSendFiles() async {
    // Sélection du dossier via file_picker
    String? directoryPath = await FilePicker.platform.getDirectoryPath();
    if (directoryPath != null) {
      List<String> videoFileNames = [];
      Directory directory = Directory(directoryPath);
      await for (FileSystemEntity entity in directory.list(
          recursive: true, followLinks: false)) {
        if (entity is File) {
          String ext = entity.path
              .split('.')
              .last
              .toLowerCase();
          if (['mp4', 'avi', 'mov', 'mkv'].contains(ext)) {
            videoFileNames.add(entity.path
                .split(Platform.pathSeparator)
                .last);
          }
        }
      }
      // Envoi des noms de fichiers à l'API via une méthode que vous aurez implémentée (par exemple uploadVideoFileNames)
      try {
        await ApiService().uploadVideoFileNames(videoFileNames);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fichiers vidéo envoyés avec succès')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Erreur lors de l\'envoi des fichiers vidéo: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Options'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Switch pour le mode d'affichage
            SwitchListTile(
              title: const Text('Mode d\'affichage'),
              subtitle: Text(
                showAllFilms
                    ? 'Afficher tous les films'
                    : 'Afficher les films téléchargés',
              ),
              value: showAllFilms,
              onChanged: (bool value) {
                setState(() {
                  showAllFilms = value;
                });
              },
            ),
            const Divider(),
            // ListTile et Slider pour la taille des Cards
            ListTile(
              title: const Text(
                'Cards',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              subtitle: Text(
                'Taille maximum : ${maxCrossAxisExtent.toStringAsFixed(0)}',
              ),
            ),
            Slider(
              value: maxCrossAxisExtent,
              min: 100,
              max: 400,
              divisions: 30,
              label: maxCrossAxisExtent.toStringAsFixed(0),
              onChanged: (value) {
                setState(() {
                  maxCrossAxisExtent = value;
                });
              },
              onChangeEnd: (value) {
                _savePreferences();
              },
            ),
            // ListTile et Slider pour l'espacement
            ListTile(
              subtitle: Text(
                'Espacement : ${crossAxisSpacing.toStringAsFixed(0)}',
              ),
            ),
            Slider(
              value: crossAxisSpacing,
              min: 0,
              max: 50,
              divisions: 50,
              label: crossAxisSpacing.toStringAsFixed(0),
              onChanged: (value) {
                setState(() {
                  crossAxisSpacing = value;
                });
              },
              onChangeEnd: (value) {
                _savePreferences();
              },
            ),
            const Divider(),
            // Bouton pour choisir un dossier et envoyer les noms des fichiers vidéo
            ElevatedButton.icon(
              onPressed: _pickDirectoryAndSendFiles,
              icon: const Icon(Icons.folder),
              label: const Text('Ajouter des titres de film'),
            ),
            const Divider(),
            // Affichage de la liste des titres récupérés via l'API
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filmTitles.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filmTitles[index]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}