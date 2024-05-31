part of 'restaurant_bloc.dart';

@immutable
abstract class RestaurantEvent {}

class GetAllRestaurants extends RestaurantEvent {
  List<Object> get props => [];
}

class ShowRestaurantDetails extends RestaurantEvent {
  final Restaurant restaurant;
  ShowRestaurantDetails({required this.restaurant});
  List<Object> get props => [];
}
