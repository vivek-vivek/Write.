import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_note/modules/Dashboard/bloc/dashboard_bloc.dart';
import 'package:take_note/utils/dates.dart';

import '../../../utils/common_widgets.dart';
import '../model/notes_model.dart';

class SearchScreen extends StatefulWidget {
  final List<NoteModel> noteList;

  const SearchScreen({super.key, required this.noteList});
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<NoteModel> results = [];
  TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    results = widget.noteList;
    super.initState();
  }

  final _debounce = Debouncer();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardBloc(),
      child: BlocListener<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state is SearchNotesSuccessState) {
            results = state.notesList;
          }
        },
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back_ios)),
                title: Text('Search Notes'),
              ),
              body: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Search',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                          },
                        ),
                      ),
                      onChanged: (value) {
                        _debounce.run(() {
                          context.read<DashboardBloc>().add(SearchNotesEvent(
                              widget.noteList,
                              query: value.trim()));
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: state is SearchLoading
                          ? const Center(
                              child: SizedBox(
                                  height: 30,
                                  width: 20,
                                  child: CircularProgressIndicator()),
                            )
                          : results.isEmpty
                              ? const Center(
                                  child: Text("No nodes found..."),
                                )
                              : ListView.builder(
                                  itemCount: results
                                      .length, // Replace with actual number of search results
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: SizedBox(
                                        width: 150,
                                        child: Text(
                                          normalDateFormate(
                                              results[index].updatedAt ?? ""),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      subtitle: SizedBox(
                                          width: 150,
                                          child: Text(results[index].note ?? "",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis)),
                                      onTap: () {},
                                    );
                                  },
                                ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
