import 'dart:convert';

class CalculationHistory {
  final String id;
  final String expression;
  final String result;
  final DateTime timestamp;
  String? label; // e.g. "Milk & Bread", "Shop Bill"
  String? category;

  CalculationHistory({
    required this.id,
    required this.expression,
    required this.result,
    required this.timestamp,
    this.label,
    this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'expression': expression,
      'result': result,
      'timestamp': timestamp.toIso8601String(),
      'label': label,
      'category': category,
    };
  }

  factory CalculationHistory.fromMap(Map<String, dynamic> map) {
    return CalculationHistory(
      id: map['id'] ?? '',
      expression: map['expression'] ?? '',
      result: map['result'] ?? '',
      timestamp: DateTime.parse(map['timestamp']),
      label: map['label'],
      category: map['category'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CalculationHistory.fromJson(String source) =>
      CalculationHistory.fromMap(json.decode(source));
}
