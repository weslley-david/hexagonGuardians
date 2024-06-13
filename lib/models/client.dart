class Client {
  int? id;
  String? identifier;
  String? name;
  String? bio;
  String? imageurl;
  String? birthdate;
  String? code;
  String? createdAt;
  String? updatedAt;

  Client(
      {this.id,
      this.identifier,
      this.name,
      this.bio,
      this.imageurl,
      this.birthdate,
      this.code,
      this.createdAt,
      this.updatedAt});

  Client.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    identifier = json['identifier'];
    name = json['name'];
    bio = json['bio'];
    imageurl = json['imageurl'];
    birthdate = json['birthdate'];
    code = json['code'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['identifier'] = identifier;
    data['name'] = name;
    data['bio'] = bio;
    data['imageurl'] = imageurl;
    data['birthdate'] = birthdate;
    data['code'] = code;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
