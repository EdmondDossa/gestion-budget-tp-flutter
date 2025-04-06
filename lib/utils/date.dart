final class DateUtils {
  static DateTime? tryParse(String? isoDate) {
    if (isoDate == null) return null;

    try {
      return DateTime.parse(isoDate);
    } catch (e) {
      return null;
    }
  }

  static DateTime parse(String isoDate) {
    return DateTime.parse(isoDate);
  }

}