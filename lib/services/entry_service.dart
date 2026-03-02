import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'settings_service.dart';
import '../utils/date_utils.dart';

class EntryService extends GetxController {
  final storage = Hive.box("entries");

  DateTime? _parseEntryDateKey(String key) {
    return parseDateKey(key);
  }

  final SettingsService settingsService = Get.find<SettingsService>();

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  bool _isInDateRange(DateTime date, {DateTime? startDate, DateTime? endDate}) {
    final normalizedDate = _normalizeDate(date);
    final normalizedStart =
        startDate == null ? null : _normalizeDate(startDate);
    final normalizedEnd = endDate == null ? null : _normalizeDate(endDate);

    final isAfterStart =
        normalizedStart == null || !normalizedDate.isBefore(normalizedStart);
    final isBeforeEnd =
        normalizedEnd == null || !normalizedDate.isAfter(normalizedEnd);
    return isAfterStart && isBeforeEnd;
  }

  int _countWords(String text) {
    final normalized = text.trim();
    if (normalized.isEmpty) {
      return 0;
    }

    return normalized
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .length;
  }

  Map<String, int> getStatistics([DateTime? startDate, DateTime? endDate]) {
    var entries = storage.toMap();
    final statistics = <String, int>{};

    entries.forEach((key, value) {
      final dateTime = _parseEntryDateKey(key.toString());
      if (dateTime == null) {
        return;
      }
      final isInRange =
          _isInDateRange(dateTime, startDate: startDate, endDate: endDate);

      if (isInRange) {
        final mood = value["mood"] as String;
        statistics[mood] = (statistics[mood] ?? 0) + 1;
      }
    });

    return statistics;
  }

  Map<String, int> getCommentStatistics(
      [DateTime? startDate, DateTime? endDate]) {
    var entries = storage.toMap();
    final commentStatistics = <String, int>{};

    entries.forEach((key, value) {
      final dateTime = _parseEntryDateKey(key.toString());
      if (dateTime == null) {
        return;
      }
      final isInRange =
          _isInDateRange(dateTime, startDate: startDate, endDate: endDate);

      if (isInRange) {
        final comment = value["comment"] as String;
        commentStatistics[comment] = (commentStatistics[comment] ?? 0) + 1;
      }
    });

    return commentStatistics;
  }

  Map<String, int> getMonthlyStatistics({
    int monthsBack = 6,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final entries = storage.toMap();
    final now = DateTime.now();
    final from = DateTime(now.year, now.month - monthsBack + 1, 1);
    final monthly = <String, int>{};

    entries.forEach((key, value) {
      final dateTime = _parseEntryDateKey(key.toString());
      if (dateTime == null) {
        return;
      }
      if (startDate != null || endDate != null) {
        if (!_isInDateRange(dateTime, startDate: startDate, endDate: endDate)) {
          return;
        }
      } else if (dateTime.isBefore(from)) {
        return;
      }

      final monthKey =
          '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}';
      monthly[monthKey] = (monthly[monthKey] ?? 0) + 1;
    });

    return monthly;
  }

  Map<String, int> getMonthlyCommentStatistics({
    int monthsBack = 6,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final entries = storage.toMap();
    final now = DateTime.now();
    final from = DateTime(now.year, now.month - monthsBack + 1, 1);
    final monthly = <String, int>{};

    entries.forEach((key, value) {
      final dateTime = _parseEntryDateKey(key.toString());
      if (dateTime == null) {
        return;
      }

      if (startDate != null || endDate != null) {
        if (!_isInDateRange(dateTime, startDate: startDate, endDate: endDate)) {
          return;
        }
      } else if (dateTime.isBefore(from)) {
        return;
      }

      final comment = (value["comment"] as String?)?.trim() ?? '';
      if (comment.isEmpty) {
        return;
      }

      final monthKey =
          '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}';
      monthly[monthKey] = (monthly[monthKey] ?? 0) + 1;
    });

    return monthly;
  }

  Map<String, dynamic> getCommentWordStatistics(
      [DateTime? startDate, DateTime? endDate]) {
    final entries = storage.toMap();
    var totalWords = 0;
    var commentsWithText = 0;
    var longestWordCount = 0;
    var longestComment = '';

    entries.forEach((key, value) {
      final dateTime = _parseEntryDateKey(key.toString());
      if (dateTime == null) {
        return;
      }

      final isInRange =
          _isInDateRange(dateTime, startDate: startDate, endDate: endDate);
      if (!isInRange) {
        return;
      }

      final comment = (value["comment"] as String?)?.trim() ?? '';
      if (comment.isEmpty) {
        return;
      }

      final wordCount = _countWords(comment);
      totalWords += wordCount;
      commentsWithText += 1;

      if (wordCount > longestWordCount) {
        longestWordCount = wordCount;
        longestComment = comment;
      }
    });

    final averageWords =
        commentsWithText == 0 ? 0.0 : totalWords / commentsWithText;

    return {
      "totalWords": totalWords,
      "averageWords": averageWords,
      "longestComment": longestComment,
      "longestWordCount": longestWordCount,
      "commentsWithText": commentsWithText,
    };
  }

  saveEntryAsync(String dateTimeString, String mood, String comment) async {
    await storage.put(dateTimeString, {"mood": mood, "comment": comment});
    update();
  }

  getEntry(String dateTimeString) {
    return storage.get(dateTimeString);
  }

  getColorForDate(String dateTimeString) {
    var entry = storage.get(dateTimeString);
    if (entry == null) {
      return Colors.grey;
    }

    var color = settingsService.getColorSettings()[entry["mood"]];
    return color ?? Colors.grey;
  }

  deleteEntry(String dateTimeString) async {
    await storage.delete(dateTimeString);
    update();
  }

  removeAll() async {
    await storage.clear();
    update();
  }
}
