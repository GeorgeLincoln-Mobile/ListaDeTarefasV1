class Taks {
  String title;
  DateTime dateTime;

  Taks({
    required this.title,
    required this.dateTime,
  });

  Taks.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        dateTime = DateTime.parse(json['dateTime']);

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'dateTime': dateTime.toIso8601String(),
    };
  }
}
