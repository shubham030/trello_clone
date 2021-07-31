import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trello_clone/common/strings.dart';
import 'package:trello_clone/models/trello_list_model.dart';
import 'package:trello_clone/screens/homepage/bloc/home_page_bloc.dart';
import 'package:trello_clone/screens/homepage/widgets/card_title_input_widget.dart';
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
        backgroundColor: Colors.grey[350],
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1477158340414-06e7a2c10ada?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxjb2xsZWN0aW9uLXBhZ2V8MnwxMTEyODQ1fHxlbnwwfHx8fA%3D%3D&w=1000&q=80',
              fit: BoxFit.cover,
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder<List<TrelloListModel>>(
                stream: bloc.trelloLists,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.data == null) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return SingleChildScrollView(
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
