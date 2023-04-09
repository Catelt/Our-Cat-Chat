class XLanguage {
  final String name;
  final String code;
  final String icon;

  XLanguage({
    required this.name,
    required this.code,
    required this.icon,
  });

  factory XLanguage.empty() => XLanguage(name: '', code: '', icon: '');
}
