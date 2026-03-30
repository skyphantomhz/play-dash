import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/models/match_record.dart';

/// Key used to store the match history list in SharedPreferences.
const _kMatchHistoryKey = 'match_history_v1';

/// Maximum number of match records to keep locally.
const _kMaxRecords = 200;

/// Repository responsible for persisting and retrieving [MatchRecord]s using
/// [SharedPreferences].  All public methods are async-safe and will never throw;
/// errors are silently swallowed to avoid disrupting the game UI.
class MatchHistoryRepository {
  MatchHistoryRepository(this._prefs);

  final SharedPreferences _prefs;

  // --------------------------------------------------------------------------
  // Read
  // --------------------------------------------------------------------------

  /// Returns all stored [MatchRecord]s, most-recent first.
  List<MatchRecord> getAll() {
    final rawList = _prefs.getStringList(_kMatchHistoryKey) ?? <String>[];
    final records = <MatchRecord>[];
    for (final raw in rawList) {
      try {
        final map = jsonDecode(raw) as Map<String, dynamic>;
        records.add(MatchRecord.fromJson(map));
      } catch (_) {
        // Skip malformed entries.
      }
    }
    // Most-recent first.
    records.sort((a, b) => b.playedAt.compareTo(a.playedAt));
    return records;
  }

  // --------------------------------------------------------------------------
  // Write
  // --------------------------------------------------------------------------

  /// Persists a new [record].  Trims the list to [_kMaxRecords] if necessary.
  Future<void> save(MatchRecord record) async {
    final existing = _prefs.getStringList(_kMatchHistoryKey) ?? <String>[];

    final encoded = jsonEncode(record.toJson());
    final updated = <String>[encoded, ...existing];

    // Trim oldest entries when the cap is exceeded.
    final trimmed = updated.length > _kMaxRecords
        ? updated.sublist(0, _kMaxRecords)
        : updated;

    await _prefs.setStringList(_kMatchHistoryKey, trimmed);
  }

  /// Removes all stored match records.
  Future<void> clearAll() async {
    await _prefs.remove(_kMatchHistoryKey);
  }
}
