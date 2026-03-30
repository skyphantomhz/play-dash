import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/models/match_record.dart';
import 'match_history_repository.dart';

// ---------------------------------------------------------------------------
// SharedPreferences provider – initialised once in main.dart via overrides.
// ---------------------------------------------------------------------------

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden before use. '
    'Call ProviderScope(overrides: [sharedPreferencesProvider.overrideWithValue(prefs)]).',
  );
});

// ---------------------------------------------------------------------------
// Repository provider
// ---------------------------------------------------------------------------

final matchHistoryRepositoryProvider = Provider<MatchHistoryRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return MatchHistoryRepository(prefs);
});

// ---------------------------------------------------------------------------
// Match history notifier – keeps an in-memory, sorted list of records that
// stays in sync with SharedPreferences.
// ---------------------------------------------------------------------------

class MatchHistoryNotifier extends Notifier<List<MatchRecord>> {
  @override
  List<MatchRecord> build() {
    // Load persisted records on first access.
    final repo = ref.read(matchHistoryRepositoryProvider);
    return repo.getAll();
  }

  /// Persists [record] and refreshes the in-memory list.
  Future<void> addRecord(MatchRecord record) async {
    final repo = ref.read(matchHistoryRepositoryProvider);
    await repo.save(record);
    // Reload to get the authoritative sorted list.
    state = repo.getAll();
  }

  /// Clears all history (useful for testing / settings screen).
  Future<void> clearAll() async {
    final repo = ref.read(matchHistoryRepositoryProvider);
    await repo.clearAll();
    state = const [];
  }
}

final matchHistoryProvider =
    NotifierProvider<MatchHistoryNotifier, List<MatchRecord>>(
  MatchHistoryNotifier.new,
);

// ---------------------------------------------------------------------------
// Derived leaderboard entries – computed from match history.
// ---------------------------------------------------------------------------

/// A single entry in the leaderboard table.
class LeaderboardEntry {
  const LeaderboardEntry({
    required this.rank,
    required this.playerName,
    required this.totalGames,
    required this.wins,
    required this.winRate,
    required this.score,
  });

  final int rank;
  final String playerName;
  final int totalGames;
  final int wins;
  final double winRate;

  /// Composite score used for ranking:
  /// wins × 1000 + winRate × 100  (deterministic, no floating-point surprises).
  final int score;

  String get metaText =>
      '$totalGames ${totalGames == 1 ? 'Game' : 'Games'} · $wins ${wins == 1 ? 'Win' : 'Wins'}';
}

final leaderboardEntriesProvider = Provider<List<LeaderboardEntry>>((ref) {
  final history = ref.watch(matchHistoryProvider);

  if (history.isEmpty) {
    return const [];
  }

  // Aggregate per-player stats.
  final stats = <String, _PlayerStats>{};

  for (final record in history) {
    for (final result in record.playerResults) {
      final entry = stats.putIfAbsent(
        result.playerName,
        () => _PlayerStats(result.playerName),
      );
      entry.totalGames++;
      if (result.won) entry.wins++;
    }
  }

  // Convert to LeaderboardEntry and sort by score descending.
  final entries = stats.values.map((s) {
    final winRate = s.totalGames > 0 ? s.wins / s.totalGames : 0.0;
    final score = s.wins * 1000 + (winRate * 100).round();
    return LeaderboardEntry(
      rank: 0, // assigned after sort
      playerName: s.name,
      totalGames: s.totalGames,
      wins: s.wins,
      winRate: winRate,
      score: score,
    );
  }).toList()
    ..sort((a, b) => b.score.compareTo(a.score));

  // Assign ranks (1-based).
  return [
    for (var i = 0; i < entries.length; i++)
      LeaderboardEntry(
        rank: i + 1,
        playerName: entries[i].playerName,
        totalGames: entries[i].totalGames,
        wins: entries[i].wins,
        winRate: entries[i].winRate,
        score: entries[i].score,
      ),
  ];
});

// ---------------------------------------------------------------------------
// Private helper
// ---------------------------------------------------------------------------

class _PlayerStats {
  _PlayerStats(this.name);

  final String name;
  int totalGames = 0;
  int wins = 0;
}
