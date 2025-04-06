import 'package:nanoid2/nanoid2.dart';

final class NanoidUtils {
  static const String alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
  static const int length = 21;

  /// Generates a random ID using the Nanoid algorithm.
  static String generate({String? prefix, int? length, String? alphabet}) {
    final String id = nanoid(alphabet: alphabet ?? NanoidUtils.alphabet, length: length ?? NanoidUtils.length);
    return prefix != null ? '${prefix}_$id' : id;
  }

  /// Check if a NanoID is valid based on expected length and allowed characters
  static bool isValid(String id, {int expectedLength = 21, String? allowedChars}) {
    if (id.length != expectedLength) return false;
    if (allowedChars == null) return true;
    final regex = RegExp('^[$allowedChars]+\$');
    return regex.hasMatch(id);
  }

}