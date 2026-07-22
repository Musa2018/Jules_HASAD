class Validators {
  static bool isValidPalestinianId(String idNumber) {
    idNumber = idNumber.trim();
    if (idNumber.length != 9) return false;
    if (int.tryParse(idNumber) == null) return false;

    final digits = idNumber.split('').map(int.parse).toList();
    int formula = 0;

    for (int i = 0; i <= digits.length - 2; i++) {
      int digit = digits[i];

      if (i % 2 == 0) {
        formula += digit * 1;
      } else {
        int temp = digit * 2;
        if (temp >= 10) temp -= 9;
        formula += temp;
      }
    }

    formula += digits[8];

    return formula % 10 == 0;
  }

  static bool isNumeric(String value) {
    if (value.isEmpty) return false;
    return int.tryParse(value) != null;
  }

  static bool isAlphanumeric(String value) {
    if (value.isEmpty) return false;
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value);
  }

  static bool isAtLeast18(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    
    if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    
    return age >= 18;
  }
}
