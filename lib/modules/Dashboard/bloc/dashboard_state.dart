part of 'dashboard_bloc.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

final class DashboardInitial extends DashboardState {}

final class ErroSatate extends DashboardState {
  final String message;

  const ErroSatate({required this.message});

  @override
  List<Object> get props => [message];
}

final class LoadingState extends DashboardState {}

final class GetNotesSuccessSate extends DashboardState {
  final int timeStamp;
  final List<NoteModel> notesList;

  const GetNotesSuccessSate({required this.notesList, required this.timeStamp});

  @override
  List<Object> get props => [timeStamp, notesList];
}

final class ChangeScreenViewState extends DashboardState {
  final bool view;
  const ChangeScreenViewState({required this.view});
  @override
  List<Object> get props => [view];
}

final class SearchNotesSuccessState extends DashboardState {
  final int timeStamp;
  final List<NoteModel> notesList;

  const SearchNotesSuccessState(
      {required this.notesList, required this.timeStamp});

  @override
  List<Object> get props => [timeStamp, notesList];
}

final class SearchLoading extends DashboardState {}
