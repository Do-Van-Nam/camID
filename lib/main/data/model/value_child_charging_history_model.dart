class ValueChildChargingHistoryModel {
  String? subType;
  String? title;
  String? time;
  double? amount;
  int? duration;

  ValueChildChargingHistoryModel({
    this.subType,
    this.title,
    this.time,
    this.amount,
    this.duration,
  });

  factory ValueChildChargingHistoryModel.fromJson(Map<String, dynamic> json) {
    return ValueChildChargingHistoryModel(
      subType: json['subType']?.toString(),
      title: json['title']?.toString(),
      time: json['time']?.toString(),
      amount: (json['amount'] != null)
          ? (json['amount'] as num).toDouble()
          : null,
      duration: json['duration'] as int?,
    );
  }
}
