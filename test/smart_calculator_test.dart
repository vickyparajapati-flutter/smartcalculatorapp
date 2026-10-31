import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_calculator/providers/calculator_provider.dart';
import 'package:smart_calculator/providers/financial_provider.dart';
import 'package:smart_calculator/providers/utility_provider.dart';
import 'package:smart_calculator/providers/tools_provider.dart';
import 'package:smart_calculator/providers/vault_provider.dart';

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
      fin.updateLoanRate(12);
      fin.updateLoanTenureMonths(12);

      expect(fin.monthlyEmi.round(), 8885);
      expect(fin.totalLoanPayment > 100000, true);
    });

    test('SIP Wealth Calculation', () {
      final fin = FinancialProvider();
      fin.updateSipMonthly(5000);
      fin.updateSipRate(12);
      fin.updateSipYears(1);

      expect(fin.totalSipInvested, 60000);
      expect(fin.totalSipWealth > 60000, true);
    });

    test('Discount Calculation', () {
      final fin = FinancialProvider();
      fin.updateDiscountOriginalPrice(1000);
      fin.updateDiscountPercentage(20);
      fin.updateDiscountAdditionalPercentage(10);

      expect(fin.finalDiscountedPrice, 720.0);
      expect(fin.totalDiscountSavings, 280.0);
    });
  });

  group('ToolsProvider Tests (All-in-One Suite)', () {
    test('Percentage calculations', () {
      final tools = ToolsProvider();
      tools.updateP1Percent(20);
      tools.updateP1Total(500);
      expect(tools.p1Result, 100.0);

      tools.updateP2Part(50);
      tools.updateP2Whole(200);
      expect(tools.p2Result, 25.0);
    });

    test('Tip & Split Bill', () {
      final tools = ToolsProvider();
      tools.updateTipBill(1000);
      tools.updateTipPercentage(10);
      tools.updateTipSplitPeople(2);

      expect(tools.totalTipAmount, 100.0);
      expect(tools.totalBillWithTip, 1100.0);
      expect(tools.totalPerPerson, 550.0);
    });

    test('Unit Price Comparison', () {
      final tools = ToolsProvider();
      // Item A: 100 for 500g (0.2/g)
      // Item B: 150 for 1000g (0.15/g) -> Item B is cheaper
      tools.updateItemA(100, 500);
      tools.updateItemB(150, 1000);
      expect(tools.cheaperItem, 2);
    });

    test('BMR & Calorie needs', () {
      final tools = ToolsProvider();
      tools.setBmrGender(true);
      tools.setBmrData(weight: 70, height: 175, age: 25, multiplier: 1.2);
      expect(tools.bmr > 1600, true);
      expect(tools.dailyCaloriesMaintenance > tools.bmr, true);
    });

    test('Fuel cost calculation', () {
      final tools = ToolsProvider();
      tools.updateFuelData(distance: 200, mileage: 20, price: 100);
      expect(tools.totalFuelNeededLiters, 10.0);
      expect(tools.totalTripFuelCost, 1000.0);
    });
  });

  group('UtilityProvider Tests', () {
    test('BMI Calculation', () {
      final util = UtilityProvider();
      util.updateWeight(70);
      util.updateHeight(175);

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

  group('VaultProvider Tests (Secret Calculator Lock)', () {
    test('Setup Vault & Master PIN Unlock', () async {
      final vault = VaultProvider();
      await vault.setupVault('7788', 'What is your city?', 'mumbai');

      expect(vault.isConfigured, true);
      expect(vault.isUnlocked, true);

      vault.lock();
      expect(vault.isUnlocked, false);

      final res1 = vault.unlock('1111');
      expect(res1, VaultUnlockResult.failed);
      expect(vault.isUnlocked, false);

      final res2 = vault.unlock('7788');
      expect(res2, VaultUnlockResult.success);
      expect(vault.isUnlocked, true);
      expect(vault.isDecoyMode, false);
    });

    test('Decoy PIN Unlock', () async {
      final vault = VaultProvider();
      await vault.setupVault('7788', 'What is your city?', 'mumbai');
      await vault.setDecoyPin('0000');

      vault.lock();
      final res = vault.unlock('0000');
      expect(res, VaultUnlockResult.decoy);
      expect(vault.isUnlocked, true);
      expect(vault.isDecoyMode, true);
    });

    test('Secret Notes Add & Delete', () async {
      final vault = VaultProvider();
      await vault.setupVault('7788', 'Question?', 'answer');

      await vault.addNote('Bank PIN', '1234');
      expect(vault.notes.length, 1);
      expect(vault.notes.first.title, 'Bank PIN');

      await vault.deleteNote(vault.notes.first.id);
      expect(vault.notes.isEmpty, true);
    });
  });
}
