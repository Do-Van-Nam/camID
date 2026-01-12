class AccountOcsValue {
  String? title;
  String? value;
  String? exp;

  AccountOcsValue();

  factory AccountOcsValue.fromJson(Map<String, dynamic> json) {
    final model = AccountOcsValue();
    model.title = json['title'] ?? '';
    model.value = json['value'] ?? '';
    model.exp = json['exp'] ?? '';
    return model;
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'value': value,
    'exp': exp,
  };
}