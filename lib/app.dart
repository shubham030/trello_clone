import 'package:flutter/material.dart';
import 'package:trello_clone/screens/homepage/views/home_page.dart';

class TrelloCloneApp extends StatelessWidget {
  const TrelloCloneApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}
