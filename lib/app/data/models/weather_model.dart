import 'current_model.dart';
import 'location_model.dart';

class WeatherModel {
  final Location location;
  final Current current;

  WeatherModel({
    required this.location,
    required this.current,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      location: Location.fromJson(json['location']),
      current: Current.fromJson(json['current']),
    );
  }

  String get cityName => location.cityName; // Assuming Location class has a cityName property

  double get temperature => current.temperature; // Assuming Current class has a temperature property

  String get description => current.description; // Assuming Current class has a description property

  Map<String, dynamic> toJson() => {
    'location': location.toJson(),
    'current': current.toJson(),
  };
}
