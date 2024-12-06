import 'package:flutter/material.dart';
import '../models/person.dart';
import '../pages/person_movies_page.dart';

class PersonList extends StatelessWidget {
  final List<Person> people;
  const PersonList({super.key, required this.people});

  @override
  Widget build(BuildContext context) {
    return people.isEmpty
        ? const Center(
      child: Text(
        'Aucune personne trouvée',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    )
        : ListView.builder(
      itemCount: people.length,
      itemBuilder: (context, index) {
        Person person = people[index];
        return ListTile(
          leading: person.profilePath.isNotEmpty
              ? CircleAvatar(
            backgroundImage: NetworkImage(
                'https://image.tmdb.org/t/p/w185${person.profilePath}'),
          )
              : CircleAvatar(
            child: Icon(Icons.person),
          ),
          title: Text(person.name),
          subtitle: Text(person.knownForDepartment),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PersonMoviesPage(person: person),
              ),
            );
          },
        );
      },
    );
  }
}
