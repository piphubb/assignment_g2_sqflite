class Item {
  int? id;
  String? title;
  String? imagePath;

  Item({this.id, this.title, this.imagePath});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imagePath': imagePath,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      title: map['title'],
      imagePath: map['imagePath'],
    );
  }
}