class DatabaseHelper {
  static DatabaseHelper? _instance;
  static DatabaseHelper get instance => _instance ??= DatabaseHelper._();
  DatabaseHelper._();

  Future<void> initDatabase() async {
    // Mock implementation - no database functionality
  }

  Future<int> getPendingCount() async {
    // Mock implementation - return 0
    return 0;
  }

  Future<List<Map<String, dynamic>>> getPendingRecords() async {
    // Mock implementation - return empty list
    return [];
  }

  Future<void> insertAttendanceRecords(List<Map<String, dynamic>> records) async {
    // Mock implementation - do nothing
  }

  Future<void> markAsSynced(List<int> recordIds) async {
    // Mock implementation - do nothing
  }
}