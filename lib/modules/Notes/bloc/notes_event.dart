part of 'notes_bloc.dart';

sealed class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object> get props => [];
}

final class SelectMoodEvent extends NotesEvent {
  final String mood;
  const SelectMoodEvent({required this.mood});
  @override
  List<Object> get props => [mood];
}

final class SelectSubMoodEvent extends NotesEvent {
  final String mood;
  const SelectSubMoodEvent({required this.mood});
  @override
  List<Object> get props => [mood];
}

final class CreateNoteEvent extends NotesEvent {
  final String note, mood, updatedAt;

  const CreateNoteEvent({
    required this.note,
    required this.mood,
    required this.updatedAt,
  });

  @override
  List<Object> get props => [note];
}

final class UpdateNoteEvent extends NotesEvent {
  final String note, mood, updatedAt;
  final int id;

  const UpdateNoteEvent({
    required this.note,
    required this.mood,
    required this.updatedAt,
    required this.id,
  });
}

final class DeleteNoteEvent extends NotesEvent {
  final String id;
  const DeleteNoteEvent({required this.id});
  @override
  List<Object> get props => [id];
}
