class Config {
  static final Config _singleton = Config._internal();
  late String userId;
  late String boardId;

  factory Config() {
    return _singleton;
  }

  Config._internal();
}
