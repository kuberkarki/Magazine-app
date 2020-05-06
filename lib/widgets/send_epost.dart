import 'dart:convert';

import 'package:LEDERNYTT/common/config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import '../forgot.dart';
import '../login.dart';
import '../main.dart';

class SendEpostPage extends StatefulWidget {
  const SendEpostPage({Key key}) : super(key: key);

  @override
  _SendEpostPageState createState() => _SendEpostPageState();
}

class _SendEpostPageState extends State<SendEpostPage> {
  SharedPreferences sharedPreferences;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    _isLoading=false;
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  sendEpost(String subject, String content) async {
    if (await checkInternet() == false) {
      Fluttertoast.showToast(
        msg: "Sjekk Internettforbindelse",
        toastLength: Toast.LENGTH_LONG,
      );
      setState(() {
        _isLoading = false;
      });
      return null;
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // print(email);
    Map data = {'subject': subject, 'message': content,'token':sharedPreferences.getString("token")};
   

    var response = await http.post(apiUrl + "email-us", body: data);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'error') {
        Fluttertoast.showToast(
          msg: jsonResponse['message'],
          toastLength: Toast.LENGTH_LONG,
        );
        setState(() {
          _isLoading = false;
        });

        return null;
      }
      if (jsonResponse['status'] == 'ok') {
        Fluttertoast.showToast(
          msg: jsonResponse['message'] ?? 'Error !!',
          toastLength: Toast.LENGTH_LONG,
        );
        setState(() {
          _isLoading = false;
        });

        return null;
      }
     
    } else {
      setState(() {
        _isLoading = false;
      });
      print(response.body);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: false,
        title: Text("Send oss epost",
            style: TextStyle(color: Colors.black), textAlign: TextAlign.right),
      ),
      body: Container(
        child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : Form(
                  key: _formkey,
                  child: ListView(
                    children: <Widget>[
                      headerSection(),
                      textSection(),
                      buttonSection(),
                    ],
                  ),
                ),
        ),
      
      
    );
  }

   Widget buttonSection() {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 40.0,
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          margin: EdgeInsets.only(top: 15.0),
          child: RaisedButton(
            onPressed: () {
              if (!_formkey.currentState.validate()) {
              return;
            }
              setState(() {
                _isLoading = true;
              });
              sendEpost(emneController.text, inholdController.text);
            },
            elevation: 0.0,
            color: Colors.black,
            child: Text("SENDE", style: TextStyle(color: Colors.white)),
            // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          ),
        ),
        ],
    );
  }

  final TextEditingController emneController = new TextEditingController();
  final TextEditingController inholdController = new TextEditingController();

  Container textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: emneController,
            cursorColor: Colors.black,
            style: TextStyle(color: Colors.black),
            validator: (String value) {
              if (value.isEmpty) {
                return "Emne kreves";
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: "Emne",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70)),
              hintStyle:
                  TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          ),
          SizedBox(height: 30.0),
          TextField(
            controller: inholdController,
            cursorColor: Colors.black,
            style: TextStyle(color: Colors.black),
            maxLines: 8,
            decoration: InputDecoration(
              hintText: "Inhold",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70)),
              hintStyle:
                  TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }

  Container headerSection() {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      
    );
  }
}
