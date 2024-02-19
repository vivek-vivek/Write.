import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:take_note/database/key.dart';

import '../../../database/database_helper.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc() : super(NotesInitial()) {
    on<NotesEvent>((event, emit) {});

    on<SelectMoodEvent>(selectMood);
    on<CreateNoteEvent>(createNote);
    on<UpdateNoteEvent>(updateNote);
    on<DeleteNoteEvent>(deleteNote);
  }

  Future selectMood(SelectMoodEvent event, Emitter<NotesState> emit) async {
    log(event.mood, name: "SELECTED MOOD");
    emit(MoodSelectedState(
        mood: event.mood, timeStamp: DateTime.now().microsecondsSinceEpoch));
  }

  Future<void> createNote(
      CreateNoteEvent event, Emitter<NotesState> emit) async {
    try {
      emit(LoadingState());

      final result =
          await DatabaseHelper().insertData(tableName, <String, Object?>{
        "note": event.note,
        "mood": event.mood,
        "updatedAt": event.updatedAt,
      });

      if (result != null && result > 0) {
        // Insertion successful
        emit(const CreateNoteSuccessState(message: "Note added"));
      } else {
        // Insertion failed
        emit(const ErroSatate(
            message: "Something went wrong! please try again"));
      }
    } catch (e, s) {
      emit(const ErroSatate(message: "Something went wrong! please try again"));
    }
  }

  Future updateNote(UpdateNoteEvent event, Emitter<NotesState> emit) async {
    try {
      emit(LoadingState());

      final result = await DatabaseHelper().updateData(
        tableName,
        <String, Object?>{
          "note": event.note,
          "mood": event.mood,
          "updatedAt": event.updatedAt,
        },
        event.id.toString(),
      );

      if (result != null && result > 0) {
        // Insertion successful
        emit(const CreateNoteSuccessState(message: "Note updated"));
      } else {
        // Insertion failed
        emit(const ErroSatate(
            message: "Something went wrong! please try again"));
      }
    } catch (e) {
      emit(const ErroSatate(message: "Something went wrong! please try again"));
    }
  }

  Future<void> deleteNote(
      DeleteNoteEvent event, Emitter<NotesState> emit) async {
    try {
      final result = await DatabaseHelper().deleteData(tableName, event.id);
      if (result != null && result > 0) {
        // Delete operation successful
        print('Delete operation successful: $result row(s) deleted');
        emit(const DeleteNoteSuccessState(message: "Note deleted."));
      } else {
        // Delete operation failed
        emit(const ErroSatate(message: "Unable to delete."));
      }
    } catch (e) {
      emit(const ErroSatate(message: "Something went wrong! please try again"));
    }
  }
}
