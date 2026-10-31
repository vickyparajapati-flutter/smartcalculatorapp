import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_calculator/providers/calculator_provider.dart';
import 'package:smart_calculator/providers/financial_provider.dart';
import 'package:smart_calculator/providers/utility_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('CalculatorProvider Tests', () {
    test('Basic Arithmetic & Live Preview', () {
      final provider = CalculatorProvider();
      provider.append('2');
      provider.append('+');
      provider.append('2');
      expect(provider.liveResult, '4');

      provider.equals();
      expect(provider.expression, '4');
      expect(provider.history.length, 1);
      expect(provider.history.first.result, '4');
    });

    test('Order of Operations', () {
      final provider = CalculatorProvider();
      provider.append('1');
      provider.append('0');
      provider.append('+');
      provider.append('5');
      provider.append('×');
      provider.append('2');
      expect(provider.liveResult, '20');

      provider.equals();
      expect(provider.expression, '20');
    });

    test('Smart Tape Labeling', () {
      final provider = CalculatorProvider();
      provider.append('5');
      provider.append('0');
      provider.append('0');
      provider.append('+');
      provider.append('1');
      provider.append('0');
      provider.append('0');
      provider.equals();

      final id = provider.history.first.id;
      provider.updateHistoryLabel(id, 'Groceries');
      expect(provider.history.first.label, 'Groceries');
    });
  });

  group('FinancialProvider Tests', () {
    test('GST Exclusive Calculation', () {
      final fin = FinancialProvider();
      fin.updateGstAmount(1000);
      fin.updateGstRate(18);
      fin.toggleGstInclusive(false);

      expect(fin.calculatedGstTax, 180.0);
      expect(fin.totalGstAmount, 1180.0);
      expect(fin.cgst, 90.0);
      expect(fin.sgst, 90.0);
    });

    test('Loan EMI Calculation', () {
      final fin = FinancialProvider();
      fin.updateLoanPrincipal(100000);
      fin.updateLoanRate(12); // 12% annual = 1% monthly
      fin.updateLoanTenureMonths(12);

      // Monthly EMI for 100,000 at 12% for 12 months is approx 8884.88
      expect(fin.monthlyEmi.round(), 8885);
      expect(fin.totalLoanPayment > 100000, true);
    });

    test('SIP Wealth Calculation', () {
      final fin = FinancialProvider();
      fin.updateSipMonthly(5000);
      fin.updateSipRate(12);
      fin.updateSipYears(1);

      // 5000/month for 1 year at 12% p.a.
      expect(fin.totalSipInvested, 60000);
      expect(fin.totalSipWealth > 60000, true);
    });

    test('Discount Calculation', () {
      final fin = FinancialProvider();
      fin.updateDiscountOriginalPrice(1000);
      fin.updateDiscountPercentage(20);
      fin.updateDiscountAdditionalPercentage(10);

      // 1000 - 20% = 800; 800 - 10% = 720
      expect(fin.finalDiscountedPrice, 720.0);
      expect(fin.totalDiscountSavings, 280.0);
    });
  });

  group('UtilityProvider Tests', () {
    test('BMI Calculation', () {
      final util = UtilityProvider();
      util.updateWeight(70);
      util.updateHeight(175); // 1.75m -> 70 / (1.75 * 1.75) = 22.86 (Normal)

      final res = util.bmiResult;
      expect(res.category, 'Normal / Healthy');
      expect(res.bmi.toStringAsFixed(1), '22.9');
    });

    test('Age Calculation', () {
      final util = UtilityProvider();
      final now = DateTime.now();
      util.updateBirthDate(DateTime(now.year - 25, now.month, now.day));

      final age = util.ageResult;
      expect(age.years, 25);
      expect(age.nextBirthdayDays, 0);
    });

    test('Unit Converter', () {
      final util = UtilityProvider();
      util.setCategory('Length');
      util.setFromUnit('Kilometer');
      util.setToUnit('Meter');
      util.setInputValue(2.5);

      expect(util.convertedValue, 2500.0);
    });
  });
}
