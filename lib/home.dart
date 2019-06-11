import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<String>> fetchPost(hashtags) async {
    List<String> relatedHastags = [];

  //iterate; for item in related_words, do request and add to relatedHashtags
  for (var tag in hashtags) {
    var api = 'https://query.displaypurposes.com/tag/';
    var payload = api + tag;
    final response = await http.get(payload);

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      Map<String, dynamic> resp = jsonDecode(response.body);

      // add data to relatedHashtags map
      for (var item in resp['results']) {
        relatedHastags.add('#' + item['tag'] + ' ');
      }
    
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to get Hashtags');
    }
  }
  // return the MAP with ALL the related hashtags
  print(relatedHastags);
  return relatedHastags;
}

class HomeScreen extends StatefulWidget{
  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  
  // Variables to keep track of hashtags 
  Map<String, dynamic> hashtags;
  var output;
  var related_words = '';

  // user defined function
  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("TagMee", textAlign: TextAlign.center),
          content: Text("1. Input words related to your image in the box \n2. Tap on the TagMee button \n3. Copy the best-performing hashtags for your related words onto your Instagram post \n4. Get clout.\n\nAuthor: Ibai Castells"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            GradientButton(
              increaseWidthBy: 30,
              gradient: Gradients.cosmicFusion,
              child: new Text("Close"),
              callback: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext ctxt) {
    return new Scaffold(
      body: Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/desert2.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 80.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: Text('Hashtags',
              style: TextStyle(
                color: Colors.white,
                fontSize: 35.0,
                fontFamily: 'Billabong',
              )
            ,),
          )
        ),
        Padding(
          padding: EdgeInsets.only(top: 150.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 300.0,
              width: 280.0,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: FutureBuilder<List<String>>(
                  future: fetchPost(related_words.split(" ")),
                  builder: (context, snapshot) {
                    var output = '';
                    if (snapshot.data != null) {
                      for (var i in snapshot.data) {
                        // add each hashtag to a string
                        output += i;
                      }
                    }
                    else { output = '';}
                    return AutoSizeText( output, 
                      maxLines: 25,
                      style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 25.0,
                      ),
                    );
                  }
                )
              )
            ),
            ),
          )
        ),
        Padding(
          padding: EdgeInsets.only(top: 475.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 280,
              child: TextField(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  hintText: "Related words",
                  hintStyle: TextStyle(color: Colors.grey[400])
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white
                ),
                onChanged: (text) {
                related_words = text;
                },
              )
          ),
          )
        ),
        Positioned(
          top: 560.0,
          left: 150.0,
          child: GradientButton(
          increaseWidthBy: 30.0,
          increaseHeightBy: 5.0,
          child: Text('TagMee',
            style: TextStyle(fontSize: 15),),
          callback: () {
            setState((){
            });
          },
          gradient: Gradients.hotLinear,
        ),
        ),
        Positioned(
          top: 15,
          left: 355,
          child: IconButton(
            icon: Icon(Icons.info),
            iconSize: 30.0,
            color: Colors.white.withOpacity(0.5),
            onPressed: () {
              _showDialog();
            },
          ),
        )
      ],
    ));
  }
}

