import 'package:sqflite/sqflite.dart';
import 'package:wp_car/db/init_db.dart';
import 'package:wp_car/models/order_customer.dart';

/// Name of table for model
const String tableOrderCustomer = '_DocumentOrderCustomer';
const String tableItemsOrderCustomer = '_DocumentOrderCustomer_VT1'; // Товары

/// Name's of fields of table like in model
class OrderCustomerFields {
  static final List<String> values = [
    id,
    status,
    date,
    uid,
    uidOrganization,
    nameOrganization,
    uidPartner,
    namePartner,
    uidContract,
    nameContract,
    uidPrice,
    namePrice,
    uidWarehouse,
    nameWarehouse,
    uidCurrency,
    nameCurrency,
    uidCashbox,
    nameCashbox,
    sum,
    comment,
    coordinates,
    dateSending,
    datePaying,
    sendYesTo1C,
    sendNoTo1C,
    dateSendingTo1C,
    numberFrom1C,
    countItems,
  ];

  /// Описание названий реквизитов таблицы ДБ в виде строк
  static const String id = 'id'; // Инкремент
  static const String status =
      'status'; // 0 - новый, 1 - отправлено, 2 - удален
  static const String date = 'date'; // Дата создания замовлення
  static const String uid = 'uid'; // UID для 1С и связи с ТЧ
  static const String uidOrganization =
      'uidOrganization'; // Посилання на организацию
  static const String nameOrganization = 'nameOrganization'; // Имя организации
  static const String uidPartner = 'uidPartner'; // Посилання на контрагента
  static const String namePartner = 'namePartner'; // Имя контрагента
  static const String uidContract =
      'uidContract'; // Посилання на договір контрагента
  static const String nameStore = 'nameStore'; // Имя магазина
  static const String uidStore = 'uidStore'; // Посилання на магазин партнера
  static const String nameContract =
      'nameContract'; // Посилання на договір контрагента
  static const String uidPrice =
      'uidPrice'; // Посилання на тип цены номенклатуры продажи контрагенту
  static const String namePrice =
      'namePrice'; // Наименование типа цены номенклатуры продажи контрагенту
  static const String uidWarehouse = 'uidWarehouse'; // Посилання на склад
  static const String nameWarehouse = 'nameWarehouse'; // Наименование склада
  static const String uidCurrency = 'uidCurrency'; // Посилання на валюту
  static const String nameCurrency = 'nameCurrency'; // Наименование валюты
  static const String uidCashbox = 'uidCashbox'; // Посилання на кассу
  static const String nameCashbox = 'nameCashbox'; // Наименование кассы
  static const String sum = 'sum'; // Сума документа
  static const String comment = 'comment'; // Коментар
  static const String coordinates = 'coordinates'; // Координаты
  static const String dateSending =
      'dateSending'; // Дата планируемой відгрузки замовлення
  static const String datePaying =
      'datePaying'; // Дата планируемой оплати замовлення
  static const String sendYesTo1C =
      'sendYesTo1C'; // Булево: "Отправлено в 1С" - для фильтрации в списках
  static const String sendNoTo1C =
      'sendNoTo1C'; // Булево: "Отправлено в 1С" - для фильтрации в списках
  static const String dateSendingTo1C =
      'dateSendingTo1C'; // Дата отправки замовлення в 1С из мобильного устройства
  static const String numberFrom1C = 'numberFrom1C';
  static const String countItems = 'countItems';
}

/// Name's of fields of table like in model
class ItemOrderCustomerFields {
  static final List<String> values = [
    id,
    idOrderCustomer,
    uid,
    name,
    uidCharacteristic,
    nameCharacteristic,
    uidUnit,
    nameUnit,
    count,
    price,
    discount,
    sum,
  ];

