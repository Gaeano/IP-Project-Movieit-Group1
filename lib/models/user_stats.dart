import 'package:hive/hive.dart';
import 'planner_models.dart';

part 'user_stats.g.dart';

@HiveType(typeId: 2)
class UserStats extends HiveObject {
  @HiveField(0)
  int nightsPlanned;

  @HiveField(1)
  int totalRuntimeMinutes;

  @HiveField(2)
  double totalRatingSum; 

  @HiveField(3)
  int totalMoviesRated;

  @HiveField(4)
  Map<String, int> genreCounts; 

  @HiveField(5)
  Map<String, int> platformCounts;

  @HiveField(6)
  int streakPersonalBest;

  UserStats({
    this.nightsPlanned = 0,
    this.totalRuntimeMinutes = 0,
    this.totalRatingSum = 0.0,
    this.totalMoviesRated = 0,
    this.genreCounts = const {},
    this.platformCounts = const {},
    this.streakPersonalBest = 0,
  });

  double get averageRating => totalMoviesRated == 0 ? 0.0 : totalRatingSum / totalMoviesRated;

  factory UserStats.fromData({
    required List<ScheduledMovieNight> nights,
    required List<WatchLog> logs,
    required List<MovieReview> reviews,
  }) {
    final platformCounts = <String, int>{};
    for (final night in nights) {
      if (night.platform != null && night.platform!.isNotEmpty) {
        platformCounts[night.platform!] =
            (platformCounts[night.platform!] ?? 0) + 1;
      }
    }

    final totalRuntime = logs.fold<int>(
      0,
      (sum, log) => sum + (log.runtimeMinutes ?? 0),
    );

    final totalRatingSum = reviews.fold<double>(
      0.0,
      (sum, r) => sum + r.rating.toDouble(),
    );

    return UserStats(
      nightsPlanned: nights.length,
      totalRuntimeMinutes: totalRuntime,
      totalRatingSum: totalRatingSum,
      totalMoviesRated: reviews.length,
      platformCounts: platformCounts,
      streakPersonalBest: _computeBestStreak(logs),
    );
  }

  static int _computeBestStreak(List<WatchLog> logs) {
    if (logs.isEmpty) return 0;

    final uniqueDays = logs
        .map((l) => DateTime(l.watchedOn.year, l.watchedOn.month, l.watchedOn.day))
        .toSet()
        .toList()
      ..sort();

    int best = 1;
    int current = 1;
    for (int i = 1; i < uniqueDays.length; i++) {
      if (uniqueDays[i].difference(uniqueDays[i - 1]).inDays == 1) {
        current++;
        if (current > best) best = current;
      } else {
        current = 1;
      }
    }
    return best;
  }
}
