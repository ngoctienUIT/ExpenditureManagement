class Filter {
  List<int> chooseIndex;
  int money;
  int finishMoney;
  DateTime? time;
  DateTime? finishTime;
  String note;

  Filter({
    required this.chooseIndex,
    this.money = 0,
    this.finishMoney = 0,
    this.time,
    this.finishTime,
    this.note = "",
  });

  Map<String, dynamic> toMap() {
    return {
      "choose": chooseIndex,
      "money": money,
      "finishmoney": finishMoney,
      "time": time,
      "finishTime": finishTime,
      "note": note
    };
  }

  Filter copyWith({
    List<int>? chooseIndex,
    int? money,
    int? finishMoney,
    DateTime? time,
    DateTime? finishTime,
    String? note,
  }) {
    return Filter(
      chooseIndex: chooseIndex ?? List.from(this.chooseIndex),
      money: money ?? this.money,
      finishMoney: finishMoney ?? this.finishMoney,
      time: time ?? this.time,
      finishTime: finishTime ?? this.finishTime,
      note: note ?? this.note,
    );
  }
}
