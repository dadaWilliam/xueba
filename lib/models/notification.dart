class NotificationList {
  int? count;
  String? next;
  String? previous;
  List<Results>? results;

  NotificationList({this.count, this.next, this.previous, this.results});

  NotificationList.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(new Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  int? id;
  List<VideoNotification>? video;
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
      video = <VideoNotification>[];
      json['video'].forEach((v) {
        video!.add(new VideoNotification.fromJson(v));
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.video != null) {
      data['video'] = this.video!.map((v) => v.toJson()).toList();
    }
    data['level'] = this.level;
    data['unread'] = this.unread;
    data['actor_object_id'] = this.actorObjectId;
    data['verb'] = this.verb;
    data['description'] = this.description;
    data['target_object_id'] = this.targetObjectId;
    data['action_object_object_id'] = this.actionObjectObjectId;
    data['timestamp'] = this.timestamp;
    data['public'] = this.public;
    data['deleted'] = this.deleted;
    data['emailed'] = this.emailed;
    data['data'] = this.data;
    data['recipient'] = this.recipient;
    data['actor_content_type'] = this.actorContentType;
    data['target_content_type'] = this.targetContentType;
    data['action_object_content_type'] = this.actionObjectContentType;
    return data;
  }
}

class VideoNotification {
  String? url;
  Classification? classification;
  String? title;
  String? desc;
  String? file;
  String? cover;
  int? viewCount;
  String? createTime;
  List<String>? liked;
  List<String>? collected;

  VideoNotification(
      {this.url,
      this.classification,
      this.title,
      this.desc,
      this.file,
      this.cover,
      this.viewCount,
      this.createTime,
      this.liked,
      this.collected});

  VideoNotification.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    classification = json['classification'] != null
        ? new Classification.fromJson(json['classification'])
        : null;
    title = json['title'];
    desc = json['desc'];
    file = json['file'];
    cover = json['cover'];
    viewCount = json['view_count'];
    createTime = json['create_time'];
    liked = json['liked'].cast<String>();
    collected = json['collected'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    if (this.classification != null) {
      data['classification'] = this.classification!.toJson();
    }
    data['title'] = this.title;
    data['desc'] = this.desc;
    data['file'] = this.file;
    data['cover'] = this.cover;
    data['view_count'] = this.viewCount;
    data['create_time'] = this.createTime;
    data['liked'] = this.liked;
    data['collected'] = this.collected;
    return data;
  }
}

class Classification {
  String? url;
  String? title;
  String? time;

  Classification({this.url, this.title, this.time});

  Classification.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    title = json['title'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['title'] = this.title;
    data['time'] = this.time;
    return data;
  }
}
