import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/planner_models.dart';
import '../models/watchlist_item.dart';

class SupabaseDbService {
  final SupabaseClient client;
  SupabaseDbService({SupabaseClient? client}) : client = client ?? Supabase.instance.client;
  String get userId { final id = client.auth.currentUser?.id; if (id == null) throw StateError('Sign in is required'); return id; }

  Future<List<dynamic>> loadPlannerData() async {
    final uid = userId;
    final results = await Future.wait<dynamic>([
      client.from('scheduled_movie_nights').select().eq('user_id', uid),
      client.from('watch_logs').select().eq('user_id', uid),
      client.from('reviews').select().eq('user_id', uid),
      client.from('watchlist_items').select().eq('user_id', uid),
      client.from('user_preferences').select().eq('user_id', uid).maybeSingle(),
    ]);
    return results;
  }

  Future<void> provisionDefaults(String uid) async {
    await client.from('user_preferences').upsert({'user_id':uid, 'notifications_enabled':true, 'reminder_lead_minutes':30, 'region':'US', 'streaming_platforms':<String>[]}, onConflict:'user_id', ignoreDuplicates:true);
  }
  Future<void> addWatchlistItem(WatchlistItem item) => client.from('watchlist_items').upsert({'user_id':userId,'tmdb_id':item.tmdbId,'title':item.title,'poster_path':item.posterPath,'runtime_minutes':item.runtimeMinutes,'genre_ids':item.genreIds,'added_at':item.addedAt.toIso8601String()});
  Future<void> removeWatchlistItem(int tmdbId) => client.from('watchlist_items').delete().eq('user_id',userId).eq('tmdb_id',tmdbId);
  Future<void> addNight(ScheduledMovieNight night) => client.from('scheduled_movie_nights').insert(night.toJson());
  Future<void> updateNight(ScheduledMovieNight night) => client.from('scheduled_movie_nights').update(night.toJson()..remove('id')..remove('user_id')).eq('user_id',userId).eq('id',night.id);
  Future<void> deleteNight(String id) => client.from('scheduled_movie_nights').delete().eq('user_id',userId).eq('id',id);
}
