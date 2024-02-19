import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:take_note/database/database_helper.dart';

import '../../../database/key.dart';
import '../model/notes_model.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<DashboardEvent>((event, emit) {});
    on<GetNotesFromDB>(getNotesFromDB);
    on<ChangeScreenViewEvent>(changeScreenView);
    on<SearchNotesEvent>(searchNotes);
  }

  bool ScreenGridView = true;

  Future<void> getNotesFromDB(
      GetNotesFromDB event, Emitter<DashboardState> emit) async {
    try {
      final result = await DatabaseHelper().getData(tableName);
      if (result != null) {
        // List to store the extracted data from QueryResultSet
        List<Map<String, dynamic>> resultList = [];

        // Iterate over the QueryResultSet and add each row to the resultList
        for (var row in result) {
          resultList.add(row);
        }

        // Convert the list of maps to a JSON string
        String jsonString = json.encode(resultList);

        emit(
          GetNotesSuccessSate(
            timeStamp: DateTime.now().microsecondsSinceEpoch,
            notesList: noteModelFromJson(jsonString),
          ),
        );
      } else {
        // Database operation failed
        print('Failed to retrieve data');
        emit(const ErroSatate(
            message: "Something went wrong! please try again"));
      }
    } catch (e, s) {
      log(s.toString());
      emit(const ErroSatate(message: "Something went wrong! please try again"));
    }
  }

  void changeScreenView(
      ChangeScreenViewEvent event, Emitter<DashboardState> emit) {
    ScreenGridView = !event.view;
    emit(ChangeScreenViewState(view: event.view));
  }

  Future<void> searchNotes(
      SearchNotesEvent event, Emitter<DashboardState> emit) async {
    try {
      emit(SearchLoading());
      final List<NoteModel> notes = event.notesModel;
      final List<NoteModel> searchResults = [];

      final List<Map<String, dynamic>> jsonDataList =
          notes.map((note) => note.toJson()).toList();
      final String rawData = jsonEncode(jsonDataList);
      log(rawData, name: "JSON");

      for (final NoteModel note in notes) {
        if (note.note?.contains(event.query) ?? false) {
          searchResults.add(note);
        }
      }
      emit(SearchNotesSuccessState(
          timeStamp: DateTime.now().microsecondsSinceEpoch,
          notesList: searchResults));
    } catch (e) {
      emit(const ErroSatate(message: "Something went wrong! please try again"));
    }
  }
}
