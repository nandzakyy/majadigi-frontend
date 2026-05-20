/// Helpers for normalizing user maps from the API (snake_case or camelCase).
class UserUtils {
  static String? _str(Map<String, dynamic> user, String camel, String snake) {
    final v = user[camel] ?? user[snake];
    if (v == null) return null;
    final s = v.toString().trim();
    return s.isEmpty ? null : s;
  }

  static String displayName(Map<String, dynamic> user) {
    final full = _str(user, 'fullName', 'full_name');
    if (full != null) return full;
    final first = _str(user, 'firstName', 'first_name') ?? '';
    final last = _str(user, 'lastName', 'last_name') ?? '';
    final combined = '$first $last'.trim();
    return combined.isNotEmpty ? combined : 'Pengguna';
  }

  static String displayEmail(Map<String, dynamic> user) =>
      _str(user, 'email', 'email') ?? '-';

  static String? displayPhone(Map<String, dynamic> user) =>
      _str(user, 'phone', 'phone');

  static String? displayNik(Map<String, dynamic> user) =>
      _str(user, 'nik', 'nik');

  static String? displayAddress(Map<String, dynamic> user) =>
      _str(user, 'address', 'address');

  /// DB column: ENUM('L', 'P')
  static String genderToUi(String? apiGender) {
    if (apiGender == null || apiGender.isEmpty) return 'Perempuan';
    final g = apiGender.toUpperCase();
    if (g == 'L' || g.contains('LAKI')) return 'Laki - Laki';
    if (g == 'P' || g.contains('PEREMPUAN') || g.contains('WANITA')) {
      return 'Perempuan';
    }
    return apiGender;
  }

  static String genderToApi(String uiGender) {
    if (uiGender.toUpperCase() == 'L' || uiGender.contains('Laki')) return 'L';
    return 'P';
  }

  static String formatBirthDateForDisplay(dynamic value) {
    if (value == null) return '';
    final raw = value.toString();
    if (raw.isEmpty) return '';
    try {
      final date = DateTime.parse(raw.split(' ').first);
      final d = date.day.toString().padLeft(2, '0');
      final m = date.month.toString().padLeft(2, '0');
      return '$d/$m/${date.year}';
    } catch (_) {
      return raw;
    }
  }

  static String? birthDateToApi(String display) {
    final trimmed = display.trim();
    if (trimmed.isEmpty) return null;
    final parts = trimmed.split('/');
    if (parts.length == 3) {
      final day = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final year = int.tryParse(parts[2]);
      if (day != null && month != null && year != null) {
        return '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
      }
    }
    return trimmed;
  }
}
