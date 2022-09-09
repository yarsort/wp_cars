

/// Повідомлення чату
class Message {
  int id = 0;                     // Инкремент
  String uid = '';                // UID текущего сообщения
  String code = '';               // Код для 1С
  String uidParent = '';          // UID сообщения на которое ответили
  String uidSender = '';          // UID отправителя
  String uidRecipient = '';       // UID получателя
  String message = '';            // Опис статті в rich HTML
  String picture = '';            // Головна картинка
  DateTime dateView = DateTime.now(); // Дата перегляду
  DateTime dateSend = DateTime.now(); // Дата відправки
  DateTime dateCreated = DateTime.now(); // Дата створення
  DateTime dateEdit = DateTime.now(); // Дата редагування

  Message();

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    code = json['code'] ?? '';
    uid = json['uid'] ?? '';
    uidParent = json['uidParent'] ?? '';
    uidSender = json['uidSender'] ?? '';
    uidRecipient = json['uidRecipient'] ?? '';
    message = json['message'] ?? '';
    picture = json['picture'] ?? '';
    dateView = DateTime.parse(json['dateView'] ?? DateTime.now().toIso8601String());
    dateSend = DateTime.parse(json['dateSend'] ?? DateTime.now().toIso8601String());
    dateCreated = DateTime.parse(json['dateCreated'] ?? DateTime.now().toIso8601String());
    dateEdit = DateTime.parse(json['dateEdit'] ?? DateTime.now().toIso8601String());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != 0) {
      data['id'] = id;
    }
    data['code'] = code;
    data['uid'] = uid;
    data['uidParent'] = uidParent;
    data['uidSender'] = uidSender;
    data['uidRecipient'] = uidRecipient;
    data['message'] = message;
    data['picture'] = picture;
    data['dateView'] = dateView.toIso8601String();
    data['dateSend'] = dateSend.toIso8601String();
    data['dateCreated'] = dateCreated.toIso8601String();
    data['dateEdit'] = dateEdit.toIso8601String();
    return data;
  }
}
