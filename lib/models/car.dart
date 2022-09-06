
/// Автомобіль
class Car {
  int id = 0;                     // Инкремент
  int isActive = 0;               // Пометка удаления
  String uid = '';                // UID для 1С и связи с ТЧ
  String code = '';               // Код для 1С
  String name = '';               // Имя
  String nickname = '';           // Псевдонім
  String description = '';        // Опис автомобіля
  String yearProduction = '';     // Опис автомобіля
  int mileage = 0;                // Пробег авто
  int rating = 0;                 // Рейтинг авто
  String comment = '';            // Коммментарий
  String picture = '';            // Картинка головна
  DateTime dateEdit = DateTime.now(); // Дата редактирования

  Car();

  Car.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    isActive = 0;
    uid = json['uid'] ?? '';
    code = json['code'] ?? '';
    name = json['name'] ?? '';
    nickname = json['nickname'] ?? '';
    description = json['description'] ?? '';
    yearProduction = json['yearProduction'] ?? '';
    mileage = json['mileage'] ?? 0;
    rating = json['rating'] ?? 0;
    comment = json['comment'] ?? '';
    picture = json['picture'] ?? '';
    dateEdit = DateTime.parse(json['dateEdit'] ?? DateTime.now().toIso8601String());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != 0) {
      data['id'] = id;
    }
    data['isGroup'] = 0;
    data['uid'] = uid;
    data['code'] = code;
    data['name'] = name;
    data['nickname'] = nickname;
    data['description'] = description;
    data['yearProduction'] = yearProduction;
    data['mileage'] = mileage;
    data['rating'] = rating;
    data['comment'] = comment;
    data['picture'] = picture;
    data['dateEdit'] = dateEdit.toIso8601String();
    return data;
  }
}
