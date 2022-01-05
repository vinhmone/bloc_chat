import 'package:bloc/bloc.dart';
import 'package:bloc_chat/data/repository/contact_repository.dart';
import 'package:bloc_chat/util/constants.dart';
import 'package:equatable/equatable.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

part 'contact_event.dart';

part 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final ContactRepository _repository;

  ContactBloc({required ContactRepository repository})
      : _repository = repository,
        super(ContactState.initState) {
    on<LoadAllContact>(_loadAllContact);
    on<CreateNewChat>(_createNewChat);
    add(LoadAllContact());
  }

  void _loadAllContact(
    LoadAllContact event,
    Emitter<ContactState> emit,
  ) async {
    emit(state.copyWith(
      status: ContactStatus.loadContactInProgress,
    ));
    try {
      final list = await _repository.loadAllUser();
      emit(state.copyWith(
        users: list,
        status: ContactStatus.loadContactSuccess,
      ));
      print('sucees');
    } catch (_) {
      emit(state.copyWith(
        status: ContactStatus.loadContactFailure,
        message: AppConstants.unknownException,
      ));
    }
  }

  void _createNewChat(CreateNewChat event, Emitter<ContactState> emit) async {
    emit(state.copyWith(
      status: ContactStatus.createNewChatInProgress,
    ));
    try {
      final channel = await _repository.createChannel(
        users: event.users,
        name: event.name,
      );
      emit(state.copyWith(
        channel: channel,
        status: ContactStatus.createNewChatSuccess,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: ContactStatus.createNewChatFailure,
        message: AppConstants.unknownException,
      ));
    }
  }
}
