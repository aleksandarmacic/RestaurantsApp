import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/bloc/restaurant_bloc.dart';
import 'package:restaurant_app/screens/restaurant_screen/restaurant_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // routes: {
      //   '/list': (context) => RestaurantListScreen(),
      //   '/map': (context) => const RestaurantMapScreen(),
      // },
      debugShowCheckedModeBanner: false,
      title: 'Restaurant Demo app',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: BlocProvider(
        create: (context) => RestaurantBloc(
          RestaurantLoadingState(),
        ),
        child: const RestaurantListScreen(),
      ),
    );
  }
}
