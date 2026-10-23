abstract class ScreenTimeAdapter {
  Future<bool> hasUsagePermission();
  Future<bool> requestUsagePermission();
  Future<int?> getMinutesSpentOnApp(
    String packageNameOrBundleId,
    DateTime date,
  );
}

class LocalScreenTimeAdapter implements ScreenTimeAdapter {
  @override
  Future<bool> hasUsagePermission() async => false;

  @override
  Future<bool> requestUsagePermission() async => false;

  @override
  Future<int?> getMinutesSpentOnApp(
    String packageNameOrBundleId,
    DateTime date,
  ) async => null;
}
