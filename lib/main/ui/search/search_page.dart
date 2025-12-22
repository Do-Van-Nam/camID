import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'search_bloc.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppLocalizations.of(context)!.search),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.enterSearch,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: (query) {
                  context.read<SearchBloc>().add(SearchTextChanged(query));
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchInitial || state is SearchEmpty) {
                    return const Center(child: Text(AppLocalizations.of(context)!.enter));
                  }
                  if (state is SearchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is SearchLoaded) {
                    if (state.filteredItems.isEmpty) {
                      return const Center(child: Text(AppLocalizations.of(context)!.notf));
                    }
                    return ListView.builder(
                      itemCount: state.filteredItems.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(state.filteredItems[index]),
                        );
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}