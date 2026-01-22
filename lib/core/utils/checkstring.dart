import 'package:easy_localization/easy_localization.dart';

bool isNullOrEmpty(String? text) => text == null || text.isEmpty;

String customChangeString(String text) {
  return text.replaceAll(RegExp(r"['[\]]"), '');
}

String customChangeStringWEnter(String text) {
  text = text.replaceAll(RegExp(r","), '\n');
  text = text.replaceAll(RegExp(r'["]'), '');

  return text.replaceAll(RegExp(r"[\\'\[\]]"), '');
}

String formatDuration(dynamic duration) {
  if (duration == null) return "";

  // Direct minute values (int/double or numeric string)
  if (duration is int) return _formatMinutes(duration);
  if (duration is double) return _formatMinutes(duration.round());
  if (duration is String) {
    final trimmed = duration.trim();
    if (trimmed.isEmpty) return "";

    final numericMinutes = int.tryParse(trimmed);
    if (numericMinutes != null) return _formatMinutes(numericMinutes);

    // ISO8601 fallback (PT1H30M)
    final regex = RegExp(r'PT(\d+H)?(\d+M)?(\d+S)?');
    final match = regex.firstMatch(trimmed);
    if (match != null) {
      int totalMinutes = 0;
      if (match.group(1) != null) totalMinutes += int.parse(match.group(1)!.replaceAll('H', '')) * 60;
      if (match.group(2) != null) totalMinutes += int.parse(match.group(2)!.replaceAll('M', ''));
      if (totalMinutes > 0) return _formatMinutes(totalMinutes);

      // If only seconds exist, still show seconds to keep legacy behaviour
      if (match.group(3) != null) {
        final seconds = match.group(3)!.replaceAll('S', '');
        return "$seconds ${'seconds'.tr()}";
      }
    }
  }

  return "";
}

String _formatMinutes(int minutes) {
  if (minutes <= 0) return "";
  final hours = minutes ~/ 60;
  final mins = minutes % 60;

  String hoursText = hours > 0 ? "$hours ${'hour'.tr()}" : "";
  String minutesText = mins > 0 ? "$mins ${'minutes'.tr()}" : "";

  final parts = [hoursText, minutesText].where((part) => part.isNotEmpty).toList();
  return parts.join(' ').trim();
}
