part of 'setting_bloc.dart';

enum SettingStatus {
  initState,
  userLoadingInProgress,
  userLoadingSuccess,
  userLoadingFailure,
  updateUserInProgress,
  updateUserSuccess,
  updateUserFailure,
  signOutInProgress,
  signOutSuccess,
}

class SettingState extends Equatable {
  final SettingStatus status;
  final String? message;

  const SettingState({
    required this.status,
    this.message,
  });

  static const initState = SettingState(
    status: SettingStatus.initState,
  );

  SettingState copyWith({
    SettingStatus? status,
    String? message,
  }) {
    return SettingState(
      status: status ?? this.status,
      message: message,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
      ];
}
