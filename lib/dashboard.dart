
import 'package:eaglemachinesadminmain/clients.dart';
import 'package:eaglemachinesadminmain/payments.dart';
import 'package:flutter/material.dart';

import 'Maindashboard.dart';
import 'drivers.dart';
import 'machines.dart';
import 'orders.dart';





class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    dashboard(),
    Machines(),
    Drivers(),
    Orders(),
    Payments(),
    Clients(),
    Dashboard(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bus_alert_outlined),
            label: 'Machines',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Drivers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.electric_bolt),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Payments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Clients',
          ),


        ],
      ),
    );
  }
}







