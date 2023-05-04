class ServerException implements Exception{
  final String exceptionMessage;
  ServerException({required this.exceptionMessage});
}

class NoNetworkException implements Exception{
  final String exceptionMessage;
  NoNetworkException({required this.exceptionMessage});
}

class EmptyCacheException implements Exception{
  final String exceptionMessage;
  EmptyCacheException({required this.exceptionMessage});
}