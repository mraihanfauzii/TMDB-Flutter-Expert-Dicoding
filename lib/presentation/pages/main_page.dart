import 'package:movie/presentation/pages/movie_page.dart';
import 'package:tv/presentation/pages/tv_page.dart';
import 'package:flutter/material.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:ditonton/presentation/pages/about_page.dart';

class MainPage extends StatefulWidget {
  static const ROUTE_NAME = '/main';

  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const MoviePage(), // Halaman Movies
    const HomeTvPage(), // Halaman TV Series
    const WatchlistPage(), // Halaman Watchlist (Movies + TV)
    const AboutPage(), // Halaman About
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Movies'),
          BottomNavigationBarItem(icon: Icon(Icons.tv), label: 'TV Series'),
          BottomNavigationBarItem(
            icon: Icon(Icons.save_alt),
            label: 'Watchlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'About',
          ),
        ],
      ),
    );
  }
}
