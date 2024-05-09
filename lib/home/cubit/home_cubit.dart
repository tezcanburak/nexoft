import 'package:nexoft/exports.dart';
import 'package:nexoft/home/repository/home_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _homeRepository;

  HomeCubit(this._homeRepository) : super(const HomeState());
}
