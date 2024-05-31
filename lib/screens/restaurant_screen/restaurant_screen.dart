import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/bloc/restaurant_bloc.dart';
import 'package:restaurant_app/models/restaurant.dart';
import 'package:restaurant_app/screens/map_screen/map_screen.dart';
import 'package:restaurant_app/services/api.dart';

import 'componens/list_screeen_components.dart';

class RestaurantListScreen extends StatefulWidget {
  const RestaurantListScreen({Key? key}) : super(key: key);

  @override
  State<RestaurantListScreen> createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  RestaurantBloc? bloc;

  @override
  void initState() {
    bloc = BlocProvider.of<RestaurantBloc>(context);
    bloc!.add(GetAllRestaurants());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Restaurants"),
        actions: [
          IconButton(
            onPressed: () async {
              List<Restaurant> restaurants = await myApi.getAllRestaurantsSortedByDistance();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RestaurantMapScreen(
                      restaurants: restaurants,
                    ),
                  ));
            },
            icon: const Icon(
              Icons.map_outlined,
              size: 30,
            ),
          )
        ],
      ),
      body: BlocBuilder<RestaurantBloc, RestaurantState>(
        builder: (context, state) {
          if (state is RestaurantLoadingState) {
            return buildLoading();
          } else if (state is ShowRestaurantListState) {
            return buildListScreen(state.restaurants, bloc!);
          } else {
            return buildError("Something went wrong...");
          }
        },
      ),
    );
  }
}
