import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Converter {
  // Map full unit names to abbreviated codes
  static const Map<String, String> unitAbbreviations = {
    'Meters (m)': 'M',
    'Kilometers (km)': 'KM',
    'Feet (ft)': 'FT',
    'Yards': 'YARD',
    'Celsius (°C)': 'C',
    'Fahrenheit (°F)': 'F',
    'Kelvin (K)': 'K',
    'Kilograms (kg)': 'KG',
    'Grams (g)': 'G',
    'Pounds (lbs)': 'LB',
    'Ounces (oz)': 'OZ',
    'Seconds (s)': 'S',
    'Minutes (min)': 'MIN',
    'Hours (h)': 'HR',
    'Days': 'DAY',
    'Meters per second (m/s)': 'M/S',
    'Kilometers per hour (km/h)': 'KM/H',
    'Miles per hour (mph)': 'MPH',
    'Knots': 'KNOT',
    'Square Meters (m²)': 'M²',
    'Square Kilometers (km²)': 'KM²',
    'Hectares (ha)': 'HA',
    'Acres': 'ACRE',
    'Bytes (B)': 'B',
    'Kilobytes (KB)': 'KB',
    'Megabytes (MB)': 'MB',
    'Gigabytes (GB)': 'GB',
    'Liters (L)': 'L',
    'Milliliters (mL)': 'ML',
    'Cubic Meters (m³)': 'M³',
    'Gallons': 'GAL',
  };

  // Length conversion: input is in meters
  static String convertLength(double input, String fromUnit, String toUnit) {
    const conversionRates = {
      'M': 1.0, // Base unit: Meter
      'KM': 0.001,
      'FT': 3.28084,
      'YARD': 1.09361,
    };

    String fromCode = unitAbbreviations[fromUnit] ?? 'M';
    String toCode = unitAbbreviations[toUnit] ?? 'M';

    double baseValue = input / (conversionRates[fromCode] ?? 1.0);
    double result = baseValue * (conversionRates[toCode] ?? 1.0);
    return '${result.toStringAsFixed(2)} $toUnit';
  }

  // Temperature conversion
  static String convertTemperature(double input, String fromUnit, String toUnit) {
    String fromCode = unitAbbreviations[fromUnit] ?? 'C';
    String toCode = unitAbbreviations[toUnit] ?? 'C';

    if (fromCode == 'C' && toCode == 'F') {
      return '${((input * 9 / 5) + 32).toStringAsFixed(2)} $toUnit';
    } else if (fromCode == 'F' && toCode == 'C') {
      return '${((input - 32) * 5 / 9).toStringAsFixed(2)} $toUnit';
    } else if (fromCode == 'C' && toCode == 'K') {
      return '${(input + 273.15).toStringAsFixed(2)} $toUnit';
    } else if (fromCode == 'K' && toCode == 'C') {
      return '${(input - 273.15).toStringAsFixed(2)} $toUnit';
    } else {
      return '${input.toStringAsFixed(2)} $toUnit'; // No conversion needed
    }
  }

  // Mass conversion: input is in kilograms
  static String convertMass(double input, String fromUnit, String toUnit) {
    const conversionRates = {
      'KG': 1.0,
      'G': 1000.0,
      'LB': 2.20462,
      'OZ': 35.274,
    };

    String fromCode = unitAbbreviations[fromUnit] ?? 'KG';
    String toCode = unitAbbreviations[toUnit] ?? 'KG';

    double baseValue = input / (conversionRates[fromCode] ?? 1.0);
    double result = baseValue * (conversionRates[toCode] ?? 1.0);
    return '${result.toStringAsFixed(2)} $toUnit';
  }

  // Time conversion: input is in seconds
  static String convertTime(double input, String fromUnit, String toUnit) {
    const conversionRates = {
      'S': 1.0,
      'MIN': 1 / 60.0,
      'HR': 1 / 3600.0,
      'DAY': 1 / 86400.0,
    };

    String fromCode = unitAbbreviations[fromUnit] ?? 'S';
    String toCode = unitAbbreviations[toUnit] ?? 'S';

    double baseValue = input / (conversionRates[fromCode] ?? 1.0);
    double result = baseValue * (conversionRates[toCode] ?? 1.0);
    return '${result.toStringAsFixed(2)} $toUnit';
  }

  // Speed conversion: input is in meters per second
  static String convertSpeed(double input, String fromUnit, String toUnit) {
    const conversionRates = {
      'M/S': 1.0,
      'KM/H': 3.6,
      'MPH': 2.23694,
      'KNOT': 1.94384,
    };

    String fromCode = unitAbbreviations[fromUnit] ?? 'M/S';
    String toCode = unitAbbreviations[toUnit] ?? 'M/S';

    double baseValue = input / (conversionRates[fromCode] ?? 1.0);
    double result = baseValue * (conversionRates[toCode] ?? 1.0);
    return '${result.toStringAsFixed(2)} $toUnit';
  }

  // BMI calculation
  static String calculateBMI(double weight, double height) {
    if (height <= 0) {
      throw ArgumentError('Height must be greater than zero.');
    }
    if (weight <= 0) {
      throw ArgumentError('Weight must be greater than zero.');
    }
    double bmi = weight / ((height / 100) * (height / 100)); // Convert height to meters
    return bmi.toStringAsFixed(2);
  }

  // Area conversion: input is in square meters
  static String convertArea(double input, String fromUnit, String toUnit) {
    const conversionRates = {
      'M²': 1.0, // Base unit: Square Meters
      'KM²': 0.000001,
      'HA': 0.0001,
      'ACRE': 0.000247105,
    };

    String fromCode = unitAbbreviations[fromUnit] ?? 'M²';
    String toCode = unitAbbreviations[toUnit] ?? 'M²';

    double baseValue = input / (conversionRates[fromCode] ?? 1.0);
    double result = baseValue * (conversionRates[toCode] ?? 1.0);
    return '${result.toStringAsFixed(2)} $toUnit';
  }

  // Discount calculation
  static String calculateDiscount(double originalPrice, double discountPercentage) {
    if (originalPrice <= 0 || discountPercentage < 0 || discountPercentage > 100) {
      return 'Invalid input';
    }
    double discountAmount = (originalPrice * discountPercentage) / 100;
    double finalPrice = originalPrice - discountAmount;
    return 'Final Price: \$${finalPrice.toStringAsFixed(2)}';
  }

  // Data conversion: input is in bytes
  static String convertData(double input, String fromUnit, String toUnit) {
    const conversionRates = {
      'B': 1.0, // Base unit: Bytes
      'KB': 1 / 1024,
      'MB': 1 / (1024 * 1024),
      'GB': 1 / (1024 * 1024 * 1024),
    };

    String fromCode = unitAbbreviations[fromUnit] ?? 'B';
    String toCode = unitAbbreviations[toUnit] ?? 'B';

    double baseValue = input / (conversionRates[fromCode] ?? 1.0);
    double result = baseValue * (conversionRates[toCode] ?? 1.0);
    return '${result.toStringAsFixed(2)} $toUnit';
  }

  // Volume conversion: input is in liters
  static String convertVolume(double input, String fromUnit, String toUnit) {
    const conversionRates = {
      'L': 1.0, // Base unit: Liters
      'ML': 1000.0,
      'M³': 0.001,
      'GAL': 0.264172,
    };

    String fromCode = unitAbbreviations[fromUnit] ?? 'L';
    String toCode = unitAbbreviations[toUnit] ?? 'L';

    double baseValue = input / (conversionRates[fromCode] ?? 1.0);
    double result = baseValue * (conversionRates[toCode] ?? 1.0);
    return '${result.toStringAsFixed(2)} $toUnit';
  }

  // Numeral system conversion
  static String convertNumeralSystem(String input, String fromUnit, String toUnit) {
    try {
      int decimalValue;
      if (fromUnit == 'Binary') {
        decimalValue = int.parse(input, radix: 2);
      } else if (fromUnit == 'Decimal') {
        decimalValue = int.parse(input);
      } else if (fromUnit == 'Hexadecimal') {
        decimalValue = int.parse(input, radix: 16);
      } else if (fromUnit == 'Octal') {
        decimalValue = int.parse(input, radix: 8);
      } else {
        return 'Invalid input unit';
      }

      if (toUnit == 'Binary') {
        return decimalValue.toRadixString(2);
      } else if (toUnit == 'Decimal') {
        return decimalValue.toString();
      } else if (toUnit == 'Hexadecimal') {
        return decimalValue.toRadixString(16).toUpperCase();
      } else if (toUnit == 'Octal') {
        return decimalValue.toRadixString(8);
      } else {
        return 'Invalid output unit';
      }
    } catch (e) {
      return 'Invalid input';
    }
  }

  // Currency conversion using ExchangeRate-API
  static Future<String> convertCurrency(double amount, String fromCurrency, String toCurrency) async {
    try {
      final apiKey = dotenv.env['API_KEY']; // Load API key from .env file
      if (apiKey == null) {
        throw Exception('API key not found in .env file');
      }

      // Extract currency codes (e.g., "USD (\$)" -> "USD")
      final fromCode = fromCurrency.replaceAll(RegExp(r'[^A-Z]'), ''); // Remove non-uppercase letters
      final toCode = toCurrency.replaceAll(RegExp(r'[^A-Z]'), ''); // Remove non-uppercase letters

      final response = await http.get(
        Uri.parse('https://v6.exchangerate-api.com/v6/$apiKey/latest/$fromCode'),
      );

      if (response.statusCode == 200) {
        final exchangeRates = json.decode(response.body);
        final rates = exchangeRates['conversion_rates'];

        if (rates == null || rates[toCode] == null) {
          return 'Invalid currency';
        }

        double toRate = rates[toCode];
        double convertedAmount = amount * toRate;
        return '${convertedAmount.toStringAsFixed(2)} $toCurrency'; // Include the full unit name
      } else {
        throw Exception('Failed to load exchange rates');
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
}