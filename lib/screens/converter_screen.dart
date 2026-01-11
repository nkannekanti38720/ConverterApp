import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/conversion_types.dart';
import '../models/converter.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  ConversionCategory _selectedCategory = ConversionCategory.distance;
  String _inputValue = '';
  String _resultText = '';
  late TextEditingController _inputController;
  bool _hasConverted = false;
  
  // Selected units for each category
  DistanceUnit _fromDistance = DistanceUnit.meters;
  DistanceUnit _toDistance = DistanceUnit.feet;
  WeightUnit _fromWeight = WeightUnit.pounds;
  WeightUnit _toWeight = WeightUnit.kilograms;
  TemperatureUnit _fromTemperature = TemperatureUnit.fahrenheit;
  TemperatureUnit _toTemperature = TemperatureUnit.celsius;
  VolumeUnit _fromVolume = VolumeUnit.gallons;
  VolumeUnit _toVolume = VolumeUnit.liters;

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _performConversion() {
    if (_inputValue.isEmpty) {
      setState(() {
        _resultText = '';
        _hasConverted = false;
      });
      return;
    }

    try {
      final input = double.parse(_inputValue);
      double result;
      String fromUnitName;
      String toUnitName;

      switch (_selectedCategory) {
        case ConversionCategory.distance:
          result = Converter.convertDistance(input, _fromDistance, _toDistance);
          fromUnitName = _getDistanceUnitName(_fromDistance);
          toUnitName = _getDistanceUnitName(_toDistance);
          break;
        case ConversionCategory.weight:
          result = Converter.convertWeight(input, _fromWeight, _toWeight);
          fromUnitName = _getWeightUnitName(_fromWeight);
          toUnitName = _getWeightUnitName(_toWeight);
          break;
        case ConversionCategory.temperature:
          result = Converter.convertTemperature(input, _fromTemperature, _toTemperature);
          fromUnitName = _getTemperatureUnitName(_fromTemperature);
          toUnitName = _getTemperatureUnitName(_toTemperature);
          break;
        case ConversionCategory.volume:
          result = Converter.convertVolume(input, _fromVolume, _toVolume);
          fromUnitName = _getVolumeUnitName(_fromVolume);
          toUnitName = _getVolumeUnitName(_toVolume);
          break;
      }

      // Format result to match image format: "100.0 meters are 328.084 feet"
      String inputFormatted = input.toStringAsFixed(1);
      String resultFormatted = result.toStringAsFixed(3);
      
      setState(() {
        _resultText = '$inputFormatted $fromUnitName are $resultFormatted $toUnitName';
        _hasConverted = true;
      });
    } catch (e) {
      setState(() {
        _resultText = 'Invalid input';
        _hasConverted = false;
      });
    }
  }

  String _getDistanceUnitName(DistanceUnit unit) {
    switch (unit) {
      case DistanceUnit.kilometers:
        return 'kilometers';
      case DistanceUnit.meters:
        return 'meters';
      case DistanceUnit.centimeters:
        return 'centimeters';
      case DistanceUnit.miles:
        return 'miles';
      case DistanceUnit.yards:
        return 'yards';
      case DistanceUnit.feet:
        return 'feet';
      case DistanceUnit.inches:
        return 'inches';
    }
  }

  String _getWeightUnitName(WeightUnit unit) {
    switch (unit) {
      case WeightUnit.kilograms:
        return 'kilograms';
      case WeightUnit.grams:
        return 'grams';
      case WeightUnit.pounds:
        return 'pounds';
      case WeightUnit.ounces:
        return 'ounces';
    }
  }

  String _getTemperatureUnitName(TemperatureUnit unit) {
    switch (unit) {
      case TemperatureUnit.celsius:
        return 'celsius';
      case TemperatureUnit.fahrenheit:
        return 'fahrenheit';
      case TemperatureUnit.kelvin:
        return 'kelvin';
    }
  }

  String _getVolumeUnitName(VolumeUnit unit) {
    switch (unit) {
      case VolumeUnit.liters:
        return 'liters';
      case VolumeUnit.milliliters:
        return 'milliliters';
      case VolumeUnit.gallons:
        return 'gallons';
      case VolumeUnit.quarts:
        return 'quarts';
      case VolumeUnit.pints:
        return 'pints';
      case VolumeUnit.cups:
        return 'cups';
      case VolumeUnit.fluidOunces:
        return 'fluid ounces';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Measures Converter',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // Show category selection dialog or menu
              _showCategoryDialog();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Value label and input
            const Text(
              'Value',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _inputController,
              style: const TextStyle(fontSize: 16),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
              ],
              onChanged: (value) {
                setState(() {
                  _inputValue = value;
                  _hasConverted = false;
                });
              },
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // From label and dropdown
            const Text(
              'From',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            _buildFromUnitDropdown(),
            
            const SizedBox(height: 24),
            
            // To label and dropdown
            const Text(
              'To',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            _buildToUnitDropdown(),
            
            const SizedBox(height: 32),
            
            // Convert button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _performConversion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Convert',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Result text
            if (_hasConverted && _resultText.isNotEmpty)
              Text(
                _resultText,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showCategoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Conversion Type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.straighten),
                title: const Text('Distance'),
                selected: _selectedCategory == ConversionCategory.distance,
                onTap: () {
                  setState(() {
                    _selectedCategory = ConversionCategory.distance;
                    _fromDistance = DistanceUnit.meters;
                    _toDistance = DistanceUnit.feet;
                    _inputValue = '';
                    _resultText = '';
                    _hasConverted = false;
                    _inputController.clear();
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.scale),
                title: const Text('Weight'),
                selected: _selectedCategory == ConversionCategory.weight,
                onTap: () {
                  setState(() {
                    _selectedCategory = ConversionCategory.weight;
                    _fromWeight = WeightUnit.pounds;
                    _toWeight = WeightUnit.kilograms;
                    _inputValue = '';
                    _resultText = '';
                    _hasConverted = false;
                    _inputController.clear();
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.thermostat),
                title: const Text('Temperature'),
                selected: _selectedCategory == ConversionCategory.temperature,
                onTap: () {
                  setState(() {
                    _selectedCategory = ConversionCategory.temperature;
                    _fromTemperature = TemperatureUnit.fahrenheit;
                    _toTemperature = TemperatureUnit.celsius;
                    _inputValue = '';
                    _resultText = '';
                    _hasConverted = false;
                    _inputController.clear();
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.water_drop),
                title: const Text('Volume'),
                selected: _selectedCategory == ConversionCategory.volume,
                onTap: () {
                  setState(() {
                    _selectedCategory = ConversionCategory.volume;
                    _fromVolume = VolumeUnit.gallons;
                    _toVolume = VolumeUnit.liters;
                    _inputValue = '';
                    _resultText = '';
                    _hasConverted = false;
                    _inputController.clear();
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFromUnitDropdown() {
    switch (_selectedCategory) {
      case ConversionCategory.distance:
        return DropdownButtonFormField<DistanceUnit>(
          value: _fromDistance,
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2.0),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2.0),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 8),
          ),
          dropdownColor: Colors.white,
          style: const TextStyle(color: Colors.blue, fontSize: 16),
          items: DistanceUnit.values.map((unit) {
            return DropdownMenuItem(
              value: unit,
              child: Text(_getDistanceUnitName(unit)),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _fromDistance = value;
                _hasConverted = false;
              });
            }
          },
        );
      case ConversionCategory.weight:
        return DropdownButtonFormField<WeightUnit>(
          value: _fromWeight,
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2.0),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2.0),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 8),
          ),
          dropdownColor: Colors.white,
          style: const TextStyle(color: Colors.blue, fontSize: 16),
          items: WeightUnit.values.map((unit) {
            return DropdownMenuItem(
              value: unit,
              child: Text(_getWeightUnitName(unit)),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _fromWeight = value;
                _hasConverted = false;
              });
            }
          },
        );
      case ConversionCategory.temperature:
        return DropdownButtonFormField<TemperatureUnit>(
          value: _fromTemperature,
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2.0),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2.0),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 8),
          ),
          dropdownColor: Colors.white,
          style: const TextStyle(color: Colors.blue, fontSize: 16),
          items: TemperatureUnit.values.map((unit) {
            return DropdownMenuItem(
              value: unit,
              child: Text(_getTemperatureUnitName(unit)),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _fromTemperature = value;
                _hasConverted = false;
              });
            }
          },
        );
      case ConversionCategory.volume:
        return DropdownButtonFormField<VolumeUnit>(
          value: _fromVolume,
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2.0),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2.0),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 8),
          ),
          dropdownColor: Colors.white,
          style: const TextStyle(color: Colors.blue, fontSize: 16),
          items: VolumeUnit.values.map((unit) {
            return DropdownMenuItem(
              value: unit,
              child: Text(_getVolumeUnitName(unit)),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _fromVolume = value;
                _hasConverted = false;
              });
            }
          },
        );
    }
  }

  Widget _buildToUnitDropdown() {
    switch (_selectedCategory) {
      case ConversionCategory.distance:
        return DropdownButtonFormField<DistanceUnit>(
          value: _toDistance,
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2.0),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2.0),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 8),
          ),
          dropdownColor: Colors.white,
          style: const TextStyle(color: Colors.blue, fontSize: 16),
          items: DistanceUnit.values.map((unit) {
            return DropdownMenuItem(
              value: unit,
              child: Text(_getDistanceUnitName(unit)),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _toDistance = value;
                _hasConverted = false;
              });
            }
          },
        );
      case ConversionCategory.weight:
        return DropdownButtonFormField<WeightUnit>(
          value: _toWeight,
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2.0),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2.0),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 8),
          ),
          dropdownColor: Colors.white,
          style: const TextStyle(color: Colors.blue, fontSize: 16),
          items: WeightUnit.values.map((unit) {
            return DropdownMenuItem(
              value: unit,
              child: Text(_getWeightUnitName(unit)),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _toWeight = value;
                _hasConverted = false;
              });
            }
          },
        );
      case ConversionCategory.temperature:
        return DropdownButtonFormField<TemperatureUnit>(
          value: _toTemperature,
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2.0),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2.0),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 8),
          ),
          dropdownColor: Colors.white,
          style: const TextStyle(color: Colors.blue, fontSize: 16),
          items: TemperatureUnit.values.map((unit) {
            return DropdownMenuItem(
              value: unit,
              child: Text(_getTemperatureUnitName(unit)),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _toTemperature = value;
                _hasConverted = false;
              });
            }
          },
        );
      case ConversionCategory.volume:
        return DropdownButtonFormField<VolumeUnit>(
          value: _toVolume,
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2.0),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2.0),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 8),
          ),
          dropdownColor: Colors.white,
          style: const TextStyle(color: Colors.blue, fontSize: 16),
          items: VolumeUnit.values.map((unit) {
            return DropdownMenuItem(
              value: unit,
              child: Text(_getVolumeUnitName(unit)),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _toVolume = value;
                _hasConverted = false;
              });
            }
          },
        );
    }
  }
}
