class ProfilePrivacyStore {
 
  final Map<String, bool> _privacy = {};

  bool isPrivate(String userId) => _privacy[userId] ?? false;

  void setPrivacy(String userId, bool value) {
    _privacy[userId] = value;
  }
}
