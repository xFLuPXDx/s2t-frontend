class ResourcesList {
  int? count;
  List<Result>? result;

  ResourcesList({this.count, this.result});

  ResourcesList.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String? rid;
  String? timeStamp;
  String? summarizedText;
  List<String>? topicsCovered;
  List<String>? resourceLinks;

  Result(
      {this.rid,
        this.timeStamp,
      this.summarizedText,
      this.topicsCovered,
      this.resourceLinks});

  Result.fromJson(Map<String, dynamic> json) {
    rid = json['resource_Id'];
    timeStamp = json['time_Stamp'];
    summarizedText = json['summarized_Text'];
    topicsCovered = json['topics_Covered'].cast<String>();
    resourceLinks = json['resource_links'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['resource_Id'] = this.rid;
    data['time_Stamp'] = this.timeStamp;
    data['summarized_Text'] = this.summarizedText;
    data['topics_Covered'] = this.topicsCovered;
    data['resource_links'] = this.resourceLinks;
    return data;
  }
}