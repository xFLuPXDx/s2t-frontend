class PeoplesInGroup {
  EducatorIds? educatorIds;
  EducatorIds? learnerIds;

  PeoplesInGroup({this.educatorIds, this.learnerIds});

  PeoplesInGroup.fromJson(Map<String, dynamic> json) {
    educatorIds = json['educator_Ids'] != null
        ? new EducatorIds.fromJson(json['educator_Ids'])
        : null;
    learnerIds = json['learner_Ids'] != null
        ? new EducatorIds.fromJson(json['learner_Ids'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.educatorIds != null) {
      data['educator_Ids'] = this.educatorIds!.toJson();
    }
    if (this.learnerIds != null) {
      data['learner_Ids'] = this.learnerIds!.toJson();
    }
    return data;
  }
}

class EducatorIds {
  int? count;
  List<Result>? result;

  EducatorIds({this.count, this.result});

  EducatorIds.fromJson(Map<String, dynamic> json) {
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
  String? userId;
  String? userFname;
  String? userLname;

  Result({this.userId, this.userFname, this.userLname});

  Result.fromJson(Map<String, dynamic> json) {
    userId = json['user_Id'];
    userFname = json['user_Fname'];
    userLname = json['user_Lname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_Id'] = this.userId;
    data['user_Fname'] = this.userFname;
    data['user_Lname'] = this.userLname;
    return data;
  }
}