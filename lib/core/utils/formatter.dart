class Formatter {
  /// Capitalizes the first letter of each word in a string
  static String capitalize(String text) {
    return text.split(' ').map((word) {
      if (word.isEmpty) return word; // Prevent errors on empty strings
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  /// Formats an ISO timestamp (e.g., "2025-02-01T18:05:24.289Z") into a human-readable "time ago" format
  static String formatTimeAgo(String timestamp) {
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
      return "${createdAt.day}/${createdAt.month}/${createdAt.year}"; // Show full date if over 30 days
    }
  }

  /// Shortens text if it's longer than `maxLength`, adding "..."
  static String shortenText(String text, {int maxLength = 30}) {
    return text.length > maxLength
        ? "${text.substring(0, maxLength)}..."
        : text;
  }
}
