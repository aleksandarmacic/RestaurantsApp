import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:restaurant_app/models/restaurant.dart';
import 'package:restaurant_app/services/api.dart';

part 'restaurant_event.dart';
part 'restaurant_state.dart';

class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  RestaurantBloc(RestaurantState initialState) : super(initialState);

  @override
  Stream<RestaurantState> mapEventToState(RestaurantEvent event) async* {
    if (event is GetAllRestaurants) {
      yield RestaurantLoadingState();
      List<Restaurant> allRestaurants = await myApi.getAllRestaurantsSortedByDistance();
      if (allRestaurants.isNotEmpty) {
        yield ShowRestaurantListState(restaurants: allRestaurants);
      }
    } else if (event is ShowRestaurantDetails) {
      yield ShowRestaurantDetailState(restaurant: event.restaurant);
    }
  }
}
