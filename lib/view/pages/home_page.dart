import 'package:resif/components/my_drawer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      drawer: MyDrawer(),
      body: Center(
        child: Text('Welcome to the Home Page!'),
      ),
    );
  }
}
