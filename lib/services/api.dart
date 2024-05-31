import 'dart:math';

import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:restaurant_app/models/restaurant.dart';

class DioClient {
  final Dio _dio = Dio();

  final _baseUrl = 'https://cms.dgrp.cz/ios/data.json';

  Future<List<Restaurant>> getAllRestaurantsSortedByDistance() async {
    List<Restaurant> allRestaurants = [];
    Response response = await _dio.get(_baseUrl);
    if (response.statusCode == 200) {
      List restaurants = response.data["restaurants"];
      if (restaurants.isNotEmpty) {
        for (dynamic r in restaurants) {
          final restaurantData = r["restaurant"];
          allRestaurants.add(Restaurant.fromJson(restaurantData));
        }
      }

      // get my current location
      Position myPosition =
          await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      //populate distance
      for (Restaurant res in allRestaurants) {
        double distance = Geolocator.distanceBetween(
            myPosition.latitude,
            myPosition.longitude,
            double.parse(res.location == null ? "0" : res.location!.latitude!.toString()),
            double.parse(res.location == null ? "0" : res.location!.longitude!.toString()));

        res.distance = distance;
      }
      // sort by distance
      allRestaurants.sort((a, b) => a.distance.compareTo(b.distance));
    }
    return allRestaurants;
  }

  getMyPosition() {
    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  double dp(double val, int places) {
    num mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod);
  }
}

DioClient myApi = DioClient();
