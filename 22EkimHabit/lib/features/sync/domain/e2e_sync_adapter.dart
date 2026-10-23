abstract class E2eSyncAdapter {
  Future<bool> isSyncConfigured();
  Future<void> pushLocalChanges();
  Future<void> pullRemoteChanges();
}

class LocalE2eSyncAdapter implements E2eSyncAdapter {
  @override
  Future<bool> isSyncConfigured() async => false; // Dürüst offline-first / unconfigured state

  @override
  Future<void> pushLocalChanges() async {}

  @override
  Future<void> pullRemoteChanges() async {}
}
