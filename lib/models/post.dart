

/// Стаття
class Post {
  int id = 0;                     // Инкремент
  int user_id = 0;          // UID автора статті
  int auto_id = 0;          // UID автора статті
  String title = '';              // Заголовок
  String body = '';        // Опис статті в rich HTML
  String tags = '';            // Коммментарий
  String image = '';            // Головна картинка
  DateTime created_at = DateTime.now(); // Дата створення
  DateTime updated_at = DateTime.now(); // Дата редагування

  Post();

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    user_id = json['user_id'] ?? 0;
    auto_id = json['auto_id'] ?? 0;
    title = json['title'] ?? '';
    body = json['body'] ?? '';
    tags = json['tags'] ?? '';
    image = json['image'] ?? '';
    created_at = DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String());
    updated_at = DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != 0) {
      data['id'] = id;
    }
    data['user_id'] = user_id;
    data['auto_id'] = auto_id;
    data['title'] = title;
    data['body'] = body;
    data['tags'] = tags;
    data['image'] = image;
    data['created_at'] = created_at.toIso8601String();
    data['updated_at'] = updated_at.toIso8601String();
    return data;
  }
}
