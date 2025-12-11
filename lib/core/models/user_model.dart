class UserModel {
  String? sId;
  String? name;
  String? dob;
  String? partnerName;
  String? country;
  String? city;
  String? profileImage;
  String? createdAt;
  String? updatedAt;
  String? gender;
  String? ipAddress;

  UserModel({
    this.sId,
    this.name,
    this.dob,
    this.partnerName,
    this.country,
    this.city,
    this.profileImage,
    this.createdAt,
    this.updatedAt,
    this.gender,
    this.ipAddress,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    sId = json['id'] ?? json['_id'];
    name = json['name'];
    dob = json['dob'];
    partnerName = json['partner'] ?? json['partner_name'];
    country = json['country'];
    city = json['city'];
    profileImage = json['image'];
    gender = json['gender'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (sId != null) data['id'] = sId;
    data['name'] = name;
    data['dob'] = dob;
    if (partnerName != null) data['partner'] = partnerName;
    data['country'] = country;
    data['city'] = city;
    if (profileImage != null) data['image'] = profileImage;
    if (gender != null) data['gender'] = gender;
    // ip_address is usually sent in body, ensuring it's available if needed in json
    if (ipAddress != null) data['ip_address'] = ipAddress;
    return data;
  }
}
