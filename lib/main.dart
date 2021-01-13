

import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import 'Web.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<List<Json>> _getdata() async{
    var data = await http.get("https://hubblesite.org/api/v3/news");
    var jsondata=convert.jsonDecode(data.body);
    List<Json> json=[];
    for( var j in jsondata){
      Json jsons=Json(j['news_id'], j['name'], j['url']);
      json.add(jsons);
    }

    print(json);
    return json;
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getdata(),
          builder: (BuildContext con,AsyncSnapshot snap){
            if(snap.data == null){
              return Container(
                child: Center(
                  child: Text("Loading"),
                ),
              );
            }
            else {
              return ListView.builder(
                itemCount: snap.data.length,
                itemBuilder: (BuildContext con, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:Colors.red,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 3,
                            spreadRadius: .6,
                          )
                        ]
                      ),
                      child: ListTile(
                        title: Text(snap.data[index].name,style: TextStyle(fontWeight: FontWeight.bold),),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Webview(snap.data[index].url)));
                        },
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class Json{
  final String news_id;
  final String name;
  final String url;
  Json(this.news_id,this.name,this.url);
}