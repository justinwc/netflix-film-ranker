import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:netflix_clone/Screen/splash_screen.dart';
import 'package:netflix_clone/Providers/user_rating_state.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserRatingState(),
      child: MaterialApp(
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
        title: "Netflix Clone",
      ),
    );
  }
}
