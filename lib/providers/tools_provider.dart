import 'package:flutter/foundation.dart';
import '../core/utils/haptic_service.dart';

class ToolsProvider extends ChangeNotifier {
  // ==================== PERCENTAGE CALCULATOR ====================
  // Mode 1: What is X% of Y?
  double _p1Percent = 15;
  double _p1Total = 2400;

  double get p1Percent => _p1Percent;
  double get p1Total => _p1Total;
  double get p1Result => (_p1Total * _p1Percent) / 100;

  void updateP1Percent(double val) {
    _p1Percent = val;
    notifyListeners();
  }

  void updateP1Total(double val) {
    _p1Total = val;
    notifyListeners();
  }

  // Mode 2: X is what % of Y?
  double _p2Part = 45;
  double _p2Whole = 180;

  double get p2Part => _p2Part;
  double get p2Whole => _p2Whole;
  double get p2Result => _p2Whole == 0 ? 0 : (_p2Part / _p2Whole) * 100;

  void updateP2Part(double val) {
    _p2Part = val;
    notifyListeners();
  }

  void updateP2Whole(double val) {
    _p2Whole = val;
    notifyListeners();
  }

  // Mode 3: % Increase/Decrease from X to Y
  double _p3From = 100;
  double _p3To = 125;

  double get p3From => _p3From;
  double get p3To => _p3To;
  double get p3ChangePercent => _p3From == 0 ? 0 : ((_p3To - _p3From) / _p3From) * 100;

  void updateP3From(double val) {
    _p3From = val;
    notifyListeners();
  }

  void updateP3To(double val) {
    _p3To = val;
    notifyListeners();
  }

  // ==================== TIP & BILL SPLITTER ====================
  double _tipBillAmount = 2400;
  double _tipPercentage = 10;
  int _tipSplitPeople = 4;

  double get tipBillAmount => _tipBillAmount;
  double get tipPercentage => _tipPercentage;
  int get tipSplitPeople => _tipSplitPeople;

  double get totalTipAmount => (_tipBillAmount * _tipPercentage) / 100;
  double get totalBillWithTip => _tipBillAmount + totalTipAmount;
  double get tipPerPerson => _tipSplitPeople <= 0 ? 0 : totalTipAmount / _tipSplitPeople;
  double get totalPerPerson => _tipSplitPeople <= 0 ? 0 : totalBillWithTip / _tipSplitPeople;

  void updateTipBill(double val) {
    _tipBillAmount = val;
    notifyListeners();
  }

  void updateTipPercentage(double val) {
    _tipPercentage = val;
    notifyListeners();
  }

  void updateTipSplitPeople(int people) {
    if (people >= 1) {
      _tipSplitPeople = people;
      notifyListeners();
    }
  }

  // ==================== UNIT PRICE COMPARISON ====================
  // Item A
  double _itemAPrice = 120;
  double _itemAQuantity = 500; // e.g. 500g

  // Item B
  double _itemBPrice = 220;
  double _itemBQuantity = 1000; // e.g. 1000g

  double get itemAPrice => _itemAPrice;
  double get itemAQuantity => _itemAQuantity;
  double get itemBPrice => _itemBPrice;
  double get itemBQuantity => _itemBQuantity;

  double get unitPriceA => _itemAQuantity <= 0 ? 0 : _itemAPrice / _itemAQuantity;
  double get unitPriceB => _itemBQuantity <= 0 ? 0 : _itemBPrice / _itemBQuantity;

  int get cheaperItem {
    if (unitPriceA <= 0 || unitPriceB <= 0) return 0;
    if ((unitPriceA - unitPriceB).abs() < 0.00001) return 0; // Equal
    return unitPriceA < unitPriceB ? 1 : 2; // 1 = Item A, 2 = Item B
  }

  double get savingsPercent {
    if (unitPriceA <= 0 || unitPriceB <= 0) return 0;
    double high = unitPriceA > unitPriceB ? unitPriceA : unitPriceB;
    double low = unitPriceA < unitPriceB ? unitPriceA : unitPriceB;
    return ((high - low) / high) * 100;
  }

  void updateItemA(double price, double qty) {
    _itemAPrice = price;
    _itemAQuantity = qty;
    notifyListeners();
  }

  void updateItemB(double price, double qty) {
    _itemBPrice = price;
    _itemBQuantity = qty;
    notifyListeners();
  }

  // ==================== SALARY / TAKE-HOME PAY ====================
  double _grossMonthlySalary = 65000;
  double _pfDeduction = 1800;
  double _taxDeduction = 2500;
  double _otherDeduction = 200;

  double get grossMonthlySalary => _grossMonthlySalary;
  double get pfDeduction => _pfDeduction;
  double get taxDeduction => _taxDeduction;
  double get otherDeduction => _otherDeduction;

