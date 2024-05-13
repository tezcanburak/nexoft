import 'package:nexoft/exports.dart';
import 'package:nexoft/model/name.dart';
import 'package:nexoft/model/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nexoft/model/phone_number.dart';
import 'package:nexoft/dio/network_response/api_result.dart';
import 'package:nexoft/pages/home/repository/home_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository homeRepository;

  HomeCubit({required this.homeRepository}) : super(const HomeState());

  Future<void> getUsersList() async {
    emit(
      state.copyWith(
        fetchStatus: Status.inProgress,
      ),
    );

    ApiResult<List<User>?> apiResult = await homeRepository.getAllUsers(state.userList.length);
    List<User>? apiUserList = apiResult.data;
    if (apiResult.success && apiUserList != null) {
      sort(apiUserList);
      List<User> tU = List.from(state.userList);
      tU.addAll(apiUserList);

      //It is added to show circular progress bar indicator only.
      await Future.delayed(const Duration(seconds: 2));

      emit(
        state.copyWith(fetchStatus: Status.idle, userList: tU, filteredUserList: tU),
      );
    } else {
      emit(
        state.copyWith(
          errorMessageList: apiResult.messages,
          fetchStatus: Status.failure,
        ),
      );
    }
  }

  Future<void> filterUserListRequested(String text) async {
    var value = text.toLowerCase();
    List<User> unSorted = List.from(state.userList);
    sort(unSorted);
    emit(
      state.copyWith(
        filteredUserList: state.userList.where((element) {
          return (element.firstName?.toLowerCase().contains(value) ?? false);
        }).toList(),
      ),
    );
  }

  void setImage(XFile? image) {
    emit(state.copyWith(image: image));
  }

  void sort(List<User> unSorted) {
    unSorted.sort(
      (a, b) {
        if (a.firstName == null && b.firstName == null) {
          return 0;
        } else if (a.firstName == null) {
          return 1;
        } else if (b.firstName == null) {
          return -1;
        } else {
          // Compare non-null values
          return a.firstName!.toLowerCase().compareTo(b.firstName!.toLowerCase());
        }
      },
    );
  }

  Future<void> createUserRequested() async {
    emit(
      state.copyWith(
        createStatus: Status.inProgress,
      ),
    );
    if (state.image != null) {
      String? url = await homeRepository.uploadPhoto(state.image!);
      if (url != null && url.isNotEmpty) {
        User user = User(
          firstName: state.firstName.value,
          lastName: state.lastName.value,
          phoneNumber: state.phoneNumber.value,
          profileImageUrl: url,
        );
        ApiResult<User>? createdUser = await homeRepository.createUser(user);

        if (createdUser != null && createdUser.success == true) {
          List<User> userList = List.from(state.userList);
          userList.add(createdUser.data!);
          sort(userList);
          emit(
            state.copyWith(
              userList: userList,
              selectedUser: createdUser.data!,
              createStatus: Status.success,
              image: null,
            ),
          );
        } else {
          emit(
            state.copyWith(
              createStatus: Status.failure,
            ),
          );
        }
      }
    } else {
      User user = User(
        firstName: state.firstName.value,
        lastName: state.lastName.value,
        phoneNumber: state.phoneNumber.value,
        profileImageUrl: null,
      );
      ApiResult<User>? createdUser = await homeRepository.createUser(user);

      if (createdUser != null && createdUser.success == true) {
        List<User> userList = List.from(state.userList);
        userList.add(createdUser.data!);
        sort(userList);
        emit(
          state.copyWith(
            userList: userList,
            selectedUser: createdUser.data!,
            createStatus: Status.success,
            image: null,
          ),
        );
      } else {
        emit(
          state.copyWith(
            createStatus: Status.failure,
          ),
        );
      }
    }
  }

  /// Update user info except PHOTO!!!
  /// Update user photo is automatically done via choosing the picture!!! (addOrUpdateUserPhoto())
  Future<void> updateUserRequested() async {
    emit(
      state.copyWith(
        updateStatus: Status.inProgress,
      ),
    );
    User selectedUser = state.selectedUser;
    User editedUser = state.editedSelectedUser;
    User updatedUser = User(
      id: null,
      createdAt: null,
      firstName: selectedUser.firstName == editedUser.firstName ? null : editedUser.firstName,
      lastName: selectedUser.lastName == editedUser.lastName ? null : editedUser.lastName,
      phoneNumber: selectedUser.phoneNumber == editedUser.phoneNumber ? null : editedUser.phoneNumber,
      profileImageUrl: null,
    );
    if (selectedUser.id != null) {
      bool isUserUpdated = await homeRepository.updateUser(selectedUser.id!, updatedUser);
      if (isUserUpdated) {
        emit(
          state.copyWith(
            selectedUser: editedUser,
            editedSelectedUser: editedUser,
            updateStatus: Status.success,
            image: null,
          ),
        );
      }
      List<User> userList = List.from(state.userList);
      var index = userList.indexWhere((element) => element.id == editedUser.id);
      if (index != -1) {
        userList[index] = editedUser;
        sort(userList);
        emit(state.copyWith(filteredUserList: userList, userList: userList));
      }
    } else {
      emit(
        state.copyWith(
          updateStatus: Status.failure,
        ),
      );
    }
  }

  /// This is just for update!!!
  /// DO NOT USE WHEN CREATING NEW USER!!!
  /// After creating user, in edit page(this means it's update) You can use!!!
  Future<void> addOrUpdateUserPhoto() async {
    emit(
      state.copyWith(updateStatus: Status.inProgress),
    );
    User selectedUser = state.selectedUser;
    if (selectedUser.id != null) {
      String? url = await homeRepository.uploadPhoto(state.image!);
      if (url != null && url.isNotEmpty) {
        User updatedUser = User(profileImageUrl: url);
        bool isUserUpdated = await homeRepository.updateUser(selectedUser.id!, updatedUser);
        if (isUserUpdated) {
          User editedUser = state.selectedUser.copyWith(profileImageUrl: url);
          emit(
            state.copyWith(
              selectedUser: editedUser,
              editedSelectedUser: editedUser,
              createStatus: Status.success,
              image: XFile(''),
            ),
          );
        }
      } else {
        emit(
          state.copyWith(createStatus: Status.failure, image: XFile('')),
        );
      }
    } else {
      emit(
        state.copyWith(createStatus: Status.failure, image: XFile('')),
      );
    }
  }

  Future<void> deleteUserRequested(User user) async {
    emit(
      state.copyWith(
        deleteStatus: Status.inProgress,
      ),
    );
    if (user.id != null && user.id!.isNotEmpty) {
      bool isSuccess = await homeRepository.deleteUser(user.id!);
      if (isSuccess) {
        List<User> userList = List.from(state.userList);
        userList.remove(user);
        if (userList.length < 10) {
          getUsersList();
        }
        emit(
          state.copyWith(
            userList: userList,
            filteredUserList: userList,
            deleteStatus: Status.success,
          ),
        );
      }
    } else {
      emit(
        state.copyWith(
          deleteStatus: Status.failure,
        ),
      );
    }
  }

  void selectedUserChanged(User selectedUser) {
    emit(
      state.copyWith(
        image: null,
        selectedUser: selectedUser,
        editedSelectedUser: selectedUser,
      ),
    );
  }

  void createStatusChanged(Status createStatus) {
    emit(
      state.copyWith(
        createStatus: createStatus,
      ),
    );
  }

  void updateStatusChanged(Status updateStatus) {
    emit(
      state.copyWith(
        updateStatus: updateStatus,
      ),
    );
  }

  void deleteStatusChanged(Status deleteStatus) {
    emit(
      state.copyWith(
        deleteStatus: deleteStatus,
      ),
    );
  }

  void isUpdateStatusChanged(bool isUpdate) {
    emit(
      state.copyWith(
        isUpdate: isUpdate,
      ),
    );
  }

  void isUserEditableStatusChanged(bool isUserEditable) {
    emit(
      state.copyWith(
        isUserEditable: isUserEditable,
      ),
    );
  }

  void firstNameChanged(String value) {
    var firstName = Name(value: value).validator();
    User editedSelectedUser = state.editedSelectedUser.copyWith(firstName: value);
    emit(
      state.copyWith(
        editedSelectedUser: editedSelectedUser,
        firstName: firstName,
        isValid: isValid(
          firstName,
          state.lastName,
          state.phoneNumber,
        ),
      ),
    );
  }

  void lastNameChanged(String value) {
    var lastName = Name(value: value).validator();
    User editedSelectedUser = state.editedSelectedUser.copyWith(lastName: value);
    emit(
      state.copyWith(
        editedSelectedUser: editedSelectedUser,
        lastName: lastName,
        isValid: isValid(
          state.firstName,
          lastName,
          state.phoneNumber,
        ),
      ),
    );
  }

  void phoneNumberChanged(String value) {
    var phoneNumber = PhoneNumber(value: value).validator();
    User editedSelectedUser = state.editedSelectedUser.copyWith(phoneNumber: value);
    emit(
      state.copyWith(
        editedSelectedUser: editedSelectedUser,
        phoneNumber: phoneNumber,
        isValid: isValid(
          state.firstName,
          state.lastName,
          phoneNumber,
        ),
      ),
    );
  }

  bool isValid(
    Name? firstName,
    Name? lastName,
    PhoneNumber? phoneNumber,
  ) {
    if (firstName != null && lastName != null && phoneNumber != null) {
      if (firstName.value.trim() != '' && lastName.value.trim() != '' && phoneNumber.value.trim() != '') {
        if (firstName.validator()?.showError == false && lastName.validator()?.showError == false && phoneNumber.validator()?.showError == false) {
          return true;
        }
      }
    }
    return false;
  }
}
