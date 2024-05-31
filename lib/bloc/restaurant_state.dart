part of 'restaurant_bloc.dart';

@immutable
abstract class RestaurantState {}

class RestaurantLoadingState extends RestaurantState {
  List<Object> get props => [];
}

class ShowRestaurantListState extends RestaurantState {
  final List<Restaurant> restaurants;
  ShowRestaurantListState({required this.restaurants});
  List<Object> get props => [];
}

class ShowRestaurantDetailState extends RestaurantState {
  final Restaurant restaurant;
  ShowRestaurantDetailState({required this.restaurant});
  List<Object> get props => [];
}

class RestaurantErrorState extends RestaurantState {
  List<Object> get props => [];
}
