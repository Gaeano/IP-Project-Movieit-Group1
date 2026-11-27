import 'package:hive/hive.dart';

part 'user_preferences.g.dart';

@HiveType(typeId: 1)
class UserPreferences extends HiveObject {
  @HiveField(0)
  bool notificationsEnabled;

  final int reminderLeadMinutes;
  final String region;
  final List<String> streamingPlatforms;

  UserPreferences({
    this.notificationsEnabled = true,
    this.reminderLeadMinutes = 30,
    this.region = 'US',
    this.streamingPlatforms = const [],
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) => UserPreferences(
        notificationsEnabled: json['notifications_enabled'] as bool? ?? true,
        reminderLeadMinutes: json['reminder_lead_minutes'] as int? ?? 30,
        region: json['region'] as String? ?? 'US',
        streamingPlatforms: List<String>.from(json['streaming_platforms'] ?? const []),
      );
}
