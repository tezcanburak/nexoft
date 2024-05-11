part of 'home_cubit.dart';

class HomeState extends Equatable {
  final User selectedUser;
  final bool isValid;
  final bool isUpdate;
  final bool isEditable;
  final Name firstName;
  final Name lastName;
  final PhoneNumber phoneNumber;
  final Status fetchStatus;
  final Status createStatus;
  final Status deleteStatus;
  final List<User> userList;
  final List<User> filteredUserList;
  final List<String> errorMessageList;

  const HomeState({
    this.selectedUser = const User.empty(),
    this.userList = const [],
    this.filteredUserList = const [],
    this.errorMessageList = const [],
    this.isValid = false,
    this.isUpdate = false,
    this.isEditable = false,
    this.firstName = Name.empty,
    this.lastName = Name.empty,
    this.phoneNumber = PhoneNumber.empty,
    this.fetchStatus = Status.idle,
    this.createStatus = Status.idle,
    this.deleteStatus = Status.idle,
  });

  HomeState copyWith({
    User? selectedUser,
    List<User>? userList,
    List<User>? filteredUserList,
    List<String>? errorMessageList,
    bool? isValid,
    bool? isUpdate,
    bool? isEditable,
    Name? firstName,
    Name? lastName,
    PhoneNumber? phoneNumber,
    Status? fetchStatus,
    Status? createStatus,
    Status? deleteStatus,
  }) {
    return HomeState(
      selectedUser: selectedUser ?? this.selectedUser,
      userList: userList ?? this.userList,
      fetchStatus: fetchStatus ?? this.fetchStatus,
      createStatus: createStatus ?? this.createStatus,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      isValid: isValid ?? this.isValid,
      isUpdate: isUpdate ?? this.isUpdate,
      isEditable: isEditable ?? this.isEditable,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      errorMessageList: errorMessageList ?? this.errorMessageList,
      filteredUserList: filteredUserList ?? this.filteredUserList,
    );
  }

  @override
  List<Object?> get props => [
        selectedUser,
        userList,
        fetchStatus,
        createStatus,
        deleteStatus,
        isValid,
        isUpdate,
        isEditable,
        firstName,
        lastName,
        phoneNumber,
        errorMessageList,
        filteredUserList,
      ];
}
