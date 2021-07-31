final String tableAccount = 'account';

class AccountFields {
  static final List<String> values = [id, description, value, date];
  static final String id = '_id';
  static final String description = 'description';
  static final String value = 'value';
  static final String date = 'date';
}

class Account {
  final int? id;
  final String description;
  final double value;
  final DateTime date;

  const Account(
      {this.id,
      required this.description,
      required this.value,
      required this.date});

  Account copy({int? id, String? description, double? value, DateTime? date}) =>
      Account(
          id: id ?? this.id,
          description: description ?? this.description,
          value: value ?? this.value,
          date: date ?? this.date);

  static Account fromJson(Map<String, Object?> json) => Account(
      id: json[AccountFields.id] as int?,
      description: json[AccountFields.description] as String,
      value: json[AccountFields.value] as double,
      date: DateTime.parse(json[AccountFields.date] as String));

  Map<String, Object?> toJson() => {
        AccountFields.id: id,
        AccountFields.description: description,
        AccountFields.value: value,
        AccountFields.date: date.toIso8601String(),
      };
}
