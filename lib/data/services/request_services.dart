class RequestService {
  Future<void> createRequest({
    required String description,
    required String imageUrl,
  }) async {
    // API / Firebase call
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> cancelRequest({
    required String requestId,
    required String reason,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Stream<String> listenForAcceptance(String requestId) async* {
    // Firebase / socket listener
    await Future.delayed(const Duration(seconds: 5));
    yield "accepted";
  }
}
