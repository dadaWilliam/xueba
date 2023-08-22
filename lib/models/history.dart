class HistoryList {
  int? count;
  String? next;
  String? previous;
  List<Results>? results;

  HistoryList({this.count, this.next, this.previous, this.results});

  HistoryList.fromJson(Map<String, dynamic> json) {
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
  int? id;
  List<Video_History>? video;
  int? objectId;
  String? url;
  String? viewedOn;
  String? user;
  int? contentType;

  Results(
      {this.id,
      this.video,
      this.objectId,
      this.url,
      this.viewedOn,
      this.user,
      this.contentType});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['video'] != null && json['video'].toString().isNotEmpty) {
      // debugPrint(json['video'].toString());
      video = <Video_History>[];
      json['video'].forEach((v) {
        video!.add(Video_History.fromJson(v));
      });
    }
    objectId = json['object_id'];
    viewedOn = json['viewed_on'];
    url = json['url'];
    user = json['user'];
    contentType = json['content_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (video != null) {
      data['video'] =
          List<Video_History>.from(video!.map((v) => v.toJson())).toList();
    }
    data['object_id'] = objectId;
    data['viewed_on'] = viewedOn;
    data['url'] = url;
    data['user'] = user;
    data['content_type'] = contentType;
    return data;
  }
}

class Video_History {
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

  Video_History(
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

  Video_History.fromJson(Map<String, dynamic> json) {
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
