part of 'home_cubit.dart';

class HomeState extends Equatable {
  final User selectedUser;

  /// isValid == Each textFormField is filled.
  final bool isValid;

  /// isUpdate == update // !isUpdate == create
  final bool isUpdate;

  /// isUserEditable (when go to user page) == userCanBeEditable
  final bool isUserEditable;

  final Name firstName;
  final Name lastName;
  final PhoneNumber phoneNumber;
  final Status fetchStatus;
  final Status createStatus;
  final Status deleteStatus;
  final List<User> userList;

  /// filteredUserList for search
  final List<User> filteredUserList;
  final List<String> errorMessageList;

  const HomeState({
    this.userList = const [],
    this.filteredUserList = const [],
    this.errorMessageList = const [],
    this.isValid = false,
    this.isUpdate = false,
    this.isUserEditable = false,
    this.lastName = Name.empty,
    this.firstName = Name.empty,
    this.phoneNumber = PhoneNumber.empty,
    this.fetchStatus = Status.idle,
    this.createStatus = Status.idle,
    this.deleteStatus = Status.idle,
    this.selectedUser = const User.empty(),
  });

  HomeState copyWith({
    bool? isValid,
    bool? isUpdate,
    bool? isUserEditable,
    Name? firstName,
    Name? lastName,
    User? selectedUser,
    PhoneNumber? phoneNumber,
    Status? fetchStatus,
    Status? createStatus,
    Status? deleteStatus,
    List<User>? userList,
    List<User>? filteredUserList,
    List<String>? errorMessageList,
  }) {
    return HomeState(
      isValid: isValid ?? this.isValid,
      isUpdate: isUpdate ?? this.isUpdate,
      userList: userList ?? this.userList,
      lastName: lastName ?? this.lastName,
      firstName: firstName ?? this.firstName,
      fetchStatus: fetchStatus ?? this.fetchStatus,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createStatus: createStatus ?? this.createStatus,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      selectedUser: selectedUser ?? this.selectedUser,
      isUserEditable: isUserEditable ?? this.isUserEditable,
      errorMessageList: errorMessageList ?? this.errorMessageList,
      filteredUserList: filteredUserList ?? this.filteredUserList,
    );
  }

  @override
  List<Object?> get props => [
        isValid,
        userList,
        isUpdate,
        lastName,
        firstName,
        fetchStatus,
        phoneNumber,
        selectedUser,
        createStatus,
        deleteStatus,
        isUserEditable,
        errorMessageList,
        filteredUserList,
      ];
}
