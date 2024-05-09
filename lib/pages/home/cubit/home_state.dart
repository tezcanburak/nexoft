part of 'home_cubit.dart';

class HomeState extends Equatable {
  final List<User> userList;
  final List<User> filteredUserList;
  final List<String> errorMessageList;
  final Status fetchStatus;

  const HomeState({
    this.userList = const [],
    this.filteredUserList = const [],
    this.errorMessageList = const [],
    this.fetchStatus = Status.idle,
  });

  HomeState copyWith({
    List<User>? userList,
    List<User>? filteredUserList,
    List<String>? errorMessageList,
    Status? fetchStatus,
  }) {
    return HomeState(
      userList: userList ?? this.userList,
      fetchStatus: fetchStatus ?? this.fetchStatus,
      errorMessageList: errorMessageList ?? this.errorMessageList,
      filteredUserList: filteredUserList ?? this.filteredUserList,
    );
  }

  @override
  List<Object?> get props => [
        userList,
        fetchStatus,
        errorMessageList,
        filteredUserList,
      ];
}
