import 'package:flutter/material.dart';
import 'package:trello_clone/app.dart';
import 'package:trello_clone/common/config.dart';

void main() {
  Config config = Config();
  config.boardId = '8BcF4xOxy5PgG7x8rZ3u';
  config.userId = '1';
  runApp(TrelloCloneApp());
}
