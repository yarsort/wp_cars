
/// Автомобіль
class Car {
  int id = 0;                     // Инкремент
  int typeTransportId = 0;        //
  int carBrandId = 0;             //
  int carModelId = 0;             //
  String uid = '';                // UID для 1С и связи с ТЧ
  String code = '';               // Код для 1С
  String name = '';               // Имя
  String nickname = '';           // Псевдонім
  String description = '';        // Опис автомобіля
  String yearProduction = '';     // Опис автомобіля
  int mileage = 0;                // Пробег авто
  int rating = 0;                 // Рейтинг авто
  String comment = '';            // Коммментарий
  String image = '';            // Картинка головна
  String vinCode = '';                // Имя
  DateTime createdAt = DateTime.now(); // Дата створення
  DateTime editedAt = DateTime.now(); // Дата редагування

  Car();

  Car.fromJsonLaravel(Map<String, dynamic> json) {
    id = json['id'] ?? 0;

    typeTransportId = json['type_transport_id'] ?? 0;
    carBrandId = json['car_brand_id'] ?? 0;
    carModelId = json['car_model_id'] ?? 0;

    uid = json['uid'] ?? '';
    code = json['code'] ?? '';
    name = json['name'] ?? '';
    nickname = json['nickname'] ?? '';
    description = json['description'] ?? '';
    yearProduction = json['year_production'].toString();
    mileage = json['mileage'] ?? 0;
    rating = json['rating'] ?? 0;
    comment = json['comment'] ?? '';
    vinCode = json['vin_code'] ?? '';
    image = json['image'] ?? '';
    createdAt = DateTime.parse(json['created_t'] ?? DateTime.now().toIso8601String());
    editedAt = DateTime.parse(json['edited_at'] ?? DateTime.now().toIso8601String());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != 0) {
      data['id'] = id;
    }

    data['type_transport_id'] = typeTransportId;
    data['car_brand_id'] = carBrandId;
    data['car_model_id'] = carModelId;

    data['uid'] = uid;
    data['code'] = code;
    data['name'] = name;
    data['nickname'] = nickname;
    data['description'] = description;
    data['year_production'] = yearProduction;
    data['mileage'] = mileage;
    data['vin_code'] = vinCode;
    data['image'] = image;
    return data;
  }
}
