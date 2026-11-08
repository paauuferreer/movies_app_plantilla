import 'package:flutter/material.dart';
import 'package:movies_app/models/models.dart';
import 'package:movies_app/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class MovieSearchDelegate extends SearchDelegate {
  @override
  String get searchFieldLabel => 'Cercar pel·lícula';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _construirResultats(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Icon(Icons.movie_creation_outlined, color: Colors.black26, size: 120),
      );
    }
    return _construirResultats(context);
  }

  Widget _construirResultats(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder(
      future: moviesProvider.cercarPelis(query),
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final pelis = snapshot.data!;

        if (pelis.isEmpty) {
          return const Center(
            child: Text('No s\'ha trobat cap pel·lícula.'),
          );
        }

        return ListView.builder(
          itemCount: pelis.length,
          itemBuilder: (BuildContext context, int index) {
            final peli = pelis[index];
            return ListTile(
              leading: FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: NetworkImage(peli.fullPosterImg),
                width: 50,
                fit: BoxFit.contain,
              ),
              title: Text(peli.title),
              subtitle: Text(peli.originalTitle),
              onTap: () {
                Navigator.pushNamed(context, 'details', arguments: peli);
              },
            );
          },
        );
      },
    );
  }
}