  /// Описание названий реквизитов таблицы ДБ в виде строк
  static const String id = 'id'; // Инкремент
  static const String idOrderCustomer =
      'idOrderCustomer'; // Посилання на документ
  static const String uid = 'uid'; // Посилання на товар
  static const String name = 'name'; // Имя товара
  static const String uidCharacteristic =
      'uidCharacteristic'; // Посилання на товар
  static const String nameCharacteristic = 'nameCharacteristic'; // Имя товара
  static const String uidUnit = 'uidUnit'; // Посилання на ед. изм.
  static const String nameUnit = 'nameUnit';
  static const String count = 'count';
  static const String price = 'price';
  static const String discount = 'discount';
  static const String sum = 'sum';
}

///**************************************
/// Creating tables of database
///**************************************

Future createTableOrderCustomer(db) async {
  // Удалим если она существовала до этого
  await db.execute("DROP TABLE IF EXISTS $tableOrderCustomer");

  /// Документ.ЗаказПокупателя
  await db.execute('''
    CREATE TABLE $tableOrderCustomer (    
      ${OrderCustomerFields.id} $idType, 
      ${OrderCustomerFields.status} $integerType,
      ${OrderCustomerFields.date} $textType,
      ${OrderCustomerFields.uid} $textType,
      ${OrderCustomerFields.uidOrganization} $textType,
      ${OrderCustomerFields.nameOrganization} $textType,
      ${OrderCustomerFields.uidPartner} $textType,
      ${OrderCustomerFields.namePartner} $textType,
      ${OrderCustomerFields.uidContract} $textType,
      ${OrderCustomerFields.nameContract} $textType,
      ${OrderCustomerFields.uidStore} $textType,
      ${OrderCustomerFields.nameStore} $textType,  
      ${OrderCustomerFields.uidPrice} $textType,
      ${OrderCustomerFields.namePrice} $textType,
      ${OrderCustomerFields.uidWarehouse} $textType,
      ${OrderCustomerFields.nameWarehouse} $textType,
      ${OrderCustomerFields.uidCurrency} $textType,
      ${OrderCustomerFields.nameCurrency} $textType,
      ${OrderCustomerFields.uidCashbox} $textType,
      ${OrderCustomerFields.nameCashbox} $textType,
      ${OrderCustomerFields.sum} $realType,
      ${OrderCustomerFields.comment} $textType,
      ${OrderCustomerFields.coordinates} $textType,
      ${OrderCustomerFields.dateSending} $textType,
      ${OrderCustomerFields.datePaying} $textType,
      ${OrderCustomerFields.sendYesTo1C} $integerType,
      ${OrderCustomerFields.sendNoTo1C} $integerType,
      ${OrderCustomerFields.dateSendingTo1C} $textType,
      ${OrderCustomerFields.numberFrom1C} $textType,
      ${OrderCustomerFields.countItems} $integerType
      )
    ''');
}

Future createTableItemOrderCustomerV1(db) async {
  // Удалим если она существовала до этого
  await db.execute("DROP TABLE IF EXISTS $tableItemsOrderCustomer");

  await db.execute('''
    CREATE TABLE $tableItemsOrderCustomer (    
      ${ItemOrderCustomerFields.id} $idType,
      ${ItemOrderCustomerFields.idOrderCustomer} $integerType,      
      ${ItemOrderCustomerFields.uid} $textType,
      ${ItemOrderCustomerFields.name} $textType,   
      ${ItemOrderCustomerFields.uidCharacteristic} $textType,
      ${ItemOrderCustomerFields.nameCharacteristic} $textType,   
      ${ItemOrderCustomerFields.uidUnit} $textType,
      ${ItemOrderCustomerFields.nameUnit} $textType,
      ${ItemOrderCustomerFields.count} $realType,
      ${ItemOrderCustomerFields.price} $realType,
      ${ItemOrderCustomerFields.discount} $realType,
      ${ItemOrderCustomerFields.sum} $realType      
      )
    ''');
}

