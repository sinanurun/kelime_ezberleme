import 'package:flutter/material.dart';
import 'bolum2.dart';
import 'dbornegi.dart';

// Uygulamanın Başladığı yer
// runApp diyip açılışta çalıştırmasını istediğimiz Widgetimizi Belirtiyoruz
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // MaterialApp = Google'nın material standartlarında bileşenleri kullanmamızı sağlayan yapı
    return MaterialApp(
      // title = işletim sistemi uygulamamızı hangi isimde tanıyacak
      title: 'Kelime Ezberleme',
      // Uygualama ilk açıldığında görünecek widgetimiz
      home: StatelesUygulama(),
    );
  }
}

class StatelesUygulama extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Uygulama içerisinde kolaylık sağlaması için bir kaç sabit ekleyelim
    // böylece her seferinde tek tek girmemiz gerekmez
    final double myTextSize = 30.0;
    final double myIconSize = 40.0;
    final TextStyle myTextStyle =
    TextStyle(color: Colors.grey, fontSize: myTextSize);

    return Scaffold(
      appBar: AppBar(
        title: Text("Kelime Ezberleme Uygulaması"),
      ),
      body: Container(
        child: Center(
          // SingleChildScrollView = Eğer ekrana içerisine verdiğimiz widgetler
          // ekrana sığmaz ise aşşağı kaydırma özelliği ekleyecek
          child: SingleChildScrollView(
              child: Column(
                // Column içerisindeki OzelCardlarımız yatay olarak
                // genişleyebildiği kadar genişlemesini belirttik
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Ve Özel olarak oluşturduğumuz widgeti kullanarak elemanlarımızı ekliyoruz
                  OzelCard(
                    raisedButton: RaisedButton(
                      child: Icon(Icons.gps_fixed,
                          size: myIconSize, color: Colors.red),
                      onPressed: (){
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (BuildContext context)=>Asayfasi(),
                    ),
                    );},),
                      title: Text("Kelime Tahmin Bölümü", style: myTextStyle),
                  ),
                  OzelCard(
                      title: Text("Kelime Ekleme Bölümü", style: myTextStyle),
                      raisedButton: RaisedButton(
                        child: Icon(Icons.add,
                            size: myIconSize, color: Colors.red),
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context)=>KelimeEklemeSayfasi(),
                            ),
                          );},),
                  ),
                  OzelCard(
                      title: Text("Kelime Listesi", style: myTextStyle),

                    raisedButton: RaisedButton(
                      child: Icon(Icons.clear_all,
                          size: myIconSize, color: Colors.red),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(
                        builder: (context) => SQLiteDemo(),
                      ),),
                    ),
                  ),
                  ],
              )),
        ),
      ),
    );
  }
}

// Uygulamamızın başka yerlerinde kullanabileceğimiz bir widget oluşturduk
class OzelCard extends StatelessWidget {

  final Widget title;
  final Widget raisedButton;


  // Constructor.
  OzelCard({this.title,  this.raisedButton});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 1.0),
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              this.title,

              this.raisedButton,
            ],
          ),
        ),
      ),
    );
  }
}