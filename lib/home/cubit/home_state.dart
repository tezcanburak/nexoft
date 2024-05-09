part of 'home_cubit.dart';

class HomeState extends Equatable {
  final String errorMessage;

  const HomeState({
    this.errorMessage = '',
  });

  HomeState copyWith({
    String? errorMessage,
  }) {
    return HomeState(
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        errorMessage,
      ];
}
