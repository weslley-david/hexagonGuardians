class Specialist {
  int? id;
  String? identifier;
  String? name;
  String? bio;
  String? crm;
  String? email;
  String? password;
  String? imageurl;
  String? birthdate;
  String? specialty;
  String? createdAt;
  String? updatedAt;

  Specialist(
      {this.id,
      this.identifier,
      this.name,
      this.bio,
      this.crm,
      this.email,
      this.password,
      this.imageurl,
      this.birthdate,
      this.specialty,
      this.createdAt,
      this.updatedAt});

  Specialist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    identifier = json['identifier'];
    name = json['name'];
    bio = json['bio'];
    crm = json['crm'];
    email = json['email'];
    password = json['password'];
    imageurl = json['imageurl'];
    birthdate = json['birthdate'];
    specialty = json['specialty'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['identifier'] = identifier;
    data['name'] = name;
    data['bio'] = bio;
    data['crm'] = crm;
    data['email'] = email;
    data['password'] = password;
    data['imageurl'] = imageurl;
    data['birthdate'] = birthdate;
    data['specialty'] = specialty;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
