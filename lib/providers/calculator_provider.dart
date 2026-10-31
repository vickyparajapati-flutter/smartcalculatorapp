import 'package:flutter/foundation.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import '../models/calculation_history.dart';
import '../core/utils/haptic_service.dart';

class CalculatorProvider extends ChangeNotifier {
  static const String _historyStorageKey = 'calc_history_data';

  String _expression = '';
  String _liveResult = '';
  bool _isScientificExpanded = false;
  final List<CalculationHistory> _history = [];

  String get expression => _expression.isEmpty ? '0' : _expression;
  String get rawExpression => _expression;
  String get liveResult => _liveResult;
  bool get isScientificExpanded => _isScientificExpanded;
  List<CalculationHistory> get history => List.unmodifiable(_history);

  CalculatorProvider() {
    _loadHistory();
  }

  void toggleScientific() {
    HapticService.selectionClick();
    _isScientificExpanded = !_isScientificExpanded;
    notifyListeners();
  }

  Future<void> _loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? storedHistory = prefs.getStringList(_historyStorageKey);
      if (storedHistory != null) {
        _history.clear();
        for (var item in storedHistory) {
          _history.add(CalculationHistory.fromJson(item));
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading history: $e');
    }
  }

  Future<void> _saveHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> encoded = _history.map((e) => e.toJson()).toList();
      await prefs.setStringList(_historyStorageKey, encoded);
    } catch (e) {
      debugPrint('Error saving history: $e');
    }
  }

  void append(String value) {
    HapticService.lightClick();

    // Prevent consecutive invalid operators
    if (_isOperator(value)) {
      if (_expression.isEmpty) {
        if (value == '-') {
          _expression = '-';
          notifyListeners();
          return;
        }
        return;
      }
      final lastChar = _expression[_expression.length - 1];
      if (_isOperator(lastChar)) {
        // Replace last operator with the new one
        _expression = _expression.substring(0, _expression.length - 1) + value;
        _evaluateLive();
        notifyListeners();
        return;
      }
    }

    // Prevent multiple decimals in the same number
    if (value == '.') {
      final parts = _expression.split(RegExp(r'[+\-×÷%^]'));
      if (parts.isNotEmpty && parts.last.contains('.')) {
        return;
      }
      if (_expression.isEmpty || _isOperator(_expression[_expression.length - 1])) {
        _expression += '0.';
        _evaluateLive();
        notifyListeners();
        return;
      }
    }

    _expression += value;
    _evaluateLive();
    notifyListeners();
  }

  void appendScientificFunction(String func) {
    HapticService.lightClick();
    _expression += func;
    _evaluateLive();
    notifyListeners();
  }

  void delete() {
    HapticService.lightClick();
    if (_expression.isNotEmpty) {
      _expression = _expression.substring(0, _expression.length - 1);
      _evaluateLive();
      notifyListeners();
    }
  }

  void clear() {
    HapticService.mediumClick();
    _expression = '';
    _liveResult = '';
    notifyListeners();
  }

  void equals() {
    if (_expression.isEmpty) return;
    HapticService.mediumClick();

    try {
      final cleanResult = _calculateResult(_expression);
      if (cleanResult != null && cleanResult != 'Error') {
        final historyItem = CalculationHistory(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          expression: _expression,
          result: cleanResult,
          timestamp: DateTime.now(),
        );

        _history.insert(0, historyItem);
        _saveHistory();

        _expression = cleanResult;
        _liveResult = '';
        notifyListeners();
      }
    } catch (_) {
      _liveResult = 'Error';
      notifyListeners();
    }
  }

  void reuseCalculation(CalculationHistory item) {
    HapticService.selectionClick();
    _expression = item.result;
    _liveResult = '';
    notifyListeners();
  }

  void updateHistoryLabel(String id, String label) {
    final index = _history.indexWhere((e) => e.id == id);
    if (index != -1) {
      _history[index].label = label.trim().isEmpty ? null : label.trim();
      _saveHistory();
      notifyListeners();
    }
  }

  void deleteHistoryItem(String id) {
    _history.removeWhere((e) => e.id == id);
    _saveHistory();
    notifyListeners();
  }

  void clearHistory() {
    HapticService.mediumClick();
    _history.clear();
    _saveHistory();
    notifyListeners();
  }

  void shareHistoryReceipt(CalculationHistory item) {
    final buffer = StringBuffer();
    buffer.writeln('🧾 Smart Calc Receipt');
    buffer.writeln('--------------------');
    if (item.label != null && item.label!.isNotEmpty) {
      buffer.writeln('Note: ${item.label}');
    }
    buffer.writeln('Calculation: ${item.expression}');
    buffer.writeln('Total: ${item.result}');
    buffer.writeln('Date: ${_formatDate(item.timestamp)}');
    buffer.writeln('--------------------');
    buffer.writeln('Calculated with Smart Calculator');

    SharePlus.instance.share(
      ShareParams(
        text: buffer.toString(),
        subject: 'Calculation Receipt',
      ),
    );
  }

  void shareAllHistory() {
    if (_history.isEmpty) return;
    final buffer = StringBuffer();
    buffer.writeln('🧾 Smart Calc Statement / Expense List');
    buffer.writeln('==================================');
    for (var item in _history) {
      final labelText = (item.label != null && item.label!.isNotEmpty) ? ' [${item.label}]' : '';
      buffer.writeln('• ${item.expression} = ${item.result}$labelText');
    }
    buffer.writeln('==================================');
    buffer.writeln('Exported from Smart Calculator');

    SharePlus.instance.share(
      ShareParams(
        text: buffer.toString(),
        subject: 'Smart Calc Statement',
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  void _evaluateLive() {
    if (_expression.isEmpty) {
      _liveResult = '';
      return;
    }

    try {
      final res = _calculateResult(_expression);
      if (res != null && res != _expression) {
        _liveResult = res;
      } else {
        _liveResult = '';
      }
    } catch (_) {
      _liveResult = '';
    }
  }

  String? _calculateResult(String expr) {
    try {
      String sanitized = expr
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('π', '3.141592653589793')
          .replaceAll('e', '2.718281828459045');

      // Simple % handling
      sanitized = sanitized.replaceAll('%', '*0.01');

      GrammarParser parser = GrammarParser();
      Expression parsed = parser.parse(sanitized);
      num evalNum = RealEvaluator().evaluate(parsed);
      double eval = evalNum.toDouble();

      if (eval.isNaN || eval.isInfinite) return 'Error';

      // Format clean numbers (remove unnecessary trailing zeroes)
      if (eval == eval.roundToDouble()) {
        return eval.toInt().toString();
      } else {
        String str = eval.toStringAsFixed(8);
        // trim trailing zeroes
        while (str.contains('.') && (str.endsWith('0') || str.endsWith('.'))) {
          str = str.substring(0, str.length - 1);
        }
        return str;
      }
    } catch (_) {
      return null;
    }
  }

  bool _isOperator(String char) {
    return char == '+' || char == '-' || char == '×' || char == '÷' || char == '%' || char == '^';
  }
}
