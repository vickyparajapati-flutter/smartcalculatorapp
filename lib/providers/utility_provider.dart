import 'package:flutter/foundation.dart';
import '../core/utils/haptic_service.dart';

enum BmiUnitSystem { metric, imperial }

class BmiResult {
  final double bmi;
  final String category;
  final String tip;
  final double idealMinWeight;
  final double idealMaxWeight;

  BmiResult({
    required this.bmi,
    required this.category,
    required this.tip,
    required this.idealMinWeight,
    required this.idealMaxWeight,
  });
}

class AgeResult {
  final int years;
  final int months;
  final int days;
  final int totalMonths;
  final int totalDays;
  final int nextBirthdayDays;
  final String nextBirthdayDayOfWeek;

  AgeResult({
    required this.years,
    required this.months,
    required this.days,
    required this.totalMonths,
    required this.totalDays,
    required this.nextBirthdayDays,
    required this.nextBirthdayDayOfWeek,
  });
}

class UtilityProvider extends ChangeNotifier {
  // ==================== BMI ====================
  double _weightKg = 68.0;
  double _heightCm = 175.0;

  double get weightKg => _weightKg;
  double get heightCm => _heightCm;

  BmiResult get bmiResult {
    double heightM = _heightCm / 100;
    if (heightM <= 0) {
      return BmiResult(
        bmi: 0,
        category: 'Invalid',
        tip: 'Please enter valid values.',
        idealMinWeight: 0,
        idealMaxWeight: 0,
      );
    }

    double bmi = _weightKg / (heightM * heightM);
    String category;
    String tip;

    if (bmi < 18.5) {
      category = 'Underweight';
      tip = 'You may need to eat a more nutrient-dense diet to reach a healthy weight.';
    } else if (bmi < 25.0) {
      category = 'Normal / Healthy';
      tip = 'Awesome! Maintain your current balanced lifestyle, diet, and regular exercise.';
    } else if (bmi < 30.0) {
      category = 'Overweight';
      tip = 'Consider adopting regular cardiovascular activity and mindful portion sizes.';
    } else {
      category = 'Obese';
      tip = 'We recommend consulting a healthcare professional for a tailored fitness plan.';
    }

    double idealMin = 18.5 * (heightM * heightM);
    double idealMax = 24.9 * (heightM * heightM);

    return BmiResult(
      bmi: bmi,
      category: category,
      tip: tip,
      idealMinWeight: idealMin,
      idealMaxWeight: idealMax,
    );
  }

  void updateWeight(double weight) {
    _weightKg = weight;
    notifyListeners();
  }

  void updateHeight(double height) {
    _heightCm = height;
    notifyListeners();
  }

  // ==================== AGE CALCULATOR ====================
  DateTime _birthDate = DateTime(2000, 1, 1);

  DateTime get birthDate => _birthDate;

  void updateBirthDate(DateTime date) {
    HapticService.selectionClick();
    _birthDate = date;
    notifyListeners();
  }

  AgeResult get ageResult {
    final now = DateTime.now();
    int years = now.year - _birthDate.year;
    int months = now.month - _birthDate.month;
    int days = now.day - _birthDate.day;

    if (days < 0) {
      months -= 1;
      final prevMonth = DateTime(now.year, now.month, 0);
      days += prevMonth.day;
    }

    if (months < 0) {
      years -= 1;
      months += 12;
    }

    int totalMonths = (years * 12) + months;
    int totalDays = now.difference(_birthDate).inDays;

    // Next birthday calculation
    final today = DateTime(now.year, now.month, now.day);
    DateTime nextBday = DateTime(now.year, _birthDate.month, _birthDate.day);
    if (nextBday.isBefore(today)) {
      nextBday = DateTime(now.year + 1, _birthDate.month, _birthDate.day);
    }
    int daysUntilNextBday = nextBday.difference(today).inDays;

    final weekDays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    String nextDayName = weekDays[nextBday.weekday - 1];

    return AgeResult(
      years: years >= 0 ? years : 0,
      months: months >= 0 ? months : 0,
      days: days >= 0 ? days : 0,
      totalMonths: totalMonths >= 0 ? totalMonths : 0,
      totalDays: totalDays >= 0 ? totalDays : 0,
      nextBirthdayDays: daysUntilNextBday,
      nextBirthdayDayOfWeek: nextDayName,
    );
  }

