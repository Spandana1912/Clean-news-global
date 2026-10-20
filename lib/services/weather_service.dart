import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class WeatherData {
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int weatherCode;
  final bool isDay;

  /// Null when the place name could not be resolved.
  final String? placeName;

  /// True when the device location was unavailable and the default city
  /// was used instead.
  final bool usedFallbackLocation;

  const WeatherData({
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.weatherCode,
    required this.isDay,
    required this.placeName,
    required this.usedFallbackLocation,
  });
}

/// Current weather from Open-Meteo (free, no API key needed).
/// https://open-meteo.com/en/docs
class WeatherService {
  // Fallback location: Coimbatore, Tamil Nadu.
  static const double _fallbackLatitude = 11.0168;
  static const double _fallbackLongitude = 76.9558;

  // Ask for location permission only once per app session so the user is
  // not prompted again every time the weather refreshes.
  static bool _permissionAlreadyRequested = false;

  Future<WeatherData> fetchCurrentWeather({String languageCode = 'en'}) async {
    double latitude = _fallbackLatitude;
    double longitude = _fallbackLongitude;
    bool usedFallback = true;

    final position = await _tryGetPosition();

    if (position != null) {
      latitude = position.latitude;
      longitude = position.longitude;
      usedFallback = false;
    }

    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': '$latitude',
      'longitude': '$longitude',
      'current':
          'temperature_2m,relative_humidity_2m,apparent_temperature,'
          'is_day,weather_code,wind_speed_10m',
      'timezone': 'auto',
    });

    final response = await http.get(uri).timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Weather request failed: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final current = json['current'] as Map<String, dynamic>?;

    if (current == null) {
      throw Exception('Weather response had no current data.');
    }

    String? placeName;

    if (!usedFallback) {
      placeName = await _reverseGeocode(latitude, longitude, languageCode);
    }

    return WeatherData(
      temperature: (current['temperature_2m'] as num).toDouble(),
      feelsLike: (current['apparent_temperature'] as num).toDouble(),
      humidity: (current['relative_humidity_2m'] as num).round(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      weatherCode: (current['weather_code'] as num).toInt(),
      isDay: ((current['is_day'] ?? 1) as num).toInt() == 1,
      placeName: placeName,
      usedFallbackLocation: usedFallback,
    );
  }

  // ------------------------------------------------------------
  // DEVICE LOCATION (optional, falls back silently)
  // ------------------------------------------------------------

  Future<Position?> _tryGetPosition() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return null;

      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied &&
          !_permissionAlreadyRequested) {
        _permissionAlreadyRequested = true;
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 8),
        ),
      );
    } catch (_) {
      return null;
    }
  }

  // ------------------------------------------------------------
  // PLACE NAME (free BigDataCloud client endpoint, no key needed)
  // ------------------------------------------------------------

  Future<String?> _reverseGeocode(
    double latitude,
    double longitude,
    String languageCode,
  ) async {
    try {
      final uri = Uri.https(
        'api.bigdatacloud.net',
        '/data/reverse-geocode-client',
        {
          'latitude': '$latitude',
          'longitude': '$longitude',
          'localityLanguage': languageCode,
        },
      );

      final response = await http.get(uri).timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) return null;

      final json = jsonDecode(response.body) as Map<String, dynamic>;

      final city = (json['city'] ?? '').toString().trim();
      final locality = (json['locality'] ?? '').toString().trim();

      if (city.isNotEmpty) return city;
      if (locality.isNotEmpty) return locality;

      return null;
    } catch (_) {
      return null;
    }
  }
}