Future createTableItemOrderCustomerV2(db) async {

  // Создамо копію таблиці
  const String tableItemsOrderCustomerTemp = '_DocumentOrderCustomer_VT1_Temp'; // Товары

  await db.execute('''
    CREATE TABLE $tableItemsOrderCustomerTemp (    
      ${ItemOrderCustomerFields.id} $idType,
      ${ItemOrderCustomerFields.idOrderCustomer} $integerType,      
      ${ItemOrderCustomerFields.uid} $textType,
      ${ItemOrderCustomerFields.name} $textType,     
      ${ItemOrderCustomerFields.uidUnit} $textType,
      ${ItemOrderCustomerFields.nameUnit} $textType,
      ${ItemOrderCustomerFields.count} $realType,
      ${ItemOrderCustomerFields.price} $realType,
      ${ItemOrderCustomerFields.discount} $realType,
      ${ItemOrderCustomerFields.sum} $realType      
      )
    ''');

  // Копіюємо дані в тимчасову таблицю
  await db.execute('''INSERT INTO $tableItemsOrderCustomerTemp SELECT 
      ${ItemOrderCustomerFields.id},
      ${ItemOrderCustomerFields.idOrderCustomer},      
      ${ItemOrderCustomerFields.uid},
      ${ItemOrderCustomerFields.name},     
      ${ItemOrderCustomerFields.uidUnit},
      ${ItemOrderCustomerFields.nameUnit},
      ${ItemOrderCustomerFields.count},
      ${ItemOrderCustomerFields.price},
      ${ItemOrderCustomerFields.discount},
      ${ItemOrderCustomerFields.sum} FROM $tableItemsOrderCustomer''');

  // Видалимо таблиц
  await db.execute('DROP TABLE IF EXISTS $tableItemsOrderCustomer');

  // Створимо нову таблицю із новими колонками: ХарактеристикаНоменклатури
  await db.execute('''
    CREATE TABLE $tableItemsOrderCustomer (    
      ${ItemOrderCustomerFields.id} $idType,
      ${ItemOrderCustomerFields.idOrderCustomer} $integerType,      
      ${ItemOrderCustomerFields.uid} $textType,
      ${ItemOrderCustomerFields.name} $textType,
      ${ItemOrderCustomerFields.uidCharacteristic} $textType,
      ${ItemOrderCustomerFields.nameCharacteristic} $textType,            
      ${ItemOrderCustomerFields.uidUnit} $textType,
      ${ItemOrderCustomerFields.nameUnit} $textType,
      ${ItemOrderCustomerFields.count} $realType,
      ${ItemOrderCustomerFields.price} $realType,
      ${ItemOrderCustomerFields.discount} $realType,
      ${ItemOrderCustomerFields.sum} $realType      
      )
    ''');

  // Копіюємо дані з тимчасової таблиці в реальну
  await db.execute('''INSERT INTO $tableItemsOrderCustomer(
      ${ItemOrderCustomerFields.id},
      ${ItemOrderCustomerFields.idOrderCustomer},      
      ${ItemOrderCustomerFields.uid},
      ${ItemOrderCustomerFields.name},            
      ${ItemOrderCustomerFields.uidUnit},
      ${ItemOrderCustomerFields.nameUnit},
      ${ItemOrderCustomerFields.count},
      ${ItemOrderCustomerFields.price},
      ${ItemOrderCustomerFields.discount},
      ${ItemOrderCustomerFields.sum} ) SELECT * FROM $tableItemsOrderCustomerTemp''');

  // Удалим таблицу
  await db.execute('DROP TABLE IF EXISTS $tableItemsOrderCustomerTemp');

}

///**************************************
/// Create
///**************************************

