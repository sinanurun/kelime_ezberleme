import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart' as prefix0;
import 'package:flutter/material.dart';
import 'clientModel.dart';
import 'main.dart';
import 'DBHelper.dart';
import 'dbornegi.dart';

class MyApp2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Sağüst köşedeki debug yazısını kapatır
      debugShowCheckedModeBanner: false,
      home: Asayfasi(),
    );
  }
}


class Asayfasi extends StatefulWidget {
  @override
  _Asayfasi createState() => _Asayfasi();

}

  class _Asayfasi extends State<Asayfasi> {
  // test için data
  List<Client> testClients = [];

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



//class Asayfasi extends StatelessWidget {
//
//
//  @override
//  Widget build(BuildContext context) {
//
//
//    return Scaffold(
//      appBar: AppBar(title: Text("Kelime Ezberleme Uygulaması")),
//      body: Column(
//        mainAxisAlignment: MainAxisAlignment.center,
//
//        children: <Widget>[
//          Center(
//            child: Text("İşte Kelimeniz",textAlign: TextAlign.center, style: TextStyle(fontSize: 30)),
//          ),
//          SizedBox(height: 20),
//          Center(
//            child: Text("ewrewr",textAlign: TextAlign.center, style: TextStyle(fontSize: 45, fontStyle: FontStyle.italic)),
//          ),
//          SizedBox(height: 50),
//          Center(
//            child: RaisedButton(
//
//              child: Text(bilgiler.turkceKelime),
//
//              onPressed: () {
//                // push ile bir sonraki sayfaya geçiş yapıyoruz.
//                // ilk parametre olarak sayfamızın context'i
//                // ikinci parametre olarak, sayfa geçiş animasyonlarını vb. sağlayan MaterialPageRoute
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                    builder: (BuildContext context) => Bsayfasi(),
//                  ),
//                );
//              },
//            ),
//          ),
//          Center(
//            child: RaisedButton(
//              child: Text("B Sayfasına Git"),
//              onPressed: () {
//                // push ile bir sonraki sayfaya geçiş yapıyoruz.
//                // ilk parametre olarak sayfamızın context'i
//                // ikinci parametre olarak, sayfa geçiş animasyonlarını vb. sağlayan MaterialPageRoute
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                    builder: (BuildContext context) => Bsayfasi(),
//                  ),
//                );
//              },
//            ),
//          ),
//          Center(
//            child: ButtonC(),
//          ),
//        ],
//      ),
//    );
//  }
//}

class ButtonC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        _cSayfasinaGitVeDegerBekle(context);
      },
      child: Text("C Sayfasına Veri Taşı"),
    );
  }

  _cSayfasinaGitVeDegerBekle(BuildContext context) async {
    // Navigator.push Navigator.pop'dan gelen bilgiyi Future olarak geri döndürür.
    // Navigator.pop gerçekleştiğinde gelen değeri sonuc değişgenine atayacak
    final sonuc = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Csayfasi(soru: "Şuan Hava Karanlık mı ?"),
      ),
    );

    // Gelen değeri bize göstermesi için, uygulamanın alt kısmında görünecek kısım
    Scaffold.of(context)
    // O an ekranda snackbar var ise kaldır ve yenisini göster
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text("$sonuc")));
  }
}

class Bsayfasi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("B Sayfası")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("B SAYFASI", style: TextStyle(fontSize: 30)),
          Center(
              child: RaisedButton(

                child: Text("A Sayfasına Geri Dön"),
                // Navigator.pop ile bir önceki sayfaya dönücek
                onPressed: () => Navigator.pop(context),
              )),
        ],
      ),
    );
  }
}

class KelimeEklemeSayfasi extends StatelessWidget {
  String englishword = "";
  String turkcekelime = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Yeni Kelime Ekleme Sayfası")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Aşağıdaki Forma Yeni Kelime bilgilerini Yazınız", style: TextStyle(fontSize: 30),textAlign: TextAlign.center),
          SizedBox(height: 10),
          TextField(decoration:InputDecoration(
              border: OutlineInputBorder()
          ),textAlign: TextAlign.center,
            // Her yeni veri girildiğinde çalışır
            onChanged: (veri) {
              englishword = veri;
            },
            // Klavyedeki Gönder(Bitti) tuşuna basınca çalışır
            onSubmitted: (veri) {
              englishword = veri;
            },
          ),
          SizedBox(height: 10),
          TextField(decoration:InputDecoration(
              border: OutlineInputBorder()
          ),textAlign: TextAlign.center,
            // Her yeni veri girildiğinde çalışır
            onChanged: (veri) {
              turkcekelime = veri;
            },
            // Klavyedeki Gönder(Bitti) tuşuna basınca çalışır
            onSubmitted: (veri) {
              turkcekelime = veri;
            },
          ),

          Center(
              child: RaisedButton(
                child: Text("Yeni Kelime ekle"),
                // Navigator.pop ile bir önceki sayfaya dönücek
                onPressed: ()   async {
                  Client yeni = Client(englishWord: englishword, turkceKelime: turkcekelime, blocked: true);
    await DBHelper().newClient(yeni);
    }
    //onPressed: () => Navigator.pop(context),
              )),
        ],
      ),
    );
  }
}




class Csayfasi extends StatelessWidget {
  final String soru;

  // İstediğimiz veri türünü Kurucu method ile belirtiyoruz.
  Csayfasi({this.soru});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("C Sayfası")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Diğer sayfadan gelecek veriyi Text widgetimizde gösterdik
          Text("$soru", style: TextStyle(fontSize: 30)),
          Center(
              child: RaisedButton(
                child: Text("Hayır"),
                // Navigator.pop ile bir önceki sayfaya dönücek
                // İkinci Parametre olarak geri dönüş değerimizi girdik
                onPressed: () => Navigator.pop(context, "Hayır"),
              )),
          Center(
              child: RaisedButton(
                child: Text("Evet"),
                // Navigator.pop ile bir önceki sayfaya dönücek
                // İkinci Parametre olarak geri dönüş değerimizi girdik
                onPressed: () => Navigator.push(context, MaterialPageRoute(
                  builder: (context) => StatelesUygulama(),
                ),),
              )),
          Center(
              child: RaisedButton(
                child: Text("belkni"),
                // Navigator.pop ile bir önceki sayfaya dönücek
                // İkinci Parametre olarak geri dönüş değerimizi girdik
                onPressed: () => Navigator.push(context, MaterialPageRoute(
                  builder: (context) => SQLiteDemo(),
                ),),
              )),
        ],
      ),
    );
  }
}


