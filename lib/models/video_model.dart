class Video {
  int? count;
  String? next;
  String? previous;
  List<Results>? results;

  Video({this.count, this.next, this.previous, this.results});

  Video.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['next'] = next;
    data['previous'] = previous;
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  String? url;
  Classification? classification;
  String? title;
  String? desc;
  String? file;
  String? cover;
  String? status;
  int? viewCount;
  String? createTime;
  List<String>? liked;
  List<String>? collected;

  Results(
      {this.url,
      this.classification,
      this.title,
      this.desc,
      this.file,
      this.cover,
      this.status,
      this.viewCount,
      this.createTime,
      this.liked,
      this.collected});

  Results.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    classification = json['classification'] != null
        ? Classification.fromJson(json['classification'])
        : null;
    title = json['title'];
    desc = json['desc'];
    file = json['file'];
    cover = json['cover'];
    status = json['status'];
    viewCount = json['view_count'];
    createTime = json['create_time'];
    liked = json['liked'].cast<String>();
    collected = json['collected'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    if (classification != null) {
      data['classification'] = classification!.toJson();
    }
    data['title'] = title;
    data['desc'] = desc;
    data['file'] = file;
    data['cover'] = cover;
    data['status'] = status;
    data['view_count'] = viewCount;
    data['create_time'] = createTime;
    data['liked'] = liked;
    data['collected'] = collected;
    return data;
  }
}

class Classification {
  int? id;
  String? url;
  String? title;
  bool? status;
  String? time;

  Classification({this.id, this.url, this.title, this.status, this.time});

  Classification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    title = json['title'];
    status = json['status'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['url'] = url;
    data['title'] = title;
    data['status'] = status;
    data['time'] = time;
    return data;
  }
}
