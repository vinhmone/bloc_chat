part of 'chat_detail_bloc.dart';

abstract class ChatDetailState extends Equatable {
  const ChatDetailState();
}

class ChatDetailInitial extends ChatDetailState {
  @override
  List<Object> get props => [];
}