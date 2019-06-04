class User {
  String id;
  String provider;
  String name;
  String avatar;

  User({this.id, this.provider, this.name, this.avatar});

  @override
  String toString() {
    return '{id: $id, name: $name, provider: $provider, avatar: $avatar}';
  }
}
