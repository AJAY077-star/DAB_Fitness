import '../provider/database_model.dart';
import 'package:agora_flutter_quickstart/pages/login_page.dart';
import 'package:provider/provider.dart';
import '../provider/auth_model.dart';
import 'package:flutter/material.dart';
import '../animation/FadeAnimation.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter/services.dart';

class SignUpDetail extends StatefulWidget {
  final int mode;
  final Map<String, String> _authData;

  SignUpDetail(this.mode, this._authData);
  @override
  _SignUpDetailState createState() => _SignUpDetailState();
}

class _SignUpDetailState extends State<SignUpDetail> {
  int _selectedRadioButton = 0;
  final GlobalKey<FormState> _formKey = GlobalKey();
  //var _isLoading = false;

  void _submit() {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    // setState(() {
    //   _isLoading = true;
    // });
    getUserLocation();
    if (widget.mode == 0) {
      widget._authData["Gender"] =
          _selectedRadioButton == 0 ? "male" : "female";
      Provider.of<Auth>(context, listen: false)
          .signUp(widget._authData["email"], widget._authData["password"])
          .then((value) {
        print("sign up");
        print(value['idToken']);
        Provider.of<DataBase>(context, listen: false)
            .registerUserData(
                value['idToken'], value['localId'], widget._authData)
            .then((value) => Navigator.of(context)
                .pushReplacementNamed(LoginPage.routeName));
      });
    } else {
      Provider.of<Auth>(context, listen: false)
          .signUp(widget._authData["email"], widget._authData["password"])
          .then((value) {
        Provider.of<DataBase>(context, listen: false)
            .registerTrainerData(
                value['idToken'], value['localId'], widget._authData)
            .then((value) => Navigator.of(context)
                .pushReplacementNamed(LoginPage.routeName));
      });
    }

    // setState(() {
    //   _isLoading = false;
    // });
  }

  getUserLocation() async {
    //call this async method from whereever you need

    LocationData myLocation;
    String error;
    Location location = new Location();
    try {
      myLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'please grant permission';
        print(error);
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'permission denied- please enable it from app settings';
        print(error);
      }
      myLocation = null;
    }
    final coordinates =
        new Coordinates(myLocation.latitude, myLocation.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print(
        ' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
    widget._authData['Address'] = first.locality.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: widget.mode == 0 ? userDetails() : trainerDetails(),
        ),
      ),
    );
  }

  Widget trainerDetails() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            children: <Widget>[
              FadeAnimation(
                  1,
                  Text(
                    "Sign up",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  )),
              SizedBox(
                height: 20,
              ),
              FadeAnimation(
                  1.2,
                  Text(
                    "Enter the Details",
                    style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                  )),
            ],
          ),
          Column(
            children: <Widget>[
              FadeAnimation(1.2, makeInput(label: "Name")),
              FadeAnimation(1.3, makeInput(label: "Age")),
              FadeAnimation(1.3, makeInput(label: "Gender")),
              FadeAnimation(1.4, makeInput(label: "Description")),
              FadeAnimation(1.5, makeInput(label: "Speciality")),
              FadeAnimation(1.6, makeInput(label: "Number")),
            ],
          ),
          FadeAnimation(
            1.5,
            Container(
              padding: EdgeInsets.only(top: 3, left: 3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border(
                    bottom: BorderSide(color: Colors.black),
                    top: BorderSide(color: Colors.black),
                    left: BorderSide(color: Colors.black),
                    right: BorderSide(color: Colors.black),
                  )),
              child: MaterialButton(
                minWidth: double.infinity,
                height: 60,
                onPressed: _submit,
                color: Colors.greenAccent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                child: Text(
                  "Sign up",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget userDetails() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            children: <Widget>[
              FadeAnimation(
                  1,
                  Text(
                    "Sign up",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  )),
              SizedBox(
                height: 20,
              ),
              FadeAnimation(1.2, makeInput(label: "Name")),
              FadeAnimation(1.2, makeInput(label: "Number")),
              FadeAnimation(
                1.2,
                Text(
                  "Choose Your Preferences",
                  style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              FadeAnimation(1.2, makeRadioButton("Male", 0)),
              FadeAnimation(1.2, makeRadioButton("Female", 1)),
            ],
          ),
          FadeAnimation(
            1.5,
            Container(
              padding: EdgeInsets.only(top: 3, left: 3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border(
                    bottom: BorderSide(color: Colors.black),
                    top: BorderSide(color: Colors.black),
                    left: BorderSide(color: Colors.black),
                    right: BorderSide(color: Colors.black),
                  )),
              child: MaterialButton(
                minWidth: double.infinity,
                height: 60,
                onPressed: _submit,
                color: Colors.greenAccent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                child: Text(
                  "Sign up",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget makeInput({label, obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
          ),
          onSaved: (value) {
            widget._authData[label] = value;
          },
          validator: (value) {
            if (value.isEmpty) {
              return '$label is empty!';
            }
            return null;
          },
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }

  void handleRadioButton() {}
  Widget makeRadioButton(String label, int value) {
    return ListTile(
      title: Text(label),
      leading: Radio(
        value: value,
        groupValue: _selectedRadioButton,
        onChanged: (value) {
          setState(() {
            _selectedRadioButton = value;
          });
        },
      ),
    );
  }
}
