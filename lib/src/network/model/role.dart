enum MRole {
  user,
  model;

  bool get isUser => this == user;
  bool get isModel => this == model;

  static MRole fromJson(String value) {
    return values.firstWhere((e) => e.name == value, orElse: () => user);
  }
}
