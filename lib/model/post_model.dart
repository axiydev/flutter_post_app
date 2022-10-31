class PostModel {
  String? id;
  String? title;
  String? username;
  String? imageUrl;
  String? publishedDate;
  PostModel(
      {required this.id,
      this.imageUrl,
      required this.title,
      required this.username,
      required this.publishedDate});

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
      id: json['id'],
      imageUrl: json['imageUrl'],
      title: json['title'],
      publishedDate: json['publishedDate'],
      username: json['username']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'imageUrl': imageUrl,
        'title': title,
        'username': username,
        'publishedDate': publishedDate
      };

  PostModel copyWith(
          {String? id,
          String? imageUrl,
          String? username,
          String? title,
          String? publishedDate}) =>
      PostModel(
          id: id ?? this.id,
          imageUrl: imageUrl ?? this.imageUrl,
          title: title ?? this.title,
          publishedDate: publishedDate ?? this.publishedDate,
          username: username ?? this.username);
}
