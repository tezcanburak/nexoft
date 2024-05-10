part of 'home_cubit.dart';

class HomeState extends Equatable {
  final List<User> userList;
  final List<User> filteredUserList;
  final List<String> errorMessageList;
  final bool isValid;
  final Name firstName;
  final Name lastName;
  final PhoneNumber phoneNumber;
  final Status fetchStatus;
  final Status createStatus;

  const HomeState({
    this.userList = const [],
    this.filteredUserList = const [],
    this.errorMessageList = const [],
    this.isValid = false,
    this.firstName = Name.empty,
    this.lastName = Name.empty,
    this.phoneNumber = PhoneNumber.empty,
    this.fetchStatus = Status.idle,
    this.createStatus = Status.idle,
  });

  HomeState copyWith({
    List<User>? userList,
    List<User>? filteredUserList,
    List<String>? errorMessageList,
    bool? isValid,
    Name? firstName,
    Name? lastName,
    PhoneNumber? phoneNumber,
    Status? fetchStatus,
    Status? createStatus,
  }) {
    return HomeState(
      userList: userList ?? this.userList,
      fetchStatus: fetchStatus ?? this.fetchStatus,
      createStatus: createStatus ?? this.createStatus,
      isValid: isValid ?? this.isValid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      errorMessageList: errorMessageList ?? this.errorMessageList,
      filteredUserList: filteredUserList ?? this.filteredUserList,
    );
  }

  @override
  List<Object?> get props => [
        userList,
        fetchStatus,
        createStatus,
        isValid,
        firstName,
        lastName,
        phoneNumber,
        errorMessageList,
        filteredUserList,
      ];
}
