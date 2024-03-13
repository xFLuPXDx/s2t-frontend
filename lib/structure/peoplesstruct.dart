class Learners {
  int? count;
  List<Result>? result;

  Learners({this.count, this.result});

  Learners.fromJson(Map<String, dynamic> json) {
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

class Educators {
  int? count;
  List<Result>? result;

  Educators({this.count, this.result});

  Educators.fromJson(Map<String, dynamic> json) {
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
  String? userFname;
  String? userLname;

  Result({this.userFname, this.userLname});

  Result.fromJson(Map<String, dynamic> json) {
    userFname = json['user_Fname'];
    userLname = json['user_Lname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_Fname'] = this.userFname;
    data['user_Lname'] = this.userLname;
    return data;
  }
}