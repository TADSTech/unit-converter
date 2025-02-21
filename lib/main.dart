import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'utils/conversion_logic.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(const UnitConverterApp());
}

class UnitConverterApp extends StatelessWidget {
  const UnitConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Unit Converter',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          secondary: Colors.teal,
          brightness: Brightness.light,
        ),
        dropdownMenuTheme: DropdownMenuThemeData(
          menuStyle: MenuStyle(
            elevation: WidgetStateProperty.all(4),
            backgroundColor: WidgetStateProperty.all(
                Colors.white70),
          ),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 14),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {


  late TextEditingController inputController;
  late TextEditingController weightController;
  late TextEditingController heightController;
  late TextEditingController originalPriceController;
  late TextEditingController discountPercentageController;

  @override
  void initState() {
    super.initState();
    inputController = TextEditingController();
    weightController = TextEditingController();
    heightController = TextEditingController();
    originalPriceController = TextEditingController();
    discountPercentageController = TextEditingController();
  }

  @override
  void dispose() {
    inputController.dispose();
    weightController.dispose();
    heightController.dispose();
    originalPriceController.dispose();
    discountPercentageController.dispose();
    super.dispose();
  }

  String selectedConversion = 'Length';
  String selectedInputUnit = 'Meters (m)';
  String selectedOutputUnit = 'Kilometers (km)';
  String convertedValue = 'N/A';


  final List<String> conversionOptions = [
    'Length',
    'Temperature',
    'Mass',
    'Currency',
    'Area',
    'Time',
    'Data',
    'Discount',
    'Volume',
    'Numeral System',
    'Speed',
    'BMI'
  ];

  final Map<String, List<String>> unitOptions = {
    'Length': ['Meters (m)', 'Kilometers (km)', 'Feet (ft)', 'Yards', 'Miles'],
    'Temperature': ['Celsius (°C)', 'Fahrenheit (°F)', 'Kelvin (K)'],
    'Mass': ['Kilograms (kg)', 'Grams (g)', 'Pounds (lbs)', 'Ounces (oz)'],
    'Currency': [
      'USD (\$)',
      'EUR (€)',
      'GBP (£)',
      'JPY (¥)',
      'AUD (\$)',
      'CAD (\$)',
      'CHF (Fr)',
      'CNY (¥)',
      'INR (₹)',
      'SGD (\$)',
      'NZD (\$)',
      'MXN (\$)',
      'BRL (R\$)',
      'RUB (₽)',
      'ZAR (R)',
      'KRW (₩)',
      'TRY (₺)',
      'AED (د.إ)',
      'HKD (\$)',
      'IDR (Rp)',
      'MYR (RM)',
      'THB (฿)',
      'SAR (﷼)',
      'PHP (₱)',
      'PLN (zł)',
      'SEK (kr)',
      'NOK (kr)',
      'DKK (kr)',
      'HUF (Ft)',
      'CZK (Kč)',
      'ILS (₪)',
      'CLP (\$)',
      'ARS (\$)',
      'COP (\$)',
      'PEN (S/)',
      'VND (₫)',
      'PKR (₨)',
      'BDT (৳)',
      'EGP (E£)',
      'NGN (₦)',
    ],
    'Area': [
      'Square Meters (m²)',
      'Square Kilometers (km²)',
      'Hectares (ha)',
      'Acres'
    ],
    'Time': ['Seconds (s)', 'Minutes (min)', 'Hours (h)', 'Days'],
    'Data': ['Bytes (B)', 'Kilobytes (KB)', 'Megabytes (MB)', 'Gigabytes (GB)'],
    'Discount': ['Original Price', 'Discount Percentage', 'Final Price'],
    'Volume': [
      'Liters (L)',
      'Milliliters (mL)',
      'Cubic Meters (m³)',
      'Gallons'
    ],
    'Numeral System': ['Binary', 'Decimal', 'Hexadecimal', 'Octal'],
    'Speed': [
      'Meters per second (m/s)',
      'Kilometers per hour (km/h)',
      'Miles per hour (mph)'
    ],
    'BMI': ['Weight (kg)', 'Height (cm)', 'BMI'],
  };


  void convert() async {
    final input = double.tryParse(inputController.text) ?? 0.0;
    final weight = double.tryParse(weightController.text) ?? 0.0;
    final height = double.tryParse(heightController.text) ?? 0.0;
    final originalPrice = double.tryParse(originalPriceController.text) ?? 0.0;
    final discountPercentage = double.tryParse(
        discountPercentageController.text) ?? 0.0;

    setState(() {
      convertedValue = 'Converting...';
    });

    try {
      String result;
      switch (selectedConversion) {
        case 'Length':
          result = Converter.convertLength(
              input, selectedInputUnit, selectedOutputUnit);
          break;
        case 'Temperature':
          result = Converter.convertTemperature(
              input, selectedInputUnit, selectedOutputUnit);
          break;
        case 'Mass':
          result = Converter.convertMass(
              input, selectedInputUnit, selectedOutputUnit);
          break;
        case 'Time':
          result = Converter.convertTime(
              input, selectedInputUnit, selectedOutputUnit);
          break;
        case 'Speed':
          result = Converter.convertSpeed(
              input, selectedInputUnit, selectedOutputUnit);
          break;
        case 'Currency':
          try {
            result = await Converter.convertCurrency(
                input, selectedInputUnit, selectedOutputUnit);
          } catch (e) {
            result = 'Failed to fetch rates';
          }
          break;
        case 'BMI':
          result = Converter.calculateBMI(weight, height);
          break;
        case 'Area':
          result = Converter.convertArea(
              input, selectedInputUnit, selectedOutputUnit);
          break;
        case 'Discount':
          result =
              Converter.calculateDiscount(originalPrice, discountPercentage);
          break;
        case 'Data':
          result = Converter.convertData(
              input, selectedInputUnit, selectedOutputUnit);
          break;
        case 'Volume':
          result = Converter.convertVolume(
              input, selectedInputUnit, selectedOutputUnit);
          break;
        case 'Numeral System':
          result = Converter.convertNumeralSystem(
              inputController.text, selectedInputUnit, selectedOutputUnit);
          break;
        default:
          result = 'Conversion not available';
      }
      setState(() {
        convertedValue = result;
      });
    } catch (e) {
      setState(() {
        convertedValue = 'Error: $e';
      });
    }
  }

  void clearInputs() {
    setState(() {
      inputController.clear();
      weightController.clear();
      heightController.clear();
      originalPriceController.clear();
      discountPercentageController.clear();
      convertedValue = 'N/A';
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Unit Converter',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 20)),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primary,
                colorScheme.secondary
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => showAboutDialog(context: context),
          ),
        ],
      ),
      drawer: _buildDrawer(colorScheme),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Current Conversion',
                        style: TextStyle(
                            color: colorScheme.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(selectedConversion,
                          key: ValueKey(selectedConversion),
                          style: TextStyle(
                              color: colorScheme.primary,
                              fontSize: 24,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _buildUnitDropdown('From', selectedInputUnit)),
                const SizedBox(width: 16),
                Icon(Icons.arrow_forward, color: colorScheme.primary),
                const SizedBox(width: 16),
                Expanded(child: _buildUnitDropdown('To', selectedOutputUnit,)),
              ],
            ),
            const SizedBox(height: 24),
            if (selectedConversion == 'BMI') ...[
              _buildInputCard('Weight (kg)', weightController),
              const SizedBox(height: 16),
              _buildInputCard('Height (cm)', heightController),
            ] else if (selectedConversion == 'Discount') ...[
              _buildInputCard('Original Price', originalPriceController),
              const SizedBox(height: 16),
              _buildInputCard('Discount %', discountPercentageController),
            ] else ...[
              _buildInputCard('Enter Value', inputController,
                  isNumber: selectedConversion != 'Numeral System'),
            ],
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    icon: Icon(Icons.autorenew,
                        size: MediaQuery.of(context).size.width < 800 ? 20 : 24),
                    label: Text('Convert',
                        style: TextStyle(fontSize: MediaQuery.of(context).size.width < 800 ? 16 : 18)),
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: convert,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: Icon(Icons.clear, size: MediaQuery.of(context).size.width < 800 ? 20 : 24),
                    label: Text('Clear',
                        style: TextStyle(fontSize: MediaQuery.of(context).size.width < 800 ? 16 : 18)),

                    onPressed: clearInputs,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.secondary,
                      side: BorderSide(color: colorScheme.secondary),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colorScheme.primary.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Result',
                      style: TextStyle(
                          color: colorScheme.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Text(convertedValue,
                        key: ValueKey(convertedValue),
                        style: TextStyle(
                            color: colorScheme.primary,
                            fontSize: 24,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildDrawer(ColorScheme colorScheme) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colorScheme.primary, colorScheme.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Conversions',
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Text('${conversionOptions.length} categories available',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: conversionOptions.length,
              itemBuilder: (context, index) {
                final option = conversionOptions[index];
                return ListTile(
                    leading: Icon(_getIconForCategory(option)), // Added missing )
                    title: Text(option),
                tileColor: selectedConversion == option
                ? colorScheme.primary.withOpacity(0.1)
                    : null,
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
                onTap: () {
                setState(() {
                selectedConversion = option;
                selectedInputUnit = unitOptions[option]!.first;
                selectedOutputUnit = unitOptions[option]!.last;
                });
                Navigator.pop(context);
                },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Length':
        return Icons.straighten;
      case 'Temperature':
        return Icons.thermostat;
      case 'Mass':
        return Icons.scale;
      case 'Currency':
        return Icons.currency_exchange;
      case 'BMI':
        return Icons.monitor_weight;
      default:
        return Icons.calculate;
    }
  }

  Widget _buildUnitDropdown(String label, String value) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 4),
          child: Text(label,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: isMobile ? 12 : 14)), // Smaller label font
        ),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true, // Crucial for proper width management
          items: unitOptions[selectedConversion]?.map((unit) {
            return DropdownMenuItem(
              value: unit,
              child: Text(unit,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: isMobile ? 12 : 14, // Smaller text
                      fontWeight: FontWeight.w500)),
            );
          }).toList() ?? [],
          onChanged: (value) => setState(() {
            if (label == 'From') {
              selectedInputUnit = value!;
            } else {
              selectedOutputUnit = value!; // Fixed output unit update
            }
          }),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: isMobile ? 10 : 12
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
            ),
          ),
          menuMaxHeight: MediaQuery.of(context).size.height * 0.5,
          dropdownColor: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          iconSize: 20,
          elevation: 2,
          style: TextStyle(
              fontSize: isMobile ? 14 : 16, // Selected value font
              color: Theme.of(context).colorScheme.onSurface),
        ),
      ],
    );
  }

  Widget _buildInputCard(String label, TextEditingController controller,
      {bool isNumber = true}) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(isNumber ? Icons.numbers : Icons.text_snippet,
            size: isMobile ? 18 : 22),
        filled: true,
        contentPadding: EdgeInsets.symmetric(
            vertical: isMobile ? 12 : 14,
            horizontal: 12
        ),
        labelStyle: TextStyle(
            fontSize: isMobile ? 12 : 14,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      keyboardType: isNumber
          ? TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,

      style: TextStyle(
          fontSize: isMobile ? 14 : 16,
          fontWeight: FontWeight.w500),
      inputFormatters: isNumber
          ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))]
          : null,
    );
  }

}



