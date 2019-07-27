class User {
  String id;
  String provider;
  String name;
  String avatar;
  String fcmToken;
  bool isAnonymous;

  User({this.id, this.provider, this.name, this.avatar, this.isAnonymous});

  @override
  String toString() {
    return '{id: $id, name: $name, provider: $provider, avatar: $avatar, isAnonymous: $isAnonymous, fcmToken: $fcmToken}';
  }
}
