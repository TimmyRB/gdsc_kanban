class Task {
  final int id;
  String _description;
  String _assignee;
  DateTime _dueDate;

  Task(this.id, this._description, this._assignee, this._dueDate);

  Task.fromJson(Map<String, dynamic> json)
      : _description = json['task_description'],
        _assignee = json['task_assignee'],
        _dueDate = DateTime.parse(json['task_duedate']),
        id = json['id'];

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get assignee => _assignee;

  set assignee(String value) {
    _assignee = value;
  }

  DateTime get dueDate => _dueDate;

  set dueDate(DateTime value) {
    _dueDate = value;
  }

  @override
  String toString() {
    return 'Task{id: $id, description: $_description, assignee: $_assignee, dueDate: ${_dueDate.toString()}}';
  }
}
