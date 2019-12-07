import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';

import 'clientModel.dart';



class DBHelper {
  /// Dabase'imizi ilgili konuma oluşturup, oluşturduğu database'i istediğimizde dönen method
  static Future<Database> database() async {
    // işletim sistemine göre varsayılan database oluşturabileceğimiz konumu alacak
    final dbPath = await getDatabasesPath();


    // Client isminde database table oluşturacak rawSql komutumuzu tutan değişken
    // karışık görünmesin diye buraya yazdım, execute ederken kullanıcaz
    const dbSQL = "CREATE TABLE Client ("
        "id INTEGER PRIMARY KEY,"
        "english_word TEXT UNIQUE,"
        "turkce_kelime TEXT,"
        "blocked BIT"
        ")";

    // ve SqlFlite ile gelen openDatabase methodu ile database'i oluşturup onu dönüyoruz.
    return openDatabase(
      // database'in oluşturulacağı konum; yukarıda aldığımız varsayalın database konumu ve
      // oluşturmak istediğimiz isimde dosyamızın adını verip, o konuma o isimde oluşturmasını istedik
      join(dbPath, "kelimeezberleme.db"),// -> 'varsayılanKonum/TestDb.db'
      // verdiğimiz SQL komutu ve version numarası ile database'imizi oluşturmasını istedik
      onCreate: (db, version) => db.execute(dbSQL),
      version: 1,
    );
  }

  /// Yeni Kayıt
  newClient(Client newClient) async {
    final db = await database();
    // Client isimli tabloya parametre olarak verdiğimiz yeni müşteriyi
    // map'e çevir ve database()'imize ekle
    var sonuc = await db.insert("Client", newClient.toMap());
    // geri dönüş değerini dönder, ekleme olumlu olursa, eklendi "id"'yi dönecek
    return sonuc;
  }

  /// Verilen "id" değerine göre elemanı getir
  getClient(int id) async {
    final db = await database();
    // parametre olarak verdiğimiz "id" ye göre database()'den ilgili elemanı getircek
    var sonuc = await db.query("Client", where: "id = ?", whereArgs: [id]);
    // eğer sonuc boş değilse bulduğu ilk elemanı dön, boş işe null dön
    return sonuc.isNotEmpty ? Client.fromMap(sonuc.first) : Null;
  }

  /// bütün elemanları getir
  Future<List<Client>> getAllClients() async {
    final db = await database();
    var sonuc = await db.query("Client");
    List<Client> list =
    sonuc.isNotEmpty ? sonuc.map((c) => Client.fromMap(c)).toList() : [];
    return list;
  }

  /// sadece bloklanmış elemanları liste şeklinde dönecek
  Future<List<Client>> getBlockedClients() async {
    final db = await database();
    var sonuc = await db.query("Client", where: "blocked = ? ", whereArgs: [1]);
    List<Client> list =
    sonuc.isNotEmpty ? sonuc.map((c) => Client.fromMap(c)).toList() : [];
    return list;
  }

  /// var olan müşteriyi günceller
  updateClient(Client newClient) async {
    final db = await database();
    var sonuc = await db.update("Client", newClient.toMap(),
        where: "id = ?", whereArgs: [newClient.id]);
    return sonuc;
  }

  /// Verilen müşteriyi bloklar veya açar
  blockOrUnblock(Client client) async {
    final db = await database();
    Client blocked = Client(
        id: client.id,
        englishWord: client.englishWord,
        turkceKelime: client.turkceKelime,
        blocked: !client.blocked);
    var sonuc = await db.update("Client", blocked.toMap(),
        where: "id = ?", whereArgs: [client.id]);
    return sonuc;
  }

  /// verilen id değerine göre müşteriyi siler
  deleteClient(int id) async {
    final db = await database();
    db.delete("Client", where: "id = ?", whereArgs: [id]);
  }

  /// bütün kelimeleri siler
  deleteAll() async {
    final db = await database();
    db.rawDelete("Delete from Client");
  }
}