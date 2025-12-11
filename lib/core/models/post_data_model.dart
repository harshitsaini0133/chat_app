class Data {
  String? sId;
  String? category;
  Subcategory? subcategory;
  String? title;
  String? description;
  String? image;
  int? views;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? iV;
  int? totalComments;
  double? reating;

  Data({
    this.sId,
    this.category,
    this.subcategory,
    this.title,
    this.description,
    this.image,
    this.views,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.totalComments,
    this.reating,
  });

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    category = json['category'];
    subcategory = json['subcategory'] != null
        ? Subcategory.fromJson(json['subcategory'])
        : null;
    title = json['title'];
    description = json['description'];
    image = json['image'];
    views = json['views'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    totalComments = json['totalComments'];
    reating = (json['reating'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['category'] = category;
    if (subcategory != null) {
      data['subcategory'] = subcategory!.toJson();
    }
    data['title'] = title;
    data['description'] = description;
    data['image'] = image;
    data['views'] = views;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['totalComments'] = totalComments;
    data['reating'] = reating;
    return data;
  }
}

class Subcategory {
  String? sId;
  String? subcategory;

  Subcategory({this.sId, this.subcategory});

  Subcategory.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    subcategory = json['subcategory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['subcategory'] = subcategory;
    return data;
  }
}

class Pagination {
  int? totalPosts;
  int? currentPage;
  int? totalPages;

  Pagination({this.totalPosts, this.currentPage, this.totalPages});

  Pagination.fromJson(Map<String, dynamic> json) {
    totalPosts = json['totalPosts'];
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalPosts'] = totalPosts;
    data['currentPage'] = currentPage;
    data['totalPages'] = totalPages;
    return data;
  }
}
