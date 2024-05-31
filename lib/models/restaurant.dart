// To parse this JSON data, do
//
//     final restaurantData = restaurantDataFromJson(jsonString);

import 'dart:convert';

import 'location.dart';

Restaurant restaurantDataFromJson(String str) => Restaurant.fromJson(json.decode(str));

String restaurantDataToJson(Restaurant data) => json.encode(data.toJson());

class Restaurant {
  Restaurant(
      {this.id,
      this.name,
      this.url,
      this.location,
      this.averageCostForTwo,
      this.priceRange,
      this.currency,
      this.allReviewsCount,
      this.phoneNumbers,
      this.distance = 0});

  String? id;
  String? name;
  String? url;
  Location? location;
  int? averageCostForTwo;
  int? priceRange;
  String? currency;
  int? allReviewsCount;
  String? phoneNumbers;
  double distance = 0;

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        id: json["id"],
        name: json["name"],
        url: json["url"],
        location: Location.fromJson(json["location"]),
        averageCostForTwo: json["average_cost_for_two"],
        priceRange: json["price_range"],
        currency: json["currency"],
        allReviewsCount: json["all_reviews_count"],
        phoneNumbers: json["phone_numbers"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "url": url,
        "location": location!.toJson(),
        "average_cost_for_two": averageCostForTwo,
        "price_range": priceRange,
        "currency": currency,
        "all_reviews_count": allReviewsCount,
        "phone_numbers": phoneNumbers,
      };
}
