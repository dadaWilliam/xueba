// ignore_for_file: camel_case_types

class classification {
  int? count;
  String? next;
  String? previous;
  List<Results>? results;

  classification({this.count, this.next, this.previous, this.results});

  classification.fromJson(Map<String, dynamic> json) {
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
  String? title;
  bool? status;
  String? time;

  Results({this.url, this.title, this.status, this.time});

  Results.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    title = json['title'];
    status = json['status'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['title'] = title;
    data['status'] = status;
    data['time'] = time;
    return data;
  }
}
