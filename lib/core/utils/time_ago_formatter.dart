class TimeAgoFormatter {
  static String format(String timestamp) {
    final DateTime now = DateTime.now();
    final DateTime createdAt = DateTime.parse(timestamp).toLocal();
    final Duration difference = now.difference(createdAt);

    if (difference.inSeconds < 60) {
      return "${difference.inSeconds}s ago";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes}m ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours}H ago";
    } else if (difference.inDays < 30) {
      return "${difference.inDays}D ago";
    } else {
      return "${createdAt.day}/${createdAt.month}/${createdAt.year}"; // Date format if more than 30 days ago
    }
  }
}
