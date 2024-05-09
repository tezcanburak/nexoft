import 'package:nexoft/exports.dart';
import 'package:nexoft/model/user.dart';
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
      apiResult.data?.sort((a, b) {
        if (a.firstName == null && b.firstName == null) {
          return 0; // If both names are null, maintain current order
        } else if (a.firstName == null) {
          return 1; // Move items with null names to the end
        } else if (b.firstName == null) {
          return -1; // Keep items with non-null names before null names
        } else {
          return a.firstName!.toUpperCase().compareTo(b.firstName!.toUpperCase()); // Compare non-null names
        }
      });
      List<User> userList = List.from(state.userList);
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
}
