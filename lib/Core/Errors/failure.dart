import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  // Todo: Using Equatable as if there instance from object have the same value, will not create new instance as there one already created before with the same values
  final String message;
  const Failure({required this.message});

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure{
  const ServerFailure({required super.message});
}

class CacheFailure extends Failure{
  const CacheFailure({required super.message});
}