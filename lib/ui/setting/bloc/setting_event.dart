part of 'setting_bloc.dart';

abstract class SettingEvent extends Equatable {
  const SettingEvent();

  @override
  List<Object?> get props => [];
}

class UpdateUserRequest extends SettingEvent {
  final File? file;
  final String? name;

  const UpdateUserRequest({this.file, this.name});

  @override
  List<Object?> get props => [file, name];
}

class SignoutRequest extends SettingEvent {}
