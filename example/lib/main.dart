import 'package:example/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Awesome Drawer Bar Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.deepPurpleAccent,
      ),
      home: ChangeNotifierProvider(
        create: (_) => MenuProvider(),
        child: HomeScreen(),
      ),
    );
  }
}
