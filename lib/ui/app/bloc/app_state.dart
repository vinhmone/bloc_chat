part of 'app_bloc.dart';

enum AppStatus {
  authenticated,
  unauthenticated,
}

class AppState extends Equatable {
  final AppStatus status;
  final People people;

  const AppState._({required this.status, this.people = People.empty});

  const AppState.authenticated(People people)
      : this._(status: AppStatus.authenticated, people: people);

  const AppState.unauthenticated() : this._(status: AppStatus.unauthenticated);

  @override
  List<Object> get props => [status, people];
}
