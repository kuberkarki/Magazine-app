import 'dart:convert';
import 'package:LEDERNYTT/login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'common/config.dart';

class ForgotPage extends StatefulWidget {
  @override
  _ForgotPageState createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 300,
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
      ),
    );
  }

  void sendForgot(String email) async {
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
    Map data = {'user_name': email};

    var response = await http.post(apiUrl + "forgot-password", body: data);

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
      if (jsonResponse['status'] == 'ok' || jsonResponse['status'] == 'error') {
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
              sendForgot(emailController.text);
            },
            elevation: 0.0,
            color: Colors.black,
            child: Text("HENTE PASSORD", style: TextStyle(color: Colors.white)),
          ),
        ),
        SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => LoginPage()),
                (Route<dynamic> route) => false);
          },
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Logg inn",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  final TextEditingController emailController = new TextEditingController();

  Container textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: emailController,
            cursorColor: Colors.black,
            style: TextStyle(color: Colors.black),
            validator: (String value) {
              if (value.isEmpty) {
                return "brukernavn kreves";
              }
              return null;
            },
            decoration: InputDecoration(
              icon: Icon(Icons.person, color: Colors.grey),
              hintText: "brukernavn",
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
      child: Image(image: AssetImage('assets/logo.png')),
    );
  }
}
