class TrelloCardModel {
  TrelloCardModel({
    required this.id,
    required this.title,
    required this.listId,
    required this.boardId,
    required this.createdAt,
    required this.reOrderedAt,
  });

  final String id;
  final String title;
  final String listId;
  final String boardId;
  final DateTime? createdAt;
  final DateTime? reOrderedAt;

  TrelloCardModel copyWith(
          {String? id,
          String? title,
          String? listId,
          DateTime? createdAt,
          DateTime? reOrderedAt}) =>
      TrelloCardModel(
        boardId: boardId,
        id: id ?? this.id,
        title: title ?? this.title,
        listId: listId ?? this.listId,
        createdAt: createdAt ?? this.createdAt,
        reOrderedAt: reOrderedAt ?? this.reOrderedAt,
      );

  factory TrelloCardModel.fromMap(Map<String, dynamic> json) => TrelloCardModel(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        boardId: json["boardId"] == null ? null : json["boardId"],
        listId: json["listId"] == null ? null : json["listId"],
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
        reOrderedAt: json['createdAt'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(json['reOrderedAt']),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "listId": listId,
        "boardId": boardId,
        "reOrderedAt": reOrderedAt?.millisecondsSinceEpoch,
        "createdAt": createdAt?.millisecondsSinceEpoch,
      };
}
