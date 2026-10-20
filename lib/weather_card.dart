import 'dart:async';

import 'package:flutter/material.dart';

import 'app_strings.dart';
import 'services/weather_service.dart';
import 'theme.dart';

/// Small "weather now" strip shown on the home screen above the search bar.
/// Refreshes every 15 minutes, when tapped, and when the language changes
/// (so the place name is re-fetched in the new language).
class WeatherCard extends StatefulWidget {
  const WeatherCard({super.key});

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {
  final WeatherService _service = WeatherService();

  WeatherData? _data;
  bool _loading = true;
  bool _failed = false;
  bool _fetching = false;
  String? _language;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(
      const Duration(minutes: 15),
      (_) => _load(silent: true),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final language = AppStrings.of(context).language;

    if (_language != language) {
      final firstLoad = _language == null;
      _language = language;
      _load(silent: !firstLoad);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _load({bool silent = false}) async {
    if (_fetching) return;
    _fetching = true;

    if (!silent && mounted) {
      setState(() {
        _loading = true;
        _failed = false;
      });
    }

    try {
      final data = await _service.fetchCurrentWeather(
        languageCode: AppStrings(_language ?? 'English').localeCode,
      );

      if (!mounted) return;

      setState(() {
        _data = data;
        _loading = false;
        _failed = false;
      });
    } catch (e) {
      debugPrint('Weather error: $e');

      if (!mounted) return;

      setState(() {
        _loading = false;
        _failed = _data == null;
      });
    } finally {
      _fetching = false;
    }
  }

  IconData _iconFor(int code, bool isDay) {
    if (code == 0 || code == 1) {
      return isDay ? Icons.wb_sunny_outlined : Icons.nightlight_outlined;
    }
    if (code == 2) return Icons.cloud_queue;
    if (code == 3) return Icons.cloud_outlined;
    if (code == 45 || code == 48) return Icons.foggy;
    if (code >= 51 && code <= 67) return Icons.water_drop_outlined;
    if ((code >= 71 && code <= 77) || code == 85 || code == 86) {
      return Icons.ac_unit;
    }
    if (code >= 80 && code <= 82) return Icons.water_drop_outlined;
    if (code >= 95) return Icons.thunderstorm_outlined;
    return Icons.wb_cloudy_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardBackgroundColor = isDark ? darkCardColor : cardColor;
    final textColor = isDark ? darkInkColor : inkColor;
    final accentColor = isDark ? darkBrownColor : brownColor;
    final dividerColor = isDark ? darkBorderColor : borderColor;
    final fadedBackgroundColor = isDark ? darkFadedColor : fadedColor;

    Widget content;

    if (_loading && _data == null) {
      content = Row(
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: accentColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              s.loadingWeather,
              style: TextStyle(color: accentColor, fontSize: 12),
            ),
          ),
        ],
      );
    } else if (_failed || _data == null) {
      content = Row(
        children: [
          Icon(Icons.cloud_off_outlined, color: accentColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              s.weatherUnavailable,
              style: TextStyle(color: accentColor, fontSize: 12),
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: Icon(Icons.refresh, size: 20, color: accentColor),
            onPressed: _load,
          ),
        ],
      );
    } else {
      final data = _data!;

      final place =
          data.placeName ??
          (data.usedFallbackLocation ? s.defaultCity : s.currentLocation);

      content = Row(
        children: [
          Container(
            width: 52,
            height: 52,
            color: fadedBackgroundColor,
            child: Icon(
              _iconFor(data.weatherCode, data.isDay),
              size: 30,
              color: accentColor,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 13,
                      color: accentColor,
                    ),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        place,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                          color: accentColor,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 2),

                Row(
                  children: [
                    Text(
                      '${data.temperature.round()}°C',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        s.weatherCondition(data.weatherCode),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 2),

                Text(
                  '${s.feelsLike} ${data.feelsLike.round()}°  •  '
                  '${s.humidity} ${data.humidity}%  •  '
                  '${s.wind} ${data.windSpeed.round()} km/h',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, color: accentColor),
                ),
              ],
            ),
          ),

          IconButton(
            visualDensity: VisualDensity.compact,
            icon: Icon(Icons.refresh, size: 20, color: accentColor),
            onPressed: _load,
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardBackgroundColor,
          border: Border.all(color: dividerColor),
        ),
        child: content,
      ),
    );
  }
}