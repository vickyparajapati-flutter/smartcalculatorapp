import 'dart:math';
import 'package:flutter/foundation.dart';
import '../core/utils/haptic_service.dart';

class FinancialProvider extends ChangeNotifier {
  // ==================== GST STATE ====================
  double _gstAmount = 1000;
  double _gstRate = 18;
  bool _isGstInclusive = false; // false = Exclusive (+GST), true = Inclusive (-GST)

  double get gstAmount => _gstAmount;
  double get gstRate => _gstRate;
  bool get isGstInclusive => _isGstInclusive;

  double get calculatedGstTax {
    if (_isGstInclusive) {
      // Inclusive: GST = Amount - [Amount * (100 / (100 + Rate))]
      return _gstAmount - (_gstAmount * (100 / (100 + _gstRate)));
    } else {
      // Exclusive: GST = Amount * Rate / 100
      return (_gstAmount * _gstRate) / 100;
    }
  }

  double get netGstAmount {
    if (_isGstInclusive) {
      return _gstAmount - calculatedGstTax;
    } else {
      return _gstAmount;
    }
  }

  double get totalGstAmount {
    if (_isGstInclusive) {
      return _gstAmount;
    } else {
      return _gstAmount + calculatedGstTax;
    }
  }

  double get cgst => calculatedGstTax / 2;
  double get sgst => calculatedGstTax / 2;

  void updateGstAmount(double value) {
    _gstAmount = value;
    notifyListeners();
  }

  void updateGstRate(double rate) {
    HapticService.lightClick();
    _gstRate = rate;
    notifyListeners();
  }

  void toggleGstInclusive(bool inclusive) {
    HapticService.selectionClick();
    _isGstInclusive = inclusive;
    notifyListeners();
  }

  // ==================== EMI / LOAN STATE ====================
  double _loanPrincipal = 500000;
  double _loanAnnualRate = 10.5;
  int _loanTenureMonths = 36; // 3 years

  double get loanPrincipal => _loanPrincipal;
  double get loanAnnualRate => _loanAnnualRate;
  int get loanTenureMonths => _loanTenureMonths;

  double get monthlyEmi {
    if (_loanPrincipal <= 0 || _loanAnnualRate <= 0 || _loanTenureMonths <= 0) return 0;
    double r = (_loanAnnualRate / 12) / 100;
    int n = _loanTenureMonths;
    // EMI = P * r * (1 + r)^n / ((1 + r)^n - 1)
    double emi = (_loanPrincipal * r * pow(1 + r, n)) / (pow(1 + r, n) - 1);
    return emi.isFinite ? emi : 0;
  }

  double get totalLoanPayment => monthlyEmi * _loanTenureMonths;
  double get totalLoanInterest => totalLoanPayment - _loanPrincipal;

  void updateLoanPrincipal(double value) {
    _loanPrincipal = value;
    notifyListeners();
  }

  void updateLoanRate(double value) {
    _loanAnnualRate = value;
    notifyListeners();
  }

  void updateLoanTenureMonths(int months) {
    _loanTenureMonths = months;
    notifyListeners();
  }

  // ==================== SIP STATE ====================
  double _sipMonthlyInvestment = 5000;
  double _sipExpectedRate = 12.0;
  int _sipYears = 10;

  double get sipMonthlyInvestment => _sipMonthlyInvestment;
  double get sipExpectedRate => _sipExpectedRate;
  int get sipYears => _sipYears;

  double get totalSipInvested => _sipMonthlyInvestment * _sipYears * 12;

  double get totalSipWealth {
    if (_sipMonthlyInvestment <= 0 || _sipExpectedRate <= 0 || _sipYears <= 0) {
      return totalSipInvested;
    }
    double i = (_sipExpectedRate / 12) / 100;
    int n = _sipYears * 12;
    // M * [((1 + i)^n - 1) / i] * (1 + i)
    double wealth = _sipMonthlyInvestment * ((pow(1 + i, n) - 1) / i) * (1 + i);
    return wealth.isFinite ? wealth : 0;
  }

  double get totalSipReturns => totalSipWealth - totalSipInvested;

  void updateSipMonthly(double value) {
    _sipMonthlyInvestment = value;
    notifyListeners();
  }

  void updateSipRate(double value) {
    _sipExpectedRate = value;
    notifyListeners();
  }

  void updateSipYears(int years) {
    _sipYears = years;
    notifyListeners();
  }

  // ==================== DISCOUNT STATE ====================
  double _discountOriginalPrice = 1000;
  double _discountPercentage = 20;
  double _discountAdditionalPercentage = 0;

  double get discountOriginalPrice => _discountOriginalPrice;
  double get discountPercentage => _discountPercentage;
  double get discountAdditionalPercentage => _discountAdditionalPercentage;

  double get finalDiscountedPrice {
    double afterFirst = _discountOriginalPrice * (1 - (_discountPercentage / 100));
    double afterSecond = afterFirst * (1 - (_discountAdditionalPercentage / 100));
    return afterSecond < 0 ? 0 : afterSecond;
  }

  double get totalDiscountSavings => _discountOriginalPrice - finalDiscountedPrice;

  void updateDiscountOriginalPrice(double value) {
    _discountOriginalPrice = value;
    notifyListeners();
  }

  void updateDiscountPercentage(double value) {
    _discountPercentage = value;
    notifyListeners();
  }

  void updateDiscountAdditionalPercentage(double value) {
    _discountAdditionalPercentage = value;
    notifyListeners();
  }
}
