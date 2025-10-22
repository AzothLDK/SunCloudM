class WorkEntity {
  // 可根据实际需求添加属性
  String? name;
  int? id;
  String? workNumber;
  String? workName;
  String? deviceName;
  String? workSourceName;
  String? stationName;
  String? createTime;
  int? planTime;
  String? personnel;
  String? personnelName;
  int? priority;
  int? status;
  int? isOvertime;
  int? isTake;
  int? workSource;
  String? projectTypeName;
  String? stationAddress;
  String? stationResponsible;
  String? stationResponsiblePhone;
  String? remark;
  String? teamName;
  int? createId;
  String? createName;
  int? groupId;
  String? groupName;
  String? alarmName;
  String? alarmId;
  String? alarmContent;
  String? reason;
  String? programme;
  int? isSpare;
  int? input;
  dynamic picture;
  List? pictureUrl;
  String? inputDetails;
  int? inputDetailsNumber;
  String? actualEndTime;
  String? actualStartTime;

  WorkEntity(
      {this.name,
      this.id,
      this.workNumber,
      this.workName,
      this.deviceName,
      this.workSourceName,
      this.stationName,
      this.createTime,
      this.planTime,
      this.personnel,
      this.personnelName,
      this.priority,
      this.status,
      this.isOvertime,
      this.isTake,
      this.workSource,
      this.projectTypeName,
      this.stationAddress,
      this.stationResponsible,
      this.stationResponsiblePhone,
      this.teamName,
      this.remark,
      this.createId,
      this.createName,
      this.groupId,
      this.groupName,
      this.alarmName,
      this.alarmId,
      this.alarmContent,
      this.reason,
      this.programme,
      this.isSpare,
      this.input,
      this.picture,
      this.pictureUrl,
      this.inputDetails,
      this.inputDetailsNumber,
      this.actualEndTime,
      this.actualStartTime});

  factory WorkEntity.fromJson(Map<String, dynamic> json) {
    return WorkEntity(
      name: json['name'],
      id: json['id'],
      workNumber: json['workNumber'],
      workName: json['workName'],
      deviceName: json['deviceName'],
      workSourceName: json['workSourceName'],
      stationName: json['stationName'],
      createTime: json['createTime'],
      planTime: json['planTime'],
      personnel: json['personnel'],
      personnelName: json['personnelName'],
      priority: json['priority'],
      status: json['status'],
      isOvertime: json['isOvertime'],
      isTake: json['isTake'],
      workSource: json['workSource'],
      projectTypeName: json['projectTypeName'],
      stationAddress: json['stationAddress'],
      stationResponsible: json['stationResponsible'],
      stationResponsiblePhone: json['stationResponsiblePhone'],
      remark: json['remark'],
      teamName: json['teamName'],
      createId: json['createId'],
      createName: json['createName'],
      groupId: json['groupId'],
      groupName: json['groupName'],
      alarmName: json['alarmName'],
      alarmId: json['alarmId'],
      alarmContent: json['alarmContent'],
      reason: json['reason'],
      programme: json['programme'],
      isSpare: json['isSpare'],
      input: json['input'],
      picture: json['picture'],
      pictureUrl: json['pictureUrl'],
      inputDetails: json['inputDetails'],
      inputDetailsNumber: json['inputDetailsNumber'],
      actualEndTime: json['actualEndTime'],
      actualStartTime: json['actualStartTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'workNumber': workNumber,
      'workName': workName,
      'stationName': stationName,
      'deviceName': deviceName,
      'workSourceName': workSourceName,
      'createTime': createTime,
      'planTime': planTime,
      'personnel': personnel,
      'personnelName': personnelName,
      'priority': priority,
      'status': status,
      'isOvertime': isOvertime,
      'isTake': isTake,
      'workSource': workSource,
      'projectTypeName': projectTypeName,
      'stationAddress': stationAddress,
      'stationResponsible': stationResponsible,
      'stationResponsiblePhone': stationResponsiblePhone,
      'remark': remark,
      'teamName': teamName,
      'createId': createId,
      'createName': createName,
      'groupId': groupId,
      'groupName': groupName,
      'alarmName': alarmName,
      'alarmId': alarmId,
      'alarmContent': alarmContent,
      'reason': reason,
      'programme': programme,
      'isSpare': isSpare,
      'input': input,
      'picture': picture,
      'pictureUrl': pictureUrl,
      'inputDetails': inputDetails,
      'inputDetailsNumber': inputDetailsNumber,
      'actualEndTime': actualEndTime,
      'actualStartTime': actualStartTime,
    };
  }
}
