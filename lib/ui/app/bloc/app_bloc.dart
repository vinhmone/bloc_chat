import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_chat/data/model/user.dart';
import 'package:bloc_chat/data/repository/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'app_event.dart';

part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AuthenticationRepository _authenticationRepository;
  late final StreamSubscription<People> _userSubscription;

  AppBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(
          (authenticationRepository.currentPeople.uid.isNotEmpty)
              ? AppState.authenticated(authenticationRepository.currentPeople)
              : const AppState.unauthenticated(),
        ) {
    on<AppLogoutRequested>(_onLogoutRequested);
    on<AppUserChanged>(_isUserChanged);
    _userSubscription = _authenticationRepository.people.listen((people) {
      add(AppUserChanged(people));
    });
  }

  void _isUserChanged(AppUserChanged event, Emitter<AppState> emit) {
    emit(event.people.uid.isNotEmpty
        ? AppState.authenticated(event.people)
        : const AppState.unauthenticated());
  }

  void _onLogoutRequested(AppLogoutRequested event, Emitter<AppState> emit) {
      _authenticationRepository.signout();
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
