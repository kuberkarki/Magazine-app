import 'dart:convert';

import 'package:LEDERNYTT/common/config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  SharedPreferences sharedPreferences;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _isLoading = false;
  var _user;
  TextEditingController nameController;
  TextEditingController companyController;
  TextEditingController address_1Controller;
  TextEditingController postalCodeController;
  TextEditingController cityController;
  TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    getuserdetail();

    _isLoading = false;
  }

  getuserdetail() async {
    sharedPreferences = await SharedPreferences.getInstance();
    // print(sharedPreferences.getString("token"));
    Map data = {'token': sharedPreferences.getString("token")};
    var response =
        await http.post(apiUrl + "get-user-detail-by-token", body: data);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      // print(jsonResponse);
      if (jsonResponse['status'] == 'error') {
        Fluttertoast.showToast(
          msg: jsonResponse['message'],
          toastLength: Toast.LENGTH_LONG,
        );
        setState(() {
          _user = null;
          _isLoading = false;
        });
      }
      if (jsonResponse['status'] == 'ok') {
        setState(() {
          _isLoading = false;
          _user = jsonResponse['data'];
          print(jsonResponse['data']['name']);
          nameController = new TextEditingController(text: _user['name']);
          companyController = new TextEditingController(text: _user['company']);
          address_1Controller =
              new TextEditingController(text: _user['address_1']);
          postalCodeController =
              new TextEditingController(text: _user['postal_code']);
          cityController = new TextEditingController(text: _user['city']);
          emailController = new TextEditingController(text: _user['email']);
        });

        return null;
      }
    }
  }

  updateProfile(String name, String company, String address_1, 
      String postalCode,String city, String email) async {
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
      'name': name,
      'company': company,
      'address_1': address_1,
      'postal_code': postalCode,
      'city': city,
      'email': email,
      'token': sharedPreferences.getString("token")
    };

    var response = await http.post(apiUrl + "update-my-profile", body: data);

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
        title: Text("Profil",
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
                  updateProfile(
                      nameController.text,
                      companyController.text,
                      address_1Controller.text,
                      postalCodeController.text,
                      cityController.text,
                      emailController.text);
                },
                elevation: 0.0,
                color: Colors.black,
                child: Text("OPPDATER", style: TextStyle(color: Colors.white)),
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

  Container textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: nameController,
            cursorColor: Colors.black,
            style: TextStyle(color: Colors.black),
            validator: (String value) {
              if (value.isEmpty) {
                return "Navn kreves";
              }
              return null;
            },
            decoration: InputDecoration(
              icon: Icon(Icons.person, color: Colors.grey),
              hintText: "Navn",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70)),
              hintStyle:
                  TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          ),
          SizedBox(height: 20.0),
          TextFormField(
            controller: companyController,
            cursorColor: Colors.black,
            style: TextStyle(color: Colors.black),
            validator: (String value) {
              if (value.isEmpty) {
                return "Firma kreves";
              }
              return null;
            },
            decoration: InputDecoration(
               icon: Icon(Icons.work, color: Colors.grey),
              hintText: "Firma",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70)),
              hintStyle:
                  TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          ),
          SizedBox(height: 20.0),
          TextFormField(
            controller: address_1Controller,
            cursorColor: Colors.black,
            style: TextStyle(color: Colors.black),
            validator: (String value) {
              if (value.isEmpty) {
                return "Adresse kreves";
              }
              return null;
            },
            decoration: InputDecoration(
              icon: Icon(Icons.pin_drop, color: Colors.grey),
              hintText: "Adresse",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70)),
              hintStyle:
                  TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          ),
          SizedBox(height: 20.0),
          TextFormField(
            controller: postalCodeController,
            cursorColor: Colors.black,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              icon: Icon(Icons.home, color: Colors.grey),
              hintText: "Postnummer",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70)),
              hintStyle:
                  TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          ),
          SizedBox(height: 20.0),
          TextFormField(
            
            controller: cityController,
            cursorColor: Colors.black,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              icon: Icon(Icons.location_city, color: Colors.grey),
              hintText: "City",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70)),
              hintStyle:
                  TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          ),
          SizedBox(height: 20.0),
          TextFormField(
            controller: emailController,
            enabled: false,
            cursorColor: Colors.black,
            style: TextStyle(color: Colors.black),
            validator: (String value) {
              if (value.isEmpty) {
                return "Epost kreves";
              }
              return null;
            },
            decoration: InputDecoration(
              icon: Icon(Icons.alternate_email, color: Colors.grey),
              hintText: "Epost",
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
      margin: EdgeInsets.only(top: 5.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
    );
  }
}
