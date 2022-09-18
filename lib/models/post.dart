

/// Стаття
class Post {
  int id = 0;              // Инкремент
  int userId = 0;          // UID автора статті
  int carId = 0;          // UID автора статті
  String title = '';       // Заголовок
  String body = '';        // Опис статті в rich HTML
  String tags = '';        // Коммментарий
  String image = '';       // Головна картинка
  int mileage = 0;      // Пробіг
  double cost = 0.0;       // Вартість
  DateTime createdAt = DateTime.now(); // Дата створення
  DateTime updatedAt = DateTime.now(); // Дата редагування

  Post();

  Post.fromJsonLaravel(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    userId = json['user_id'] ?? 0;
    carId = json['car_id'] ?? 0;
    title = json['title'] ?? '';
    body = json['body'] ?? '';
    tags = json['tags'] ?? '';
    image = json['image'] ?? '';
    mileage = json['mileage'] ?? 0;
    cost = json['cost'].toDouble() ?? 0.0;
    createdAt = DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String());
    updatedAt = DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String());
  }

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    userId = json['userId'] ?? 0;
    carId = json['carId'] ?? 0;
    title = json['title'] ?? '';
    body = json['body'] ?? '';
    tags = json['tags'] ?? '';
    image = json['image'] ?? '';
    mileage = json['mileage'] ?? 0;
    cost = json['cost'] ?? 0.0;
    createdAt = DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String());
    updatedAt = DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != 0) {
      data['id'] = id;
    }
    data['user_id'] = userId;
    data['car_id'] = carId;
    data['title'] = title;
    data['body'] = body;
    data['tags'] = tags;
    data['image'] = image;
    data['mileage'] = mileage;
    data['cost'] = cost;
    data['created_at'] = createdAt.toIso8601String();
    data['updated_at'] = updatedAt.toIso8601String();
    return data;
  }
}
