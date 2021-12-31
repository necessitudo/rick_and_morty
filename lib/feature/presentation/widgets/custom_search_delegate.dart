import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/feature/domain/entities/person_entity.dart';
import 'package:rick_and_morty/feature/presentation/bloc/search_bloc/search_bloc.dart';
import 'package:rick_and_morty/feature/presentation/bloc/search_bloc/search_event.dart';
import 'package:rick_and_morty/feature/presentation/bloc/search_bloc/search_state.dart';
import 'package:rick_and_morty/feature/presentation/widgets/search_result_widget.dart';

class CustomSearchDelegate extends SearchDelegate {
  CustomSearchDelegate() : super(searchFieldLabel: 'Search for characters...');

  final _suggestions = ['Rick', 'Morty', 'Summer', 'Beth', 'Jerry'];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
          icon: const Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        tooltip: 'Back',
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back_outlined));
  }

  @override
  Widget buildResults(BuildContext context) {
    print('Inside custom search delegate and search query is $query');
    BlocProvider.of<PersonSearchBloc>(context, listen: false)
        .add(SearchPersons(query));

    return BlocBuilder<PersonSearchBloc, PersonSearchState>(
        builder: (context, state) {
      if (state is PersonSearchLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is PersonSearchLoaded) {
        final persons = state.persons;
        if (persons.isEmpty) {
          return _showErrorText('No Characters with that name found');
        }

        return Container(
            child: ListView.builder(
          itemBuilder: (context, index) {
            PersonEntity result = persons[index];
            return SearchResult(personResult: result);
          },
          itemCount: persons.isNotEmpty ? persons.length : 0,
        ));
      } else if (state is PersonSearchError) {
        return _showErrorText(state.message);
      } else {
        return const Center(
          child: Icon(Icons.now_wallpaper),
        );
      }
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty) {
      return Container();
    }

    return ListView.separated(
        padding: const EdgeInsets.all(10.0),
        itemBuilder: (context, index) {
          return Text(
            _suggestions[index],
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
          );
        },
        separatorBuilder: (context, index) => const Divider(),
        itemCount: _suggestions.length);
  }

  Widget _showErrorText(String errorMessage) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Text(
          errorMessage,
          style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
