import 'package:flutter/material.dart';
import 'package:sliverbar_with_card/sliverbar_with_card.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:provider/provider.dart';
import '../provider/booking_model.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter/services.dart';

class TrainerDetail extends StatefulWidget {
  final trainer;
  TrainerDetail(this.trainer);

  @override
  _TrainerDetailState createState() => _TrainerDetailState();
}

class _TrainerDetailState extends State<TrainerDetail> {
  bool favorito = false;
  bool expandText = false;
  String dateTime;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<String> getUserLocation() async {
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
    return first.locality.toString();
  }

  void _book(final trainerId, final name) {
    print("book");
    _formKey.currentState.save();
    List<String> dateTimeSplit = dateTime.split(" ");
    getUserLocation().then((value) {
      Provider.of<Booking>(context, listen: false)
          .book(dateTimeSplit[0], dateTimeSplit[1], value, trainerId, name)
          .then((_) {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text("Booked"),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pop();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Material(
        child: CardSliverAppBar(
          height: 320,
          background: Image.asset(widget.trainer.image, fit: BoxFit.cover),
          title: Text(widget.trainer.name,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          titleDescription: Text(
            "Speciality: ${widget.trainer.speciality}",
            style: TextStyle(color: Colors.black, fontSize: 18),
            overflow: TextOverflow.clip,
          ),
          card: AssetImage(widget.trainer.image),
          backButton: true,
          backButtonColors: [Colors.white, Colors.black],
          body: Container(
            alignment: Alignment.topLeft,
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: expandText ? 145 : 65,
                  margin: EdgeInsets.only(left: 30, right: 30, top: 50),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        expandText = !expandText;
                      });
                    },
                    child: Text(
                      widget.trainer.description,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 30),
                  child: Text("Age",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 30),
                  child: Text(widget.trainer.age.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 16)),
                ),
                Divider(),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 30),
                  child: Text("Rating",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.only(right: 240),
                  child: ratingBar(widget.trainer.rating),
                ),
                Divider(),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 30),
                  child: Text("Experience",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 30),
                  child: Text(widget.trainer.experience.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 16)),
                ),
                Divider(),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 30),
                  child: Text("Contact Number",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 30),
                  child: Text(widget.trainer.number,
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 16)),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 100),
                  alignment: Alignment.bottomCenter,
                  child: RaisedButton(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 20),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Form(
                            key: _formKey,
                            child: Container(
                              height: 200,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buildDateTimePicker(),
                                    SizedBox(
                                      width: 320.0,
                                      child: RaisedButton(
                                        onPressed: () => _book(
                                            widget.trainer.id,
                                            widget.trainer.name),
                                        child: Text(
                                          "Book",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        color: const Color(0xFF1BC0C5),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    child: Text("Book"),
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(10),
                    // ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget ratingBar(int rating) {
    List<Widget> stars = [];
    for (int i = 0; i < 5; i++) {
      if (i <= rating)
        stars.add(Icon(
          Icons.star,
          color: Colors.orange[700],
        ));
      else
        stars.add(Icon(Icons.star_border));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: stars,
    );
  }

  Widget buildDateTimePicker() {
    return DateTimePicker(
      type: DateTimePickerType.dateTimeSeparate,
      dateMask: 'd MMM, yyyy',
      initialValue: DateTime.now().toString(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      icon: Icon(Icons.event),
      dateLabelText: 'Date',
      timeLabelText: "Hour",
      selectableDayPredicate: (date) {
        // Disable weekend days to select from the calendar
        if (date.weekday == 7) {
          return false;
        }

        return true;
      },
      onChanged: (val) => print(val),
      validator: (val) {
        print(val);
        return null;
      },
      onSaved: (val) => print(val),
    );
  }
}
