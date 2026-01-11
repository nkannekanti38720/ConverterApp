enum ConversionCategory {
  distance,
  weight,
  temperature,
  volume,
}

enum DistanceUnit {
  kilometers('Kilometers', 'km'),
  meters('Meters', 'm'),
  centimeters('Centimeters', 'cm'),
  miles('Miles', 'mi'),
  yards('Yards', 'yd'),
  feet('Feet', 'ft'),
  inches('Inches', 'in');

  const DistanceUnit(this.label, this.abbreviation);
  final String label;
  final String abbreviation;
}

enum WeightUnit {
  kilograms('Kilograms', 'kg'),
  grams('Grams', 'g'),
  pounds('Pounds', 'lb'),
  ounces('Ounces', 'oz');

  const WeightUnit(this.label, this.abbreviation);
  final String label;
  final String abbreviation;
}

enum TemperatureUnit {
  celsius('Celsius', '°C'),
  fahrenheit('Fahrenheit', '°F'),
  kelvin('Kelvin', 'K');

  const TemperatureUnit(this.label, this.abbreviation);
  final String label;
  final String abbreviation;
}

enum VolumeUnit {
  liters('Liters', 'L'),
  milliliters('Milliliters', 'mL'),
  gallons('Gallons', 'gal'),
  quarts('Quarts', 'qt'),
  pints('Pints', 'pt'),
  cups('Cups', 'cup'),
  fluidOunces('Fluid Ounces', 'fl oz');

  const VolumeUnit(this.label, this.abbreviation);
  final String label;
  final String abbreviation;
}

