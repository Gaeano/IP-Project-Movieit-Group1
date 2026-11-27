class ScheduledMovieNight {
  final String id;
  final String userId;
  final int tmdbId;
  final String title;
  final String posterPath;
  final int? runtimeMinutes;
  final DateTime startsAt;
  final DateTime? endsAt;
  final String? platform;
  final String? notes;
  final String status;
  final String? googleEventId;

  const ScheduledMovieNight({required this.id, required this.userId, required this.tmdbId, required this.title, required this.posterPath, this.runtimeMinutes, required this.startsAt, this.endsAt, this.platform, this.notes, this.status = 'planned', this.googleEventId});
  factory ScheduledMovieNight.fromJson(Map<String, dynamic> json) => ScheduledMovieNight(id: json['id'], userId: json['user_id'], tmdbId: json['tmdb_id'], title: json['title'], posterPath: json['poster_path'] ?? '', runtimeMinutes: json['runtime_minutes'], startsAt: DateTime.parse(json['starts_at']), endsAt: json['ends_at'] == null ? null : DateTime.parse(json['ends_at']), platform: json['platform'], notes: json['notes'], status: json['status'] ?? 'planned', googleEventId: json['google_event_id']);
  Map<String, dynamic> toJson() => {'id': id, 'user_id': userId, 'tmdb_id': tmdbId, 'title': title, 'poster_path': posterPath, 'runtime_minutes': runtimeMinutes, 'starts_at': startsAt.toIso8601String(), 'ends_at': endsAt?.toIso8601String(), 'platform': platform, 'notes': notes, 'status': status, 'google_event_id': googleEventId};
}

class WatchLog {
  final String id; final String userId; final int tmdbId; final String title; final String posterPath; final int? runtimeMinutes; final DateTime watchedOn; final String? scheduledNightId; final List<String> genres;
  const WatchLog({required this.id, required this.userId, required this.tmdbId, required this.title, required this.posterPath, this.runtimeMinutes, required this.watchedOn, this.scheduledNightId, this.genres = const []});
  factory WatchLog.fromJson(Map<String,dynamic> j) => WatchLog(id:j['id'], userId:j['user_id'], tmdbId:j['tmdb_id'], title:j['title'], posterPath:j['poster_path']??'', runtimeMinutes:j['runtime_minutes'], watchedOn:DateTime.parse(j['watched_on']), scheduledNightId:j['scheduled_night_id'], genres:List<String>.from(j['genres']??[]));
}

class MovieReview { final String id; final String userId; final int tmdbId; final String? watchLogId; final int rating; final String? body; const MovieReview({required this.id,required this.userId,required this.tmdbId,this.watchLogId,required this.rating,this.body}); factory MovieReview.fromJson(Map<String,dynamic> j)=>MovieReview(id:j['id'],userId:j['user_id'],tmdbId:j['tmdb_id'],watchLogId:j['watch_log_id'],rating:j['rating'],body:j['body']); }
