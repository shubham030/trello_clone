import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trello_clone/common/images.dart';
import 'package:trello_clone/common/strings.dart';
import 'package:trello_clone/models/trello_list_model.dart';
import 'package:trello_clone/screens/homepage/bloc/drag_updates.dart';
import 'package:trello_clone/screens/homepage/bloc/home_page_bloc.dart';
import 'package:trello_clone/screens/homepage/widgets/card_title_input_widget.dart';
import 'package:trello_clone/screens/homepage/widgets/home_page_app_bar.dart';
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
    return MultiProvider(
      providers: [
        Provider<DragUpdatesBloc>(
          create: (context) => DragUpdatesBloc(),
          dispose: (_, b) => b.dispose(),
        ),
        Provider<HomePageBloc>(
          create: (_) => bloc,
          dispose: (_, b) => b.dispose(),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey[350],
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              bgImage,
              fit: BoxFit.cover,
            ),
            Container(
              height: MediaQuery.of(context).size.height - 30,
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder<List<TrelloListModel>>(
                stream: bloc.trelloLists,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.data == null) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HomePageAppBar(),
                      SizedBox(
                        height: 30,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
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
                            Container(
                              constraints: BoxConstraints(
                                minHeight: trelloCardHeight,
                                maxHeight: trelloCardHeight + 56,
                              ),
                              width: trelloCardWidth,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: CardTitleInput(
                                onStart: () {},
                                onDataSubmit: (value) {
                                  bloc.addNewList(value);
                                },
                                maxLines: 1,
                                buttonText1: Strings.addAnotherList,
                                buttonText2: Strings.addList,
                                hint: Strings.enterListTitle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
