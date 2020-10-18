import 'package:agora_flutter_quickstart/provider/booking_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/database_model.dart';
import '../widgets/appBar_widget.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import './call_page.dart';

class TrainerHome extends StatefulWidget {
  static const routeName = '/trainerHome';

  @override
  _TrainerHomeState createState() => _TrainerHomeState();
}

class _TrainerHomeState extends State<TrainerHome> {
  String dateTime;
  String title;
  var _isInit = true;
  ClientRole _role = ClientRole.Broadcaster;
  var _isLoading = false;
  List appoinments;
  List liveClasses;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Booking>(context, listen: false)
          .getMyAppoinments()
          .then((value) => appoinments =
              Provider.of<Booking>(context, listen: false).getAppoinments)
          .then(
            (_) => Provider.of<Booking>(context, listen: false)
                .loadLiveClassTrainer()
                .then((value) {
              liveClasses =
                  Provider.of<Booking>(context, listen: false).getLiveClass;
              setState(() {
                _isLoading = false;
              });
            }),
          );
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void liveClass(final trainerName) {
    _formKey.currentState.save();
    List<String> dateTimeSplit = dateTime.split(" ");
    Provider.of<Booking>(context, listen: false)
        .startLiveClass(dateTimeSplit[0], dateTimeSplit[1], trainerName, title)
        .then((value) {
      appoinments = value;
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Class Scheduled"),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final trainer = Provider.of<DataBase>(context, listen: false).getTrainer;
    print("data" + appoinments.toString());
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).backgroundColor,
            ),
          )
        : Scaffold(
            extendBody: true,
            key: _scaffoldKey,
            //backgroundColor: const Color(0xff000000),
            backgroundColor: Theme.of(context).backgroundColor,
            body: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: CustomScrollView(
                slivers: [
                  MyAppbar("Hello, ${trainer.name}", "Home", false, trainer),
                  SliverFillRemaining(
                    child: buildPage(),
                  )
                ],
              ),
            ),
            bottomSheet: Consumer<Booking>(
              builder: (context, value, child) => SolidBottomSheet(
                elevation: 4,
                toggleVisibilityOnTap: true,
                headerBar: Container(
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_drop_up),
                      Text("My Classes"),
                      Icon(Icons.arrow_drop_up),
                    ],
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xff00e0ff),
                        const Color(0xff095e79),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                body: appoinments.length != 0
                    ? ListView.builder(
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: ValueKey(index),
                            background: Container(
                              color: Theme.of(context).errorColor,
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 40,
                              ),
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 20),
                              margin: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 4,
                              ),
                            ),
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (direction) {
                              return showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text('Are you sure?'),
                                  content: Text(
                                    'Do you want to cancel the appoinment',
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('No'),
                                      onPressed: () {
                                        Navigator.of(ctx).pop(false);
                                      },
                                    ),
                                    FlatButton(
                                      child: Text('Yes'),
                                      onPressed: () {
                                        Navigator.of(ctx).pop(true);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                            onDismissed: (direction) {},
                            child: Card(
                              margin: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 4,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: ListTile(
                                  leading: Icon(Icons.alarm_on),
                                  title: Text(
                                    liveClasses[index].date,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: Text(
                                    liveClasses[index].title,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  trailing: RaisedButton(
                                    child: Text("Join"),
                                    onPressed: () {
                                      onJoin(liveClasses[index].channelName);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: liveClasses.length,
                      )
                    : Center(
                        child: Text(
                          "No Live Classes are scheduled",
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ),
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Container(
                          height: 300,
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Class Title",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter the Class Title',
                                  ),
                                  onSaved: (value) => title = value,
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                buildDateTimePicker(),
                                SizedBox(
                                  height: 50.0,
                                ),
                                SizedBox(
                                  width: 320.0,
                                  child: RaisedButton(
                                    onPressed: () => liveClass(trainer.name),
                                    child: Text(
                                      "Post",
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
                    ),
                  );
                },
              ),
              label: Text("Live Class"),
              icon: Icon(Icons.live_tv),
            ),
          );
  }

  Widget buildPage() {
    return ListView.separated(
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(10),
          elevation: 5,
          child: Container(
            height: 200,
            child: Column(
              children: [
                Text(
                  appoinments[index].user,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Date: ${appoinments[index].date}\n Time: ${appoinments[index].time}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(),
                Text(
                  appoinments[index].address,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  color: Colors.red,
                  onPressed: () {},
                )
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(
          height: 20,
        );
      },
      itemCount: appoinments.length,
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
      onSaved: (val) => dateTime = val.toString(),
    );
  }

  Future<void> onJoin(String channelName) async {
    if (channelName.isNotEmpty) {
      // await for camera and mic permissions before pushing video page
      await _handleCameraAndMic();
      // push video page with given channel name
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(
            channelName: channelName,
            role: _role,
          ),
        ),
      );
    }
  }

  Future<void> _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }
}