Future<OrderCustomer> dbCreateOrderCustomer(OrderCustomer orderCustomer,
    List<ItemOrderCustomer> itemsOrderCustomer) async {
  final db = await instance.database;
  try {
    await db.transaction((txn) async {
      orderCustomer.id =
          await txn.insert(tableOrderCustomer, orderCustomer.toJson());

      /// Запись ТЧ "Товары"
      for (var itemOrderCustomer in itemsOrderCustomer) {
        itemOrderCustomer.idOrderCustomer = orderCustomer.id;
        await txn.insert(tableItemsOrderCustomer, itemOrderCustomer.toJson());
      }
    });
    return orderCustomer;
  } catch (e) {
    throw Exception('Помилка запису об\'єкту!');
  }
}

Future<OrderCustomer> dbCreateOrderCustomerWithoutItems(
    OrderCustomer orderCustomer) async {
  final db = await instance.database;
  try {
    orderCustomer.id =
        await db.insert(tableOrderCustomer, orderCustomer.toJson());
    return orderCustomer;
  } catch (e) {
    throw Exception('Помилка запису об\'єкту!');
  }
}

Future<ItemOrderCustomer> dbCreateItemOrderCustomer(
    ItemOrderCustomer itemsOrderCustomer) async {
  final db = await instance.database;
  try {
    itemsOrderCustomer.id = await db.insert(
          tableItemsOrderCustomer, itemsOrderCustomer.toJson());
    return itemsOrderCustomer;
  } catch (e) {
    throw Exception('Помилка запису об\'єкту!');
  }
}

///**************************************
/// Update
///**************************************

Future<int> dbUpdateOrderCustomerWithoutItems(
    OrderCustomer orderCustomer) async {
  final db = await instance.database;
  try {
    await db.update(
      tableOrderCustomer,
      orderCustomer.toJson(),
      where: '${OrderCustomerFields.id} = ?',
      whereArgs: [orderCustomer.id],
    );
    return orderCustomer.id;
  } catch (e) {
    throw Exception('Помилка запису об\'єкту!');
  }
}

Future<int> dbUpdateOrderCustomer(OrderCustomer orderCustomer,
    List<ItemOrderCustomer> itemsOrderCustomer) async {
  final db = await instance.database;
  int intOperation = 0;
  try {
    await db.transaction((txn) async {
      intOperation = intOperation +
          await txn.update(
            tableOrderCustomer,
            orderCustomer.toJson(),
            where: '${OrderCustomerFields.id} = ?',
            whereArgs: [orderCustomer.id],
          );

      /// Очистка ТЧ "Товары"
      txn.delete(
        tableItemsOrderCustomer,
        where: '${ItemOrderCustomerFields.idOrderCustomer} = ?',
        whereArgs: [orderCustomer.id],
      );
      intOperation = intOperation + 1;

      /// Добавление ТЧ "Товары"
      for (var itemOrderCustomer in itemsOrderCustomer) {
        itemOrderCustomer.idOrderCustomer = orderCustomer.id;
        txn.insert(tableItemsOrderCustomer, itemOrderCustomer.toJson());
        intOperation = intOperation + 1;
      }
    });
    return intOperation;
  } catch (e) {
    throw Exception('Помилка запису об\'єкту!');
  }
}

///**************************************
/// Delete
///**************************************

Future<int> dbDeleteOrderCustomer(int id) async {
  final db = await instance.database;
  try {
    await db.transaction((txn) async {
      txn.delete(
        tableOrderCustomer,
        where: '${OrderCustomerFields.id} = ?',
        whereArgs: [id],
      );
      txn.delete(
        tableItemsOrderCustomer,
        where: '${ItemOrderCustomerFields.idOrderCustomer} = ?',
        whereArgs: [id],
      );
    });
    return 1;
  } catch (e) {
    throw Exception('Помилка удаления объекта с ID: $id!');
  }
}

Future<int> dbDeleteAllOrderCustomer() async {
  final db = await instance.database;
  return await db.delete(
    tableOrderCustomer,
  );
}

