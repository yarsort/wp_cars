

/// Стаття
class Post {
  int id = 0;                     // Инкремент
  int isActive = 0;               // Пометка удаления
  String uid = '';                // UID для 1С и связи с ТЧ
  String uidAuthor = '';          // UID автора статті
  String code = '';               // Код для 1С
  String title = '';              // Заголовок
  String description = '';        // Опис статті в rich HTML
  String comment = '';            // Коммментарий
  String picture = '';            // Головна картинка
  DateTime dateCreated = DateTime.now(); // Дата створення
  DateTime dateEdit = DateTime.now(); // Дата редагування

  Post();

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    isActive = 0;
    uid = json['uid'] ?? '';
    uidAuthor = json['uidAuthor'] ?? '';
    code = json['code'] ?? '';
    title = json['title'] ?? '';
    description = json['description'] ?? '';
    comment = json['comment'] ?? '';
    picture = json['picture'] ?? '';
    dateCreated = DateTime.parse(json['dateCreated'] ?? DateTime.now().toIso8601String());
    dateEdit = DateTime.parse(json['dateEdit'] ?? DateTime.now().toIso8601String());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != 0) {
      data['id'] = id;
    }
    data['isGroup'] = 0;
    data['uid'] = uid;
    data['uidAuthor'] = uidAuthor;
    data['code'] = code;
    data['title'] = title;
    data['description'] = description;
    data['comment'] = comment;
    data['picture'] = picture;
    data['dateCreated'] = dateCreated.toIso8601String();
    data['dateEdit'] = dateEdit.toIso8601String();
    return data;
  }
}
