class Guardian {
  int? id;
  String? identifier;
  String? name;
  String? bio;
  String? email;
  String? password;
  String? imageurl;
  String? birthdate;
  String? createdAt;
  String? updatedAt;

  Guardian(
      {this.id,
      this.identifier,
      this.name,
      this.bio,
      this.email,
      this.password,
      this.imageurl,
      this.birthdate,
      this.createdAt,
      this.updatedAt});

  Guardian.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    identifier = json['identifier'];
    name = json['name'];
    bio = json['bio'];
    email = json['email'];
    password = json['password'];
    imageurl = json['imageurl'];
    birthdate = json['birthdate'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['identifier'] = identifier;
    data['name'] = name;
    data['bio'] = bio;
    data['email'] = email;
    data['password'] = password;
    data['imageurl'] = imageurl;
    data['birthdate'] = birthdate;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
