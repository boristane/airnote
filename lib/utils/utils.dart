import 'package:airnote/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

class AirnoteUtils {
  static Widget getIcon({DateTime date, Color color}) {
    color = color ?? AirnoteColors.white.withOpacity(0.7);
    final hour = date.hour;
    if (hour <= 9) {
      return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Icon(
          WeatherIcons.sunrise,
          size: 17,
          color: color,
        ),
      );
    }
    if (hour <= 18) {
      return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Icon(
          WeatherIcons.day_sunny,
          size: 17,
          color: color,
        ),
      );
    }
    if (hour <= 20) {
      return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Icon(
          WeatherIcons.sunset,
          size: 17,
          color: color,
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: Icon(
        WeatherIcons.night_clear,
        size: 20,
        color: color,
      ),
    );
  }
}
