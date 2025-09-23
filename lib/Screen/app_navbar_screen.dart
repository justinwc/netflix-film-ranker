import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:netflix_clone/Screen/hot_news.dart';
import 'package:netflix_clone/Screen/my_netflix.dart';
import 'package:netflix_clone/Screen/netflix_home_screen.dart';
import 'package:netflix_clone/Screen/search_screen.dart';

class AppNavbarScreen extends StatelessWidget {
  const AppNavbarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        bottomNavigationBar: Container(
          color: Colors.black,
          height: 70,
          child: TabBar(
            tabs: [
              Tab(icon: Icon(Iconsax.home5), text: "Home"),
              Tab(icon: Icon(Iconsax.search_normal), text: "Search"),
              Tab(
                icon: ClipRRect(
                  //borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/user-icon.jpg',
                    width: 24,
                    height: 24,
                    fit: BoxFit.cover,
                  ),
                ),
                text: "My Netflix",
              ),
            ],
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.white,
            indicatorColor: Colors.transparent,
          ),
        ),
        body: TabBarView(
          children: [NetflixHomeScreen(), SearchScreen(), MyNetflix()],
        ),
      ),
    );
  }
}
