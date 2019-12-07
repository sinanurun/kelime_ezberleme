import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'dart:math' as math;

import 'DBHelper.dart';
import 'clientModel.dart';



class SQLiteDemo extends StatefulWidget {
  @override
  _SQLiteDemoState createState() => _SQLiteDemoState();
}

class _SQLiteDemoState extends State<SQLiteDemo> {
  // test için data
  List<Client> testClients = [Client(englishWord: "a", turkceKelime: "bir", blocked: true),
  Client(englishWord: "ability", turkceKelime: "kabiliyet, yetenek, beceri, güç, iktidar", blocked: true),
  Client(englishWord: "able", turkceKelime: "yapabilmek, yapabilen", blocked: true),
  Client(englishWord: "about", turkceKelime: "hakkında, ilgili, konusunda", blocked: true),
  Client(englishWord: "above", turkceKelime: "yukarıda", blocked: true),
  Client(englishWord: "accept", turkceKelime: "kabul etmek", blocked: true),
  Client(englishWord: "according", turkceKelime: "göre", blocked: true),


  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flutterdff SQLite")),
      // FutureBuilder ile listemize bağlandık
      body: FutureBuilder<List<Client>>(
        // future olarak database sınıfımızdaki bütün kelimeleri getir
        // adlı methodunu verdik
        future: DBHelper().getAllClients(),
        builder: (BuildContext context, AsyncSnapshot<List<Client>> snapshot) {
          // eğer verdiğimiz future içerisinde veri var ise bunları
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Client item = snapshot.data[index];
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) {
                    DBHelper().deleteClient(item.id);
                  },
                  child: ListTile(
                    title: Text(item.englishWord),
                    subtitle: Text(item.turkceKelime),
                    leading: Text(item.id.toString()),
                    trailing: Checkbox(
                      onChanged: (bool value) {
                        DBHelper().blockOrUnblock(item);
                        setState(() {});
                      },
                      value: item.blocked,
                    ),
                  ),
                );
              },
            );
            // veri yok ise ekran ortasında dönen progressindicator göster
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      // Floatingaction buton'a basınca listemizden rasgele müşteri oluşturacak
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.settings_backup_restore),
        tooltip: "Kelime Havuzunu Sıfırla",
        onPressed: () async {
          await DBHelper().deleteAll();
          print("işlem oldu");

          // listemizin uzunluğu sayısı kadar rasgele sayı üretip
          // o sayıya denk gelen müşteriyi database'e ekleyecek
          for(var i=0;i<testClients.length;i++) {
            Client rnd = testClients[i];
            await DBHelper().newClient(rnd);
          }

          setState(() {});
        },
      ),
    );
  }
}

