import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String errorMessage;
  const Failure({required this.errorMessage});
  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.errorMessage});
}

class NoNetworkFailure extends Failure {
  const NoNetworkFailure({required super.errorMessage});
}

class EmptyCacheFailure extends Failure{
  const EmptyCacheFailure({required super.errorMessage});
}