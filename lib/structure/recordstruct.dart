class RecordStatus {
  int? uploaded;

  RecordStatus({this.uploaded});

  RecordStatus.fromJson(Map<String, dynamic> json) {
    uploaded = json['uploaded'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uploaded'] = this.uploaded;
    return data;
  }
}