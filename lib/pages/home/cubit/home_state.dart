part of 'home_cubit.dart';

class HomeState extends Equatable {
  final List<User> userList;
  final List<String> errorMessage;
  final Status fetchStatus;

  const HomeState({
    this.userList = const [],
    this.errorMessage = const [],
    this.fetchStatus = Status.idle,
  });

  HomeState copyWith({
    List<User>? userList,
    List<String>? errorMessage,
    Status? fetchStatus,
  }) {
    return HomeState(
      userList: userList ?? this.userList,
      fetchStatus: fetchStatus ?? this.fetchStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        userList,
        fetchStatus,
        errorMessage,
      ];
}
