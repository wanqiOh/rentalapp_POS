class NotificationsItem {
  String title;
  String id;
  String content;
  int clicked;
  int sendDateTime;

  NotificationsItem(
      {this.title, this.id, this.content, this.clicked, this.sendDateTime});

  factory NotificationsItem.fromJson(dynamic json) => NotificationsItem(
        title: json['headings']['en'],
        id: json['id'],
        content: json['contents']['en'],
        clicked: json['converted'],
        sendDateTime: json['completed_at'],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'content': content,
        'converted': clicked,
        'completed': sendDateTime,
      };

  @override
  List<Object> get props => [id, title, content, clicked, sendDateTime];
}
