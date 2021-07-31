import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trello_clone/screens/homepage/bloc/drag_updates.dart';
import 'package:trello_clone/screens/homepage/views/home_page.dart';

class TrelloCloneApp extends StatelessWidget {
  const TrelloCloneApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DragUpdatesBloc>(
          create: (context) => DragUpdatesBloc(),
          dispose: (_, b) => b.dispose(),
        ),
      ],
      child: MaterialApp(
        home: HomePage(),
      ),
    );
  }
}