  // ==================== UNIT CONVERTER ====================
  String _selectedUnitCategory = 'Length';
  String _fromUnit = 'Meter';
  String _toUnit = 'Foot';
  double _inputValue = 1.0;

  String get selectedUnitCategory => _selectedUnitCategory;
  String get fromUnit => _fromUnit;
  String get toUnit => _toUnit;
  double get inputValue => _inputValue;

  final Map<String, Map<String, double>> _conversionRatesToStandard = {
    'Length': {
      // Standard: Meter
      'Meter': 1.0,
      'Kilometer': 1000.0,
      'Centimeter': 0.01,
      'Millimeter': 0.001,
      'Mile': 1609.344,
      'Yard': 0.9144,
      'Foot': 0.3048,
      'Inch': 0.0254,
    },
    'Weight': {
      // Standard: Kilogram
      'Kilogram': 1.0,
      'Gram': 0.001,
      'Milligram': 0.000001,
      'Pound (lbs)': 0.45359237,
      'Ounce (oz)': 0.0283495,
      'Tonne': 1000.0,
    },
    'Digital Storage': {
      // Standard: Megabyte
      'Byte': 0.0000009536743,
      'Kilobyte': 0.0009765625,
      'Megabyte': 1.0,
      'Gigabyte': 1024.0,
      'Terabyte': 1048576.0,
    },
    'Speed': {
      // Standard: m/s
      'Meter/second': 1.0,
      'Kilometer/hour': 0.277778,
      'Miles/hour': 0.44704,
      'Knot': 0.514444,
    },
  };

  List<String> get availableCategories => [
        'Length',
        'Weight',
        'Digital Storage',
        'Speed',
        'Temperature',
      ];

  List<String> get availableUnits {
    if (_selectedUnitCategory == 'Temperature') {
      return ['Celsius', 'Fahrenheit', 'Kelvin'];
    }
    return _conversionRatesToStandard[_selectedUnitCategory]?.keys.toList() ?? [];
  }

  void setCategory(String category) {
    _selectedUnitCategory = category;
    final units = availableUnits;
    if (units.isNotEmpty) {
      _fromUnit = units.first;
      _toUnit = units.length > 1 ? units[1] : units.first;
    }
    notifyListeners();
  }

  void setFromUnit(String unit) {
    _fromUnit = unit;
    notifyListeners();
  }

  void setToUnit(String unit) {
    _toUnit = unit;
    notifyListeners();
  }

  void setInputValue(double value) {
    _inputValue = value;
    notifyListeners();
  }

  void swapUnits() {
    HapticService.lightClick();
    final temp = _fromUnit;
    _fromUnit = _toUnit;
    _toUnit = temp;
    notifyListeners();
  }

  double get convertedValue {
    if (_selectedUnitCategory == 'Temperature') {
      return _convertTemperature(_inputValue, _fromUnit, _toUnit);
    }

    final categoryMap = _conversionRatesToStandard[_selectedUnitCategory];
    if (categoryMap == null) return 0.0;

    double fromRate = categoryMap[_fromUnit] ?? 1.0;
    double toRate = categoryMap[_toUnit] ?? 1.0;

    // Convert from source to standard, then standard to target
    double standardValue = _inputValue * fromRate;
    return standardValue / toRate;
  }

  double _convertTemperature(double val, String from, String to) {
    if (from == to) return val;
    // Normalize to Celsius first
    double c;
    if (from == 'Celsius') {
      c = val;
    } else if (from == 'Fahrenheit') {
      c = (val - 32) * 5 / 9;
    } else {
      c = val - 273.15;
    }

    // Convert from Celsius to target
    if (to == 'Celsius') return c;
    if (to == 'Fahrenheit') return (c * 9 / 5) + 32;
    return c + 273.15;
  }
}
