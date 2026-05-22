class UserPreferenceModel {
  final String userId;
  final String region;
  final List<String> preferredServices;

  UserPreferenceModel({
    required this.userId,
    required this.region,
    this.preferredServices = const [],
  });
}
