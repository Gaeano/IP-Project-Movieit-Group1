import 'package:hive/hive.dart';

part 'watchlist_item.g.dart';

@HiveType(typeId: 5)
class WatchlistItem extends HiveObject {
  @HiveField(0)
  final int tmdbId;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String posterPath;
  @HiveField(3)
  final int runtimeMinutes;
  @HiveField(4)
  final List<int> genreIds;
  @HiveField(5)
  DateTime cachedAt;

  DateTime get addedAt => cachedAt;

  WatchlistItem({
    required this.tmdbId,
    required this.title,
    required this.posterPath,
    required this.runtimeMinutes,
    required this.genreIds,
    DateTime? cachedAt,
    DateTime? addedAt,
  }) : cachedAt = cachedAt ?? addedAt ?? DateTime.now();

  factory WatchlistItem.fromJson(Map<String, dynamic> json) => WatchlistItem(
        tmdbId: json['tmdb_id'] as int,
        title: json['title'] as String,
        posterPath: json['poster_path'] as String? ?? '',
        runtimeMinutes: json['runtime_minutes'] as int? ?? 0,
        genreIds: List<int>.from(json['genre_ids'] ?? const []),
        addedAt: DateTime.tryParse(json['added_at']?.toString() ?? '') ?? DateTime.now(),
      );
}
