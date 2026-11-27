import 'package:flutter/foundation.dart';
import '../models/planner_models.dart';
import '../models/user_preferences.dart';
import '../models/user_stats.dart';
import '../models/watchlist_item.dart';
import '../services/supabase_db_service.dart';

class PlannerProvider extends ChangeNotifier {
  final SupabaseDbService service;
  PlannerProvider({SupabaseDbService? service}) : service = service ?? SupabaseDbService();
  List<ScheduledMovieNight> scheduledNights = [];
  List<WatchLog> watchLogs = [];
  List<MovieReview> reviews = [];
  List<WatchlistItem> watchlist = [];
  UserPreferences preferences = UserPreferences();
  UserStats stats = UserStats();
  bool loading = false;
  void _recompute() => stats = UserStats.fromData(nights:scheduledNights, logs:watchLogs, reviews:reviews);
  Future<void> loadAll() async {
    loading = true; notifyListeners();
    try {
      final data = await service.loadPlannerData();
      scheduledNights = (data[0] as List).map((e)=>ScheduledMovieNight.fromJson(e)).toList();
      watchLogs = (data[1] as List).map((e)=>WatchLog.fromJson(e)).toList();
      reviews = (data[2] as List).map((e)=>MovieReview.fromJson(e)).toList();
      watchlist = (data[3] as List).map((e)=>WatchlistItem.fromJson(e)).toList();
      final pref = data[4] as Map<String,dynamic>?;
      preferences = pref == null ? UserPreferences() : UserPreferences.fromJson(pref);
      _recompute();
    } finally { loading = false; notifyListeners(); }
  }
  Future<void> load() => loadAll();
  void clear() {
    scheduledNights = [];
    watchLogs = [];
    reviews = [];
    watchlist = [];
    preferences = UserPreferences();
    stats = UserStats();
    loading = false;
    notifyListeners();
  }
  Future<void> deleteNight(String id) async { await service.deleteNight(id); scheduledNights.removeWhere((e)=>e.id==id); _recompute(); notifyListeners(); }
  Future<void> toggleWatchlist(WatchlistItem item) async { final exists=watchlist.any((e)=>e.tmdbId==item.tmdbId); if(exists){await service.removeWatchlistItem(item.tmdbId);watchlist.removeWhere((e)=>e.tmdbId==item.tmdbId);}else{await service.addWatchlistItem(item);watchlist.add(item);} notifyListeners(); }
}
