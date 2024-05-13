part of 'home_cubit.dart';

class HomeState extends Equatable {
  final User selectedUser;
  final User editedSelectedUser;

  final XFile? image;

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
  final Status updateStatus;
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
    this.updateStatus = Status.idle,
    this.deleteStatus = Status.idle,
    this.selectedUser = const User.empty(),
    this.editedSelectedUser = const User.empty(),
    this.image,
  });

  HomeState copyWith({
    XFile? image,
    bool? isValid,
    bool? isUpdate,
    bool? isUserEditable,
    Name? firstName,
    Name? lastName,
    User? selectedUser,
    User? editedSelectedUser,
    PhoneNumber? phoneNumber,
    Status? fetchStatus,
    Status? createStatus,
    Status? updateStatus,
    Status? deleteStatus,
    List<User>? userList,
    List<User>? filteredUserList,
    List<String>? errorMessageList,
  }) {
    return HomeState(
      image: image ?? this.image,
      isValid: isValid ?? this.isValid,
      isUpdate: isUpdate ?? this.isUpdate,
      userList: userList ?? this.userList,
      lastName: lastName ?? this.lastName,
      firstName: firstName ?? this.firstName,
      fetchStatus: fetchStatus ?? this.fetchStatus,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createStatus: createStatus ?? this.createStatus,
      updateStatus: updateStatus ?? this.updateStatus,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      selectedUser: selectedUser ?? this.selectedUser,
      isUserEditable: isUserEditable ?? this.isUserEditable,
      errorMessageList: errorMessageList ?? this.errorMessageList,
      filteredUserList: filteredUserList ?? this.filteredUserList,
      editedSelectedUser: editedSelectedUser ?? this.editedSelectedUser,
    );
  }

  @override
  List<Object?> get props => [
        image,
        isValid,
        userList,
        isUpdate,
        lastName,
        firstName,
        fetchStatus,
        phoneNumber,
        selectedUser,
        createStatus,
        updateStatus,
        deleteStatus,
        isUserEditable,
        errorMessageList,
        filteredUserList,
        editedSelectedUser,
      ];
}
