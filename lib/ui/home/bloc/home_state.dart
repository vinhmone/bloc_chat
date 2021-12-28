part of 'home_bloc.dart';

enum HomeStatus { initState, connectInProgress, connectSuccess, connectFailure }

class HomeState extends Equatable {
  final String userId;
  final String username;
  final HomeStatus status;
  final String? message;

  const HomeState(
      {required this.userId,
      required this.username,
      required this.status,
      this.message});

  HomeState copyWith({
    String? userId,
    String? username,
    HomeStatus? status,
    String? message,
  }) {
    return HomeState(
        userId: userId ?? this.userId,
        username: username ?? this.username,
        status: status ?? this.status,
        message: message);
  }

  static const initState =
      HomeState(userId: '', username: '', status: HomeStatus.initState);

  @override
  List<Object?> get props => [userId, username, status, message];
}
