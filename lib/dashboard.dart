
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:eaglemachinesadminmain/clients.dart';
import 'package:eaglemachinesadminmain/payments.dart';
import 'package:flutter/material.dart';

import 'Maindashboard.dart';
import 'drivers.dart';
import 'machines.dart';
import 'orders.dart';


class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 2; // Set the initial index to 2 for the "Home" icon
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {


    List<Widget> _pages = [
      Machines(),
      Clients(),
      dashboard(),
      Drivers(),
      Orders(),
      Payments(),


    ];

    List<Color> _iconColors = [
      Colors.green, // About
      Colors.green, // Media
      Colors.green, // Home
      Colors.green, // Contact
      Colors.green, // Home
      Colors.green,
    ];

    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _page,
        items: [

          CurvedNavigationBarItem(
            child: Icon(Icons.bus_alert_outlined,color: _iconColors[0]),
            label: 'Machines',
          ),

          CurvedNavigationBarItem(
            child: Icon(Icons.person,color: _iconColors[0]),
            label: 'Client',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.dashboard_outlined , color: _iconColors[0],),
            label: 'Dashboard',
          ),

          CurvedNavigationBarItem(
            child: Icon(Icons.person,color: _iconColors[0]),
            label: 'Drivers',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.electric_bolt,color: _iconColors[0]),
            label: 'Orders',
          ),

          CurvedNavigationBarItem(
            child: Icon(Icons.monetization_on_outlined,color: _iconColors[0]),
            label: 'Bills',
          ),



        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _page = index;
            _iconColors = List.generate(5, (i) => i == index ? Colors.green : Colors.grey);
          });
        },
        letIndexChange: (index) => true,
      ),
      body:  _pages[_page],
    );
  }
}





