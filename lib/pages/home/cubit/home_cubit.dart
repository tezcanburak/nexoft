import 'package:nexoft/exports.dart';
import 'package:nexoft/model/name.dart';
import 'package:nexoft/model/user.dart';
import 'package:nexoft/model/phone_number.dart';
import 'package:nexoft/dio/network_response/api_result.dart';
import 'package:nexoft/pages/home/repository/home_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository homeRepository;

  HomeCubit({required this.homeRepository}) : super(const HomeState());

  Future<void> getAllUserListRequested() async {
    emit(
      state.copyWith(
        fetchStatus: Status.inProgress,
      ),
    );

    ApiResult<List<User>?> apiResult = await homeRepository.getAllUsers();
    List<User>? apiUserList = apiResult.data;
    if (apiResult.success && apiUserList != null) {
      sort(apiUserList);
      List<User> userList = List.empty(growable: true);
      userList.addAll(apiUserList);
      emit(
        state.copyWith(
          fetchStatus: Status.idle,
          userList: userList,
          filteredUserList: userList,
        ),
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
          return a.firstName!.compareTo(b.firstName!);
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
    User user = User(
      firstName: state.firstName.value,
      lastName: state.lastName.value,
      phoneNumber: state.phoneNumber.value,
      profileImageUrl: null,
    );

    User? createdUser = await homeRepository.createUser(user);

    if (createdUser != null) {
      List<User> userList = List.from(state.userList);
      userList.add(createdUser);
      sort(userList);
      emit(
        state.copyWith(
          userList: userList,
          selectedUser: createdUser,
          createStatus: Status.success,
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

  Future<void> deleteUserRequested(String userId) async {
    emit(
      state.copyWith(
        deleteStatus: Status.inProgress,
      ),
    );

    bool isSuccess = await homeRepository.deleteUser(userId);

    if (isSuccess) {
      /*    List<User> userList = List.from(state.userList);
        var deletedUser = userList.where((element) => element.id!.contains(userId));
        void newUserList = userList.removeWhere((e) => e.id == userId);*/

      /// TODO: Burada hata var, uyg crash alıyor!!!
      getAllUserListRequested();
      emit(
        state.copyWith(
          deleteStatus: Status.success,
        ),
      );
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
        selectedUser: selectedUser,
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
    emit(
      state.copyWith(
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
    emit(
      state.copyWith(
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
    emit(
      state.copyWith(
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
