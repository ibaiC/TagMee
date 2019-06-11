import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';

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
          content: Text("1.  Input words related to your image in the box \n2. Tap on the TagMee button \n3. Copy the best-performing hashtags for your related words onto your Instagram post \n 4. Tap on the hashtags box to copy them to the clipboard\n5. Get clout.\n\nAuthor: Ibai Castells",
          style: TextStyle(fontSize: 11.0),),
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
    final key = new GlobalKey<ScaffoldState>();
    return new Scaffold(
      key: key,
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
                    return GestureDetector(
                      child: AutoSizeText( output, 
                        maxLines: 25,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.indigo,
                          fontSize: 25.0,
                        ),
                      ),
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: output));
                        key.currentState.showSnackBar(
                          SnackBar(content: Text('Copied Hashtags to clipboard'),)
                        );
                      },
                );
                  }
                )
              )
            ),
            ),
          )
        ),
        Padding(
          padding: EdgeInsets.only(top: 495.0),
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
                  hintStyle: TextStyle(color: Colors.white)
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
        Padding(
          padding: EdgeInsets.only(top: 560.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: GradientButton(
              increaseWidthBy: 30.0,
              increaseHeightBy: 5.0,
              child: Text('TagMee',
                style: TextStyle(fontSize: 15),
              ),
              callback: () {
                // Rebuild when button is pressed so changes to Hashtags textbox take place
                setState((){});
              },
              gradient: Gradients.hotLinear
            )
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 15.0),
          child: Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(Icons.info),
              iconSize: 30.0,
              color: Colors.white.withOpacity(0.5),
              onPressed: () {
                _showDialog();
              },
            ),
          ),
        ),
      ],
    ));
  }
}
