class DropdownModel {
  final String title;
  final String icon;

  DropdownModel(this.title, this.icon);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is DropdownModel &&
              runtimeType == other.runtimeType &&
              title == other.title;

  @override
  int get hashCode => title.hashCode;
}
