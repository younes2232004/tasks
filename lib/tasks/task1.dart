import 'package:flutter/material.dart';

// Bottom Navigation Example ..
class Task1 extends StatefulWidget {
  const Task1({Key? key}) : super(key: key);

  @override
  State<Task1> createState() => _Task1State();
}

class _Task1State extends State<Task1> {
  // Keep track of the currently selected index
  int _selectedIndex = 0;

  // A list of widgets for each "page"
  static final List<Widget> _widgetOptions = <Widget>[
    Container(
        color: Colors.deepOrange, child: Center(child: Text('Home Page'))),
    Container(
        color: Colors.greenAccent, child: Center(child: Text('Search Page'))),
    Container(
        color: Colors.amberAccent, child: Center(child: Text('Profile Page'))),
  ];

  // Callback when bottom navigation items are tapped
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bottom Navigation Example'),
      ),
      body: Center(
        // Display the currently selected widget
        child: _widgetOptions[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        // Let the BottomNavigationBar know which item is selected
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, // pass the callback here
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
