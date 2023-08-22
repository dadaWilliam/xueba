class NoticeList {
  int? count;
  String? next;
  String? previous;
  List<Results>? results;

  NoticeList({this.count, this.next, this.previous, this.results});

  NoticeList.fromJson(Map<String, dynamic> json) {
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
  List<Video_Notice>? video;
  String? level;
  bool? unread;
  String? actorObjectId;
  String? verb;
  String? description;
  String? targetObjectId;
  String? actionObjectObjectId;
  String? timestamp;
  bool? public;
  bool? deleted;
  bool? emailed;
  String? data;
  int? recipient;
  int? actorContentType;
  int? targetContentType;
  String? actionObjectContentType;

  Results(
      {this.id,
      this.video,
      this.level,
      this.unread,
      this.actorObjectId,
      this.verb,
      this.description,
      this.targetObjectId,
      this.actionObjectObjectId,
      this.timestamp,
      this.public,
      this.deleted,
      this.emailed,
      this.data,
      this.recipient,
      this.actorContentType,
      this.targetContentType,
      this.actionObjectContentType});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['video'] != null) {
      video = <Video_Notice>[];
      json['video'].forEach((v) {
        video!.add(Video_Notice.fromJson(v));
      });
    }
    level = json['level'];
    unread = json['unread'];
    actorObjectId = json['actor_object_id'];
    verb = json['verb'];

    description = json['description'];
    targetObjectId = json['target_object_id'];
    actionObjectObjectId = json['action_object_object_id'];
    timestamp = json['timestamp'];
    public = json['public'];
    deleted = json['deleted'];
    emailed = json['emailed'];
    data = json['data'];
    recipient = json['recipient'];
    actorContentType = json['actor_content_type'];
    targetContentType = json['target_content_type'];
    actionObjectContentType = json['action_object_content_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (video != null) {
      data['video'] = video!.map((v) => v.toJson()).toList();
    }
    data['level'] = level;
    data['unread'] = unread;
    data['actor_object_id'] = actorObjectId;
    data['verb'] = verb;
    data['description'] = description;
    data['target_object_id'] = targetObjectId;
    data['action_object_object_id'] = actionObjectObjectId;
    data['timestamp'] = timestamp;
    data['public'] = public;
    data['deleted'] = deleted;
    data['emailed'] = emailed;
    data['data'] = this.data;
    data['recipient'] = recipient;
    data['actor_content_type'] = actorContentType;
    data['target_content_type'] = targetContentType;
    data['action_object_content_type'] = actionObjectContentType;
    return data;
  }
}

class Video_Notice {
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

  Video_Notice(
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

  Video_Notice.fromJson(Map<String, dynamic> json) {
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