Future<int> dbDeleteAllItemsOrderCustomer() async {
  final db = await instance.database;
  return await db.delete(
    tableItemsOrderCustomer,
  );
}

///**************************************
/// Read
///**************************************

Future<OrderCustomer> dbReadOrderCustomer(int id) async {
  final db = await instance.database;
  final maps = await db.query(
    tableOrderCustomer,
    columns: OrderCustomerFields.values,
    where: '${OrderCustomerFields.id} = ?',
    whereArgs: [id],
  );

  if (maps.isNotEmpty) {
    return OrderCustomer.fromJson(maps.first);
  } else {
    return OrderCustomer();
  }
}

Future<List<OrderCustomer>> dbReadOrderCustomerUIDPartner(
    String uidPartner) async {
  final db = await instance.database;
  final result = await db.query(
    tableOrderCustomer,
    columns: OrderCustomerFields.values,
    where: '${OrderCustomerFields.uidPartner} = ?',
    whereArgs: [uidPartner],
  );

  return result.map((json) => OrderCustomer.fromJson(json)).toList();
}

Future<OrderCustomer> dbReadOrderCustomerUID(String uid) async {
  final db = await instance.database;
  final maps = await db.query(
    tableOrderCustomer,
    columns: OrderCustomerFields.values,
    where: '${OrderCustomerFields.uid} = ?',
    whereArgs: [uid],
  );

  if (maps.isNotEmpty) {
    return OrderCustomer.fromJson(maps.first);
  } else {
    return OrderCustomer();
  }
}

Future<List<ItemOrderCustomer>> dbReadAllItemsOrderCustomer() async {
  final db = await instance.database;
  const orderBy = '${ItemOrderCustomerFields.name} ASC';
  final result = await db.query(tableItemsOrderCustomer, orderBy: orderBy);

  return result.map((json) => ItemOrderCustomer.fromJson(json)).toList();
}

Future<List<ItemOrderCustomer>> dbReadItemsOrderCustomer(
    int idOrderCustomer) async {
  final db = await instance.database;
  const orderBy = '${ItemOrderCustomerFields.name} ASC';
  final result = await db.query(tableItemsOrderCustomer,
      where: '${ItemOrderCustomerFields.idOrderCustomer} = ?',
      whereArgs: [idOrderCustomer],
      orderBy: orderBy);

  return result.map((json) => ItemOrderCustomer.fromJson(json)).toList();
}

Future<List<OrderCustomer>> dbReadAllOrderCustomer() async {
  final db = await instance.database;
  String orderBy = '${OrderCustomerFields.date} DESC';
  final result = await db.query(tableOrderCustomer, orderBy: orderBy);

  return result.map((json) => OrderCustomer.fromJson(json)).toList();
}

Future<List<OrderCustomer>> dbReadAllNewOrderCustomer() async {
  final db = await instance.database;
  String orderBy = '${OrderCustomerFields.date} DESC';
  final result = await db.query(tableOrderCustomer,
      where: '${OrderCustomerFields.status} = ?',
      whereArgs: [1],
      orderBy: orderBy);

  return result.map((json) => OrderCustomer.fromJson(json)).toList();
}

Future<List<OrderCustomer>> dbReadAllSendOrderCustomer() async {
  final db = await instance.database;
  String orderBy = '${OrderCustomerFields.date} DESC';
  final result = await db.query(tableOrderCustomer,
      where: '${OrderCustomerFields.status} = ?',
      whereArgs: [2],
      orderBy: orderBy);

  return result.map((json) => OrderCustomer.fromJson(json)).toList();
}

Future<List<OrderCustomer>> dbReadAllTrashOrderCustomer() async {
  final db = await instance.database;
  String orderBy = '${OrderCustomerFields.date} DESC';
  final result = await db.query(tableOrderCustomer,
      where: '${OrderCustomerFields.status} = ?',
      whereArgs: [3],
      orderBy: orderBy);

  return result.map((json) => OrderCustomer.fromJson(json)).toList();
}

