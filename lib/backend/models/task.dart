class Task {
  String _title;
  String _description;
  final List<int> assignes;

  Task(this._title, this._description, this.assignes);

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }
}
