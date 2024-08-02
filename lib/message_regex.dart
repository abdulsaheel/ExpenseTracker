import 'dart:core';

// Dart function to parse pattern 1
List<String?> parsePattern1(String message) {
  RegExp regex = RegExp(r"Rs (\d+\.\d+) (\w+) from .* -(\w+)");
  Match? match = regex.firstMatch(message);
  if (match != null) {
    String? amount = match.group(1);
    String? transactionType = match.group(2);
    String? bank = match.group(3);
    return [transactionType, amount, bank];
  }
  return [null, null, null];
}

// Dart function to parse pattern 2
List<String?> parsePattern2(String message) {
  RegExp regex = RegExp(r"Rs\.(\d+) transferred from .* - (.+)");
  Match? match = regex.firstMatch(message);
  if (match != null) {
    String? amount = match.group(1);
    String? transactionType = "debit";
    String? bank = match.group(2);
    return [transactionType, amount, bank];
  }
  return [null, null, null];
}

// Dart function to parse pattern 3
List<String?> parsePattern3(String message) {
  RegExp regex = RegExp(r"Rs\.(\d+) Credited to .* - (.+)");
  Match? match = regex.firstMatch(message);
  if (match != null) {
    String? amount = match.group(1);
    String? transactionType = "credited";
    String? bank = match.group(2);
    return [transactionType, amount, bank];
  }
  return [null, null, null];
}

// Dart function to parse pattern 4
List<String?> parsePattern4(String message) {
  RegExp regex =
      RegExp(r"account is credited INR (\d+\.\d+) on Date .* - (\w+)");
  Match? match = regex.firstMatch(message);
  if (match != null) {
    String? amount = match.group(1);
    String? transactionType = "credited";
    String? bank = match.group(2);
    return [transactionType, amount, bank];
  }
  return [null, null, null];
}

// Dart function to parse pattern 5
List<String?> parsePattern5(String message) {
  RegExp regex = RegExp(r"Rs\.(\d+) transferred from .* - (.+)");
  Match? match = regex.firstMatch(message);
  if (match != null) {
    String? amount = match.group(1);
    String? transactionType = "debit";
    String? bank = match.group(2);
    return [transactionType, amount, bank];
  }
  return [null, null, null];
}

// Dart function to parse pattern 6
List<String?> parsePattern6(String message) {
  RegExp regex =
      RegExp(r"Rs\.(\d+\.\d+) credited to your A/c .* via IMPS on .* -(.+)");
  Match? match = regex.firstMatch(message);
  if (match != null) {
    String? amount = match.group(1);
    String? transactionType = "credited";
    String? bank = match.group(2);
    return [transactionType, amount, bank];
  }
  return [null, null, null];
}

// Dart function to parse pattern 7
List<String?> parsePattern7(String message) {
  RegExp regex = RegExp(r"credited INR (\d+\.\d+) on Date .* - (\w+)");
  Match? match = regex.firstMatch(message);
  if (match != null) {
    String? amount = match.group(1);
    String? transactionType = "credited";
    String? bank = match.group(2);
    return [transactionType, amount, bank];
  }
  return [null, null, null];
}

// Dart function to parse transaction message using all patterns
List<String?> parseTransactionMessage(String message) {
  List<List<String?> Function(String)> parsers = [
    parsePattern1,
    parsePattern2,
    parsePattern3,
    parsePattern4,
    parsePattern5,
    parsePattern6,
    parsePattern7,
  ];

  for (Function parser in parsers) {
    List<String?> result = parser(message);
    if (result.every((element) => element != null)) {
      return result;
    }
  }
  return [null, null, null];
}
