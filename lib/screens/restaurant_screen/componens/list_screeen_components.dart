import 'package:flutter/material.dart';
import 'package:restaurant_app/bloc/restaurant_bloc.dart';
import 'package:restaurant_app/global_components/components.dart';
import 'package:restaurant_app/models/restaurant.dart';
import 'package:restaurant_app/services/api.dart';

Widget buildLoading() {
  return const Center(
    child: CircularProgressIndicator(),
  );
}

Widget buildError(String text) {
  return Center(
    child: Text(text),
  );
}

Widget buildListScreen(List<Restaurant> restaurants, RestaurantBloc bloc) {
  return ListView.builder(
    itemCount: restaurants.length,
    itemBuilder: (context, index) {
      Restaurant restaurant = restaurants[index];
      return ListTile(
        onTap: () => showAlert(context, restaurant),
        title: Text(
          restaurant.name ?? "",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(myApi.dp(restaurant.distance, 2).toString() + " km away"),
      );
    },
  );
}