Future<List<OrderCustomer>> dbReadAllSendOrderCustomerWithoutNumbers() async {
  final db = await instance.database;
  String orderBy = '${OrderCustomerFields.date} DESC';
  final result = await db.query(tableOrderCustomer,
      where:
          '${OrderCustomerFields.status} = ? AND ${OrderCustomerFields.numberFrom1C} = ?',
      whereArgs: [2, ''],
      orderBy: orderBy);

  return result.map((json) => OrderCustomer.fromJson(json)).toList();
}

///**************************************
/// Get
///**************************************

Future<int> dbGetCountOrderCustomer() async {
  final db = await instance.database;
  var result = Sqflite.firstIntValue(
      await db.rawQuery("SELECT COUNT (*) FROM $tableOrderCustomer"));
  return result ?? 0;
}

Future<int> dbGetCountNewOrderCustomer() async {
  final db = await instance.database;
  final result = await db.query(tableOrderCustomer,
      where: '${OrderCustomerFields.status} = ?', whereArgs: [1]);
  return result.map((json) => OrderCustomer.fromJson(json)).toList().length;
}

Future<int> dbGetCountSendOrderCustomer() async {
  final db = await instance.database;
  final result = await db.query(tableOrderCustomer,
      where: '${OrderCustomerFields.status} = ?', whereArgs: [2]);
  return result.map((json) => OrderCustomer.fromJson(json)).toList().length;
}

Future<int> dbGetCountTrashOrderCustomer() async {
  final db = await instance.database;
  final result = await db.query(tableOrderCustomer,
      where: '${OrderCustomerFields.status} = ?', whereArgs: [3]);
  return result.map((json) => OrderCustomer.fromJson(json)).toList().length;
}

Future<double> dbGetSumNewOrderCustomer() async {
  final db = await instance.database;

  final result = await db.rawQuery("SELECT "
      "${OrderCustomerFields.uidPartner} AS uidPartner, "
      "SUM(${OrderCustomerFields.sum}) AS sum "
      "FROM $tableOrderCustomer "
      "WHERE "
      "${OrderCustomerFields.status} = 1 "
      "GROUP BY ${OrderCustomerFields.uidPartner};");
  List<OrderCustomer> listDocs =
      result.map((json) => OrderCustomer.fromJson(json)).toList();

  double sum = 0.0;
  for (var item in listDocs) {
    sum = sum + item.sum;
  }
  return sum;
}

Future<double> dbGetSumSendOrderCustomer() async {
  final db = await instance.database;

  final result = await db.rawQuery("SELECT "
      "${OrderCustomerFields.uidPartner} AS uidPartner, "
      "SUM(${OrderCustomerFields.sum}) AS sum "
      "FROM $tableOrderCustomer "
      "WHERE "
      "${OrderCustomerFields.status} = 2 "
      "GROUP BY ${OrderCustomerFields.uidPartner};");
  List<OrderCustomer> listDocs =
      result.map((json) => OrderCustomer.fromJson(json)).toList();

  double sum = 0.0;
  for (var item in listDocs) {
    sum = sum + item.sum;
  }
  return sum;
}

Future<double> dbGetSumTrashOrderCustomer() async {
  final db = await instance.database;

  final result = await db.rawQuery("SELECT "
      "${OrderCustomerFields.uidPartner} AS uidPartner, "
      "SUM(${OrderCustomerFields.sum}) AS sum "
      "FROM $tableOrderCustomer "
      "WHERE "
      "${OrderCustomerFields.status} = 1 "
      "GROUP BY ${OrderCustomerFields.uidPartner};");
  List<OrderCustomer> listDocs =
      result.map((json) => OrderCustomer.fromJson(json)).toList();

  double sum = 0.0;
  for (var item in listDocs) {
    sum = sum + item.sum;
  }
  return sum;
}
