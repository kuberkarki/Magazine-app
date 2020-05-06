import 'dart:convert';

import 'package:LEDERNYTT/common/config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  SharedPreferences sharedPreferences;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool passwordVisible;

  @override
  void initState() {
    super.initState();
    getuserdetail();
    passwordVisible = true;
    _isLoading = false;
  }

  getuserdetail() async {
    // sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      // token = sharedPreferences.getString("token");
      _isLoading = false;
    });
  }

  changePassword(String oldPassword, String newPassword) async {
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
    Map data = {
      'old-password': oldPassword,
      'new-password': newPassword,
      'token': sharedPreferences.getString("token")
    };

    var response = await http.post(apiUrl + "change-password", body: data);

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
        title: Text("Endre Passord",
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
          child: Row(
            children: [
              RaisedButton(
                onPressed: () {
                  if (!_formkey.currentState.validate()) {
                    return;
                  }
                  setState(() {
                    _isLoading = true;
                  });
                  changePassword(
                    oldPasswordController.text,
                    newPasswordController.text,
                  );
                },
                elevation: 0.0,
                color: Colors.black,
                child: Text("ENDRE PASSORD",
                    style: TextStyle(color: Colors.white)),
              ),
              SizedBox(
                width: 10,
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                elevation: 0.0,
                color: Colors.black26,
                child:
                    Text("KANSELLERE", style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  final TextEditingController oldPasswordController =
      new TextEditingController();
  final TextEditingController newPasswordController =
      new TextEditingController();
  final TextEditingController confirmPasswordController =
      new TextEditingController();

  Container textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: oldPasswordController,
            cursorColor: Colors.black,
            obscureText: passwordVisible,
            style: TextStyle(color: Colors.black),
            validator: (String value) {
              if (value.isEmpty) {
                return "Nåværende passord kreves";
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: "Nåværende passord",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70)),
              hintStyle:
                  TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
              suffixIcon: IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.black26,
                ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                    passwordVisible = !passwordVisible;
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 20.0),
          TextFormField(
            controller: newPasswordController,
            obscureText: passwordVisible,
            cursorColor: Colors.black,
            style: TextStyle(color: Colors.black),
            validator: (String value) {
              if (value.isEmpty) {
                return "Nytt passord kreves";
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: "Nytt passord",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70)),
              hintStyle:
                  TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
              suffixIcon: IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.black26,
                ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                    passwordVisible = !passwordVisible;
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 20.0),
          TextFormField(
            controller: confirmPasswordController,
            obscureText: passwordVisible,
            cursorColor: Colors.black,
            style: TextStyle(color: Colors.black),
            validator: (String value) {
              if (value.isEmpty) {
                return "Gjenta nytt kreves";
              }
              if (value != newPasswordController.text) {
                return "nye passord er ikke like";
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: "Gjente nytt passord",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70)),
              hintStyle:
                  TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
              suffixIcon: IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.black26,
                ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                    passwordVisible = !passwordVisible;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container headerSection() {
    return Container(
      margin: EdgeInsets.only(top: 5.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
    );
  }
}
