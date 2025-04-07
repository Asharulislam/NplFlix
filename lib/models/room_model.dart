import 'dart:convert';



class RoomModel {
  final String roomName;
  final String uuid;
  final String roomStart;
  final String roomEnd;
  final String roomUUID;
  final String roomURL;
  final List<Participant> participants;

  RoomModel({
    required this.roomName,
    required this.uuid,
    required this.roomStart,
    required this.roomEnd,
    required this.roomUUID,
    required this.roomURL,
    required this.participants,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) => RoomModel(
    roomName: json["roomName"],
    uuid: json["uuid"],
    roomStart: json["roomStart"],
    roomEnd: json["roomEnd"],
    roomUUID: json["roomUUID"],
    roomURL: json["roomURL"],
    participants: List<Participant>.from(json["participants"].map((x) => Participant.fromMap(x))),
  );
}

class Participant {
  final String userUUID;
  final bool isOwner;
  final String joinAs;
  final RoomMemberStatus roomMemberStatus;
  final dynamic blockReason;
  final dynamic email;

  Participant({
    required this.userUUID,
    required this.isOwner,
    required this.joinAs,
    required this.roomMemberStatus,
    this.blockReason,
    this.email,
  });

  factory Participant.fromMap(Map<String, dynamic> json) => Participant(
    userUUID: json["userUUID"],
    isOwner: json["isOwner"],
    joinAs: json["joinAs"],
    roomMemberStatus: RoomMemberStatus.fromJson(json["roomMemberStatus"]),
    blockReason: json["blockReason"],
    email:  json['email']
  );
}

class RoomMemberStatus {
  final int roomMemberStatusId;
  final String roomMemberStatusI;

  RoomMemberStatus({
    required this.roomMemberStatusId,
    required this.roomMemberStatusI,
  });

  factory RoomMemberStatus.fromJson(Map<String, dynamic> json) => RoomMemberStatus(
    roomMemberStatusId: json["roomMemberStatusId"],
    roomMemberStatusI: json["roomMemberStatusI"],
  );
}
