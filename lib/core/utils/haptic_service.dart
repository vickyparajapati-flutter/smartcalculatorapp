import 'package:flutter/services.dart';

class HapticService {
  static bool isEnabled = true;

  static void lightClick() {
    if (isEnabled) {
      HapticFeedback.lightImpact();
    }
  }

  static void mediumClick() {
    if (isEnabled) {
      HapticFeedback.mediumImpact();
    }
  }

  static void selectionClick() {
    if (isEnabled) {
      HapticFeedback.selectionClick();
    }
  }
}

