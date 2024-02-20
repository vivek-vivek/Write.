//     final noteModel = noteModelFromJson(jsonString);

import 'dart:convert';

List<NoteModel> noteModelFromJson(String str) {
  final Iterable<dynamic> jsonList = json.decode(str);
  return List<NoteModel>.from(jsonList.map((x) => NoteModel.fromJson(x)));
}

String noteModelToJson(List<NoteModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NoteModel {
  dynamic? id;
  String? note;
  String? mood;
  String? updatedAt;
  String? subMood;

  NoteModel({
    this.id,
    this.note,
    this.mood,
    this.updatedAt,
    this.subMood,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) => NoteModel(
        id: json["id"],
        note: json["note"],
        mood: json["mood"],
        updatedAt: json["updatedAt"],
        subMood: json["subMood"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "note": note,
        "mood": mood,
        "updatedAt": updatedAt,
        "subMood": subMood,
      };
}
