import 'package:cloud_firestore/cloud_firestore.dart';

class Spending {
  String? id;
  int money;
  int type;
  String? note;
  DateTime dateTime;
  String? image;

  Spending({
    this.id,
    required this.money,
    required this.type,
    required this.dateTime,
    this.note,
    this.image,
  });

  Map<String, dynamic> toMap() => {
        "money": money,
        "type": type,
        "note": note,
        "date": dateTime,
        "image": image
      };

  factory Spending.fromFirebase(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return Spending(
      id: snapshot.id,
      money: data["money"],
      type: data["type"],
      dateTime: (data["date"] as Timestamp).toDate(),
      note: data["note"],
      image: data["image"],
    );
  }
}
