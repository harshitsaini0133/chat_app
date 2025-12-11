class CommentModel {
  String? id;
  CommentUser? user;
  String? post;
  String? comment;
  String? status;
  String? createdAt;

  CommentModel({
    this.id,
    this.user,
    this.post,
    this.comment,
    this.status,
    this.createdAt,
  });

  CommentModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    if (json['user'] is String) {
      user = CommentUser(id: json['user']);
    } else if (json['user'] != null) {
      user = CommentUser.fromJson(json['user']);
    } else {
      user = null;
    }
    post = json['post'];
    comment = json['comment'];
    status = json['status'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['post'] = post;
    data['comment'] = comment;
    data['status'] = status;
    data['createdAt'] = createdAt;
    return data;
  }
}

class CommentUser {
  String? id;
  String? name;
  String? image;

  CommentUser({this.id, this.name, this.image});

  CommentUser.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['image'] = image;
    return data;
  }
}
