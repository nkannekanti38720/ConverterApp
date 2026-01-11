import 'conversion_types.dart';

class Converter {
  // Distance conversions (base unit: meters)
  static double convertDistance(double value, DistanceUnit from, DistanceUnit to) {
    // Convert to meters first
    double inMeters = _toMeters(value, from);
    // Convert from meters to target unit
    return _fromMeters(inMeters, to);
  }

  static double _toMeters(double value, DistanceUnit unit) {
    switch (unit) {
      case DistanceUnit.kilometers:
        return value * 1000;
      case DistanceUnit.meters:
        return value;
      case DistanceUnit.centimeters:
        return value / 100;
      case DistanceUnit.miles:
        return value * 1609.34;
      case DistanceUnit.yards:
        return value * 0.9144;
      case DistanceUnit.feet:
        return value * 0.3048;
      case DistanceUnit.inches:
        return value * 0.0254;
    }
  }

  static double _fromMeters(double meters, DistanceUnit unit) {
    switch (unit) {
      case DistanceUnit.kilometers:
        return meters / 1000;
      case DistanceUnit.meters:
        return meters;
      case DistanceUnit.centimeters:
        return meters * 100;
      case DistanceUnit.miles:
        return meters / 1609.34;
      case DistanceUnit.yards:
        return meters / 0.9144;
      case DistanceUnit.feet:
        return meters / 0.3048;
      case DistanceUnit.inches:
        return meters / 0.0254;
    }
  }

  // Weight conversions (base unit: grams)
  static double convertWeight(double value, WeightUnit from, WeightUnit to) {
    double inGrams = _toGrams(value, from);
    return _fromGrams(inGrams, to);
  }

  static double _toGrams(double value, WeightUnit unit) {
    switch (unit) {
      case WeightUnit.kilograms:
        return value * 1000;
      case WeightUnit.grams:
        return value;
      case WeightUnit.pounds:
        return value * 453.592;
      case WeightUnit.ounces:
        return value * 28.3495;
    }
  }

  static double _fromGrams(double grams, WeightUnit unit) {
    switch (unit) {
      case WeightUnit.kilograms:
        return grams / 1000;
      case WeightUnit.grams:
        return grams;
      case WeightUnit.pounds:
        return grams / 453.592;
      case WeightUnit.ounces:
        return grams / 28.3495;
    }
  }

  // Temperature conversions
  static double convertTemperature(double value, TemperatureUnit from, TemperatureUnit to) {
    if (from == to) return value;

    // Convert to Celsius first
    double inCelsius = _toCelsius(value, from);
    // Convert from Celsius to target unit
    return _fromCelsius(inCelsius, to);
  }

  static double _toCelsius(double value, TemperatureUnit unit) {
    switch (unit) {
      case TemperatureUnit.celsius:
        return value;
      case TemperatureUnit.fahrenheit:
        return (value - 32) * 5 / 9;
      case TemperatureUnit.kelvin:
        return value - 273.15;
    }
  }

  static double _fromCelsius(double celsius, TemperatureUnit unit) {
    switch (unit) {
      case TemperatureUnit.celsius:
        return celsius;
      case TemperatureUnit.fahrenheit:
        return (celsius * 9 / 5) + 32;
      case TemperatureUnit.kelvin:
        return celsius + 273.15;
    }
  }

  // Volume conversions (base unit: milliliters)
  static double convertVolume(double value, VolumeUnit from, VolumeUnit to) {
    double inMilliliters = _toMilliliters(value, from);
    return _fromMilliliters(inMilliliters, to);
  }

  static double _toMilliliters(double value, VolumeUnit unit) {
    switch (unit) {
      case VolumeUnit.liters:
        return value * 1000;
      case VolumeUnit.milliliters:
        return value;
      case VolumeUnit.gallons:
        return value * 3785.41;
      case VolumeUnit.quarts:
        return value * 946.353;
      case VolumeUnit.pints:
        return value * 473.176;
      case VolumeUnit.cups:
        return value * 236.588;
      case VolumeUnit.fluidOunces:
        return value * 29.5735;
    }
  }

  static double _fromMilliliters(double milliliters, VolumeUnit unit) {
    switch (unit) {
      case VolumeUnit.liters:
        return milliliters / 1000;
      case VolumeUnit.milliliters:
        return milliliters;
      case VolumeUnit.gallons:
        return milliliters / 3785.41;
      case VolumeUnit.quarts:
        return milliliters / 946.353;
      case VolumeUnit.pints:
        return milliliters / 473.176;
      case VolumeUnit.cups:
        return milliliters / 236.588;
      case VolumeUnit.fluidOunces:
        return milliliters / 29.5735;
    }
  }
}

