class User {
  final String? id;
  final String? username;
  final String? name;

  User({this.username, this.name, required this.id});
  factory User.fromMap(Map<String, dynamic> data) {
    return User(
        id: data['_id'], username: data['username'], name: data['name']);
  }
}
