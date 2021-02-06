class User {
  User({this.id, this.name});

  int id;
  String name;

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];
}