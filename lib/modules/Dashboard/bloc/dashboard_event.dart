part of 'dashboard_bloc.dart';

sealed class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

final class GetNotesFromDB extends DashboardEvent {}

final class ChangeScreenViewEvent extends DashboardEvent {
  final bool view;
  const ChangeScreenViewEvent({required this.view});
  @override
  List<Object> get props => [view];
}

final class SearchNotesEvent extends DashboardEvent {
  final String query;
  final List<NoteModel> notesModel;
  const SearchNotesEvent(this.notesModel, {required this.query});
  @override
  List<Object> get props => [query, notesModel];
}
