class Groups {
  int? count;
  List<Result>? result;

  Groups({this.count, this.result});

  Groups.fromJson(Map<String, dynamic> json) {
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
  String? groupId;
  String? groupName;
  String? groupSubject;

  Result({this.groupId, this.groupName, this.groupSubject});

  Result.fromJson(Map<String, dynamic> json) {
    groupId = json['group_Id'];
    groupName = json['group_Name'];
    groupSubject = json['group_Subject'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['group_Id'] = this.groupId;
    data['group_Name'] = this.groupName;
    data['group_Subject'] = this.groupSubject;
    return data;
  }
}