  double get totalDeductions => _pfDeduction + _taxDeduction + _otherDeduction;
  double get netInHandSalary => _grossMonthlySalary - totalDeductions;
  double get annualTakeHome => netInHandSalary * 12;

  void updateSalary({
    double? gross,
    double? pf,
    double? tax,
    double? other,
  }) {
    if (gross != null) _grossMonthlySalary = gross;
    if (pf != null) _pfDeduction = pf;
    if (tax != null) _taxDeduction = tax;
    if (other != null) _otherDeduction = other;
    notifyListeners();
  }

  // ==================== BMR & CALORIE CALCULATOR ====================
  bool _isMale = true;
  double _bmrWeightKg = 70;
  double _bmrHeightCm = 175;
  int _bmrAgeYears = 25;
  double _activityMultiplier = 1.375; // Lightly active

  bool get isMale => _isMale;
  double get bmrWeightKg => _bmrWeightKg;
  double get bmrHeightCm => _bmrHeightCm;
  int get bmrAgeYears => _bmrAgeYears;
  double get activityMultiplier => _activityMultiplier;

  // Mifflin-St Jeor formula
  double get bmr {
    if (_bmrWeightKg <= 0 || _bmrHeightCm <= 0 || _bmrAgeYears <= 0) return 0;
    if (_isMale) {
      return (10 * _bmrWeightKg) + (6.25 * _bmrHeightCm) - (5 * _bmrAgeYears) + 5;
    } else {
      return (10 * _bmrWeightKg) + (6.25 * _bmrHeightCm) - (5 * _bmrAgeYears) - 161;
    }
  }

  double get dailyCaloriesMaintenance => bmr * _activityMultiplier;
  double get dailyCaloriesWeightLoss => dailyCaloriesMaintenance - 500;
  double get dailyCaloriesWeightGain => dailyCaloriesMaintenance + 500;

  void setBmrGender(bool isMale) {
    HapticService.selectionClick();
    _isMale = isMale;
    notifyListeners();
  }

  void setBmrData({double? weight, double? height, int? age, double? multiplier}) {
    if (weight != null) _bmrWeightKg = weight;
    if (height != null) _bmrHeightCm = height;
    if (age != null) _bmrAgeYears = age;
    if (multiplier != null) _activityMultiplier = multiplier;
    notifyListeners();
  }

  // ==================== WATER INTAKE CALCULATOR ====================
  double _waterWeightKg = 65;
  int _exerciseMinutes = 30;

  double get waterWeightKg => _waterWeightKg;
  int get exerciseMinutes => _exerciseMinutes;

  // Approx: 35ml per kg of body weight + 350ml per 30 mins exercise
  double get dailyWaterLiters {
    double base = (_waterWeightKg * 0.035);
    double extra = (_exerciseMinutes / 30) * 0.35;
    return base + extra;
  }

  int get dailyWaterGlasses => (dailyWaterLiters * 1000 / 250).round(); // 250ml per glass

  void setWaterData(double weight, int exercise) {
    _waterWeightKg = weight;
    _exerciseMinutes = exercise;
    notifyListeners();
  }

  // ==================== FUEL MILEAGE & TRIP COST ====================
  double _fuelDistanceKm = 350;
  double _fuelEfficiencyKmpl = 18.0;
  double _fuelPricePerLiter = 96.5;

  double get fuelDistanceKm => _fuelDistanceKm;
  double get fuelEfficiencyKmpl => _fuelEfficiencyKmpl;
  double get fuelPricePerLiter => _fuelPricePerLiter;

  double get totalFuelNeededLiters =>
      _fuelEfficiencyKmpl <= 0 ? 0 : _fuelDistanceKm / _fuelEfficiencyKmpl;
  double get totalTripFuelCost => totalFuelNeededLiters * _fuelPricePerLiter;
  double get costPerKm => _fuelDistanceKm <= 0 ? 0 : totalTripFuelCost / _fuelDistanceKm;

  void updateFuelData({double? distance, double? mileage, double? price}) {
    if (distance != null) _fuelDistanceKm = distance;
    if (mileage != null) _fuelEfficiencyKmpl = mileage;
    if (price != null) _fuelPricePerLiter = price;
    notifyListeners();
  }

  // ==================== DATE & DAYS CALCULATOR ====================
  DateTime _dateFrom = DateTime.now();
  DateTime _dateTo = DateTime.now().add(const Duration(days: 30));

  DateTime get dateFrom => _dateFrom;
  DateTime get dateTo => _dateTo;

  int get totalDaysBetween => (_dateTo.difference(_dateFrom).inDays).abs();
  int get totalWeeksBetween => totalDaysBetween ~/ 7;
  int get remainingDaysAfterWeeks => totalDaysBetween % 7;

  void updateDateRange(DateTime from, DateTime to) {
    HapticService.selectionClick();
    _dateFrom = from;
    _dateTo = to;
    notifyListeners();
  }
}
