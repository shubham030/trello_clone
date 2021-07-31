import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trello_clone/models/trello_list_model.dart';
import 'package:trello_clone/screens/homepage/bloc/home_page_bloc.dart';
import 'package:trello_clone/screens/homepage/widgets/trello_list_holder.dart';

double trelloCardHeight = 40;
double trelloCardWidth = 300;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int acceptedData = 0;
  int? selectedIndex;
  int? selectedList;

  final HomePageBloc bloc = HomePageBloc();

  @override
  void initState() {
    super.initState();
    bloc.init();
  }

  bool isDragged = false;
  Offset? dragOffset;

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => bloc,
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder<List<TrelloListModel>>(
            stream: bloc.trelloLists,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.data == null) {
                return Center(child: CircularProgressIndicator());
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...List.generate(
                    snapshot.data!.length,
                    (listIndex) {
                      return TrelloListHolder(
                        model: snapshot.data!.elementAt(listIndex),
                      );
                    },
                  ).toList(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
