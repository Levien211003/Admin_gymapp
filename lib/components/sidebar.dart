import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Admin Menu'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Home'),
            onTap: () {
              Navigator.pushNamed(context, '/');
            },
          ),
          ListTile(
            title: Text('Users'),
            onTap: () {
              Navigator.pushNamed(context, '/users');
            },
          ),
          ListTile(
            title: Text('Plan'),
            onTap: () {
              Navigator.pushNamed(context, '/plans');
            },
          ),
          ListTile(
            title: Text('Nutri'),
            onTap: () {
              Navigator.pushNamed(context, '/nutris');
            },
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
    );
  }
}
