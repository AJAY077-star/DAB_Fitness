import 'package:agora_flutter_quickstart/pages/trainerDetail_page.dart';
import 'package:agora_flutter_quickstart/provider/booking_model.dart';
import '../provider/database_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/rendering.dart';
import 'package:snapclip_pageview/snapclip_pageview.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter/services.dart';

class TrainerPage extends StatefulWidget {
  static const routeName = '/trainerpage';
  @override
  _TrainerPageState createState() => _TrainerPageState();
}

class _TrainerPageState extends State<TrainerPage> {
  List<Trainer> data;
  TextEditingController _dateTimeController;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String dateTime;
  @override
  void initState() {
    super.initState();
  }

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
            content: Text("Session Booked"),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pop();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments as List;
    return data.isEmpty
        ? Scaffold(body: Center(child: Text("No trainers are available")))
        : Scaffold(
            key: _scaffoldKey,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Color(0x00000000),
              elevation: 0,
            ),
            body: Builder(
              builder: (context) => SnapClipPageView(
                backgroundBuilder: buildBackground,
                itemBuilder: buildChild,
                length: data.length,
                initialIndex: 0,
              ),
            ),
          );
  }

  BackgroundWidget buildBackground(_, index) {
    final trainer = data[index];
    return BackgroundWidget(
      key: Key(index.toString()),
      child: Image.asset(trainer.image, fit: BoxFit.fill),
      index: index,
    );
  }

  PageViewItem buildChild(_, int index) {
    final trainer = data[index];
    final user = Provider.of<DataBase>(context, listen: false).getUser;
    return PageViewItem(
      alignment: Alignment.bottomCenter,
      key: Key(index.toString()),
      child: Container(
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              trainer.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 6,
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TrainerDetail(trainer),
                ),
              ),
              child: Container(
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.asset(
                    trainer.image,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 13,
            ),
            Text(
              "Age: ${trainer.age}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            ratingBar(trainer.rating),
            Divider(),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
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
                                  onPressed: () =>
                                      _book(trainer.trainerId, user.name),
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
              child: Text("BOOK NOW"),
            ),
          ],
        ),
      ),
      height: 405,
      index: index,
      //margin: EdgeInsets.all(10),
    );
  }

  Widget ratingBar(int rating) {
    List<Widget> stars = [
      Text(
        "Rating: ",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    ];
    for (int i = 0; i < 5; i++) {
      if (i <= rating)
        stars.add(Icon(
          Icons.star,
          color: Colors.yellow,
        ));
      else
        stars.add(Icon(Icons.star_border));
    }
    return Container(
      child: Row(
        children: stars,
      ),
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
      controller: _dateTimeController,
      selectableDayPredicate: (date) {
        // Disable weekend days to select from the calendar
        if (date.weekday == 7) {
          return false;
        }

        return true;
      },
      onChanged: (val) => print("change" + val),
      validator: (val) {
        print("vali" + val);
        return null;
      },
      onSaved: (val) => dateTime = val.toString(),
    );
  }
}
