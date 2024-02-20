part of 'notes_bloc.dart';

sealed class NotesState extends Equatable {
  const NotesState();

  @override
  List<Object> get props => [];
}

final class NotesInitial extends NotesState {}

final class ErroSatate extends NotesState {
  final String message;

  const ErroSatate({required this.message});

  @override
  List<Object> get props => [message];
}

final class LoadingState extends NotesState {}

final class MoodSelectedState extends NotesState {
  final String mood;
  final int timeStamp;
  const MoodSelectedState({required this.mood, required this.timeStamp});
  @override
  List<Object> get props => [mood, timeStamp];
}

final class SubMoodSelectedState extends NotesState {
  final String mood;
  final int timeStamp;
  const SubMoodSelectedState({required this.mood, required this.timeStamp});
  @override
  List<Object> get props => [mood, timeStamp];
}

final class CreateNoteSuccessState extends NotesState {
  final String message;
  const CreateNoteSuccessState({required this.message});
  @override
  List<Object> get props => [message];
}

final class DeleteNoteSuccessState extends NotesState {
  final String message;
  const DeleteNoteSuccessState({required this.message});
  @override
  List<Object> get props => [message];
}
