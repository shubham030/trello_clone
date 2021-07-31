import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

class CardTitleInput extends StatefulWidget {
  final String hint;
  final ValueChanged<String> onDataSubmit;
  final VoidCallback onStart;
  final String buttonText1;
  final String buttonText2;
  final int maxLines;
  const CardTitleInput({
    Key? key,
    required this.hint,
    required this.onDataSubmit,
    required this.onStart,
    required this.buttonText1,
    required this.buttonText2,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  _CardTitleInputState createState() => _CardTitleInputState();
}

class _CardTitleInputState extends State<CardTitleInput> {
  TextEditingController _controller = TextEditingController();
  final _showAddCard = BehaviorSubject<bool>.seeded(false);

  @override
  void dispose() {
    _showAddCard.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _showAddCard.stream,
      initialData: false,
      builder: (context, snapshot) {
        if (snapshot.data ?? false) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Card(
                  child: TextField(
                    controller: _controller,
                    maxLines: widget.maxLines,
                    decoration: InputDecoration(
                      hintText: widget.hint,
                      hintStyle: TextStyle(fontSize: 12),
                      contentPadding: const EdgeInsets.all(4.0),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (_controller.text.isNotEmpty) {
                            widget.onDataSubmit(_controller.text);
                            _controller.clear();
                            _showAddCard.add(false);
                          }
                        },
                        child: Text(widget.buttonText2),
                      ),
                      IconButton(
                        splashColor: Colors.transparent,
                        icon: Icon(Icons.close),
                        onPressed: () {
                          _showAddCard.add(false);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                _showAddCard.add(true);
                widget.onStart();
              },
              child: SizedBox(
                height: 30,
                child: Row(
                  children: [
                    Icon(Icons.add),
                    Text(widget.buttonText1),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
