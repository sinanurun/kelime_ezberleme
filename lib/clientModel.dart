import 'dart:convert';
/// ClientModel.dart
Client clientFromJson(String str) {
  final jsonData = json.decode(str);
  return Client.fromMap(jsonData);
}

String clientToJson(Client data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Client {
  int id;
  String englishWord;
  String turkceKelime;
  bool blocked;

  Client({
    this.id,
    this.englishWord,
    this.turkceKelime,
    this.blocked,
  });

  // gelen map verisini json'a dönüştürür
  factory Client.fromMap(Map<String, dynamic> json) => new Client(
    id: json["id"],
    englishWord: json["english_word"],
    turkceKelime: json["turkce_kelime"],
    blocked: json["blocked"] == 1,
  );

  // gelen json' verisini Map'e dönüştürür
  Map<String, dynamic> toMap() => {
    "id": id,
    "english_word": englishWord,
    "turkce_kelime": turkceKelime,
    "blocked": blocked,
  };
}