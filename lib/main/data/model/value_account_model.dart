class Value {
  String? title;
  String? value;
  String? exp;

  Value();

  factory Value.fromJson(Map<String, dynamic> json) {
    final model = Value();
    model.title = json['title'] ?? '';
    model.value = json['value'] ?? '';
    model.exp = json['exp'] ?? '';
    return model;
  }
}