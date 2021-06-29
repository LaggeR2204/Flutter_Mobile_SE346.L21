import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/MainScreen/pages/NotificationsPage.dart';
import 'package:flutter_app/Screens/MainScreen/pages/ProfilePage.dart';
import 'package:flutter_app/Screens/MainScreen/pages/SearchPage.dart';
import 'package:flutter_app/Screens/MainScreen/pages/TimelinePage.dart';
import 'package:flutter_app/Screens/MainScreen/pages/MessengerPage.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/main.dart';

class NavigationItem {
  const NavigationItem(this.title, this.icon);
  final String title;
  final IconData icon;
}

const List<NavigationItem> allNavigationItems = <NavigationItem>[
  NavigationItem('Home', Icons.home),
  NavigationItem('Search', Icons.search),
  NavigationItem('Message', Icons.chat_bubble),
  NavigationItem('Notification', Icons.notifications),
  NavigationItem('Profile', Icons.person)
];

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: <Widget>[
          TimelinePage(),
          SearchPage(),
          MessengerPage(),
          NotificationsPage(),
          ProfilePage(userId: currentUserModel.id)
        ],
      ),
      // body: IndexedStack(
      //   children: <Widget>[
      //     TimelinePage(),
      //     SearchPage(),
      //     MessengerPage(),
      //     NotificationsPage(),
      //     ProfilePage(userId: currentUserModel.id)
      //   ],
      //   index: _currentIndex,
      // ),
      //body: _listPage[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _pageController.animateToPage(index,
                duration: Duration(milliseconds: 500), curve: Curves.ease);
          });
        },
        items: allNavigationItems.map((NavigationItem navigationItem) {
          return BottomNavigationBarItem(
              icon: Icon(
                navigationItem.icon,
                color: appPrimaryColor,
              ),
              backgroundColor: appBackgroundLightColor,
              title: Text(
                navigationItem.title,
                style: TextStyle(color: appPrimaryColor),
              ));
        }).toList(),
      ),
    );
  }
}
