part of 'home_cubit.dart';

class HomeState extends Equatable {
  final List<String> errorMessage;
  final Status fetchStatus;

  const HomeState({
    this.errorMessage = const [],
    this.fetchStatus = Status.idle,
  });

  HomeState copyWith({
    List<String>? errorMessage,
    Status? fetchStatus,
  }) {
    return HomeState(
      fetchStatus: fetchStatus ?? this.fetchStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        fetchStatus,
        errorMessage,
      ];
}
