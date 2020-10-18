import 'package:agora_flutter_quickstart/provider/booking_model.dart';
import 'package:agora_flutter_quickstart/widgets/videoplayer_widget.dart';

import '../data.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import '../widgets/appBar_widget.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/database_model.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';
  HomePage() : super();
  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage> with SingleTickerProviderStateMixin {
  var _isInit = true;
  var _isLoading = false;
  var appoinments;
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  //int currentPage = 0;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Booking>(context, listen: false)
          .loadMyAppoinments()
          .then((value) => appoinments =
              Provider.of<Booking>(context, listen: false).getAppoinments)
          .then(
            (value) => setState(
              () {
                _isLoading = false;
              },
            ),
          );
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<DataBase>(context, listen: false).getUser;
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).backgroundColor,
            ),
          )
        : Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            extendBody: true,
            body: Container(
              margin: const EdgeInsets.all(10),
              child: CustomScrollView(
                slivers: [
                  MyAppbar("Hello, ${user.name}", "Home", true, user),
                  SliverFillRemaining(
                    child: buildPage(),
                  )
                ],
              ),
            ),
            // drawer: Drawer(),
            bottomSheet: SolidBottomSheet(
              elevation: 4,
              toggleVisibilityOnTap: true,
              headerBar: Container(
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_drop_up),
                    Text(
                      "Sessions",
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
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
                                title: Text(
                                  'Are you sure?',
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                                content: Text(
                                  'Do you want to cancel the appoinment',
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text(
                                      'No',
                                      style: Theme.of(context).textTheme.button,
                                    ),
                                    onPressed: () {
                                      Navigator.of(ctx).pop(false);
                                    },
                                  ),
                                  FlatButton(
                                    child: Text(
                                      'Yes',
                                      style: Theme.of(context).textTheme.button,
                                    ),
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
                                  appoinments[index].date,
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                                subtitle: Text(
                                  appoinments[index].time,
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                                // trailing: Text(),
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: appoinments.length,
                    )
                  : Center(
                      child: Text("No Appoinments are scheduled",
                          style: Theme.of(context).textTheme.headline3),
                    ),
            ),
          );
  }

  Widget buildPage() {
    var images = [
      'assets/images/1.jpg',
      'assets/images/2.jpg',
      'assets/images/3.jpg',
    ];
    return ListView(
      children: [
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Stack(
            children: [
              Container(
                height: 200,
                child: Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return new Image.asset(
                      images[index],
                      fit: BoxFit.fill,
                    );
                  },
                  itemCount: images.length,
                  pagination: new SwiperPagination(),
                ),
              ),
              Positioned(
                top: 20,
                left: 5,
                child: Container(
                  width: 125,
                  height: 30,
                  child: Text(
                    "Trending",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Colors.red[900], width: 10),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        const Color(0x70434444),
                        const Color(0x20ffffff),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        SizedBox(
          height: 50,
        ),
        buildListHorizontal("Top picks for you"),
        SizedBox(
          height: 20,
        ),
        buildListVertical("5 Minutes work out"),
      ],
    );
  }

  Widget buildListHorizontal(String title) {
    return Stack(
      overflow: Overflow.visible,
      children: [
        Card(
          child: Container(
            height: 250,
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            // color: Colors.blue,
            child: ListView.separated(
              separatorBuilder: (context, index) => SizedBox(
                width: 10,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: VideoPlayerApp(workoutList[index].videos),
                      );
                    },
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        width: 200,
                        height: 200,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            workoutList[index].image,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Text(
                        workoutList[index].name,
                        style: Theme.of(context).textTheme.headline3,
                      )
                    ],
                  ),
                );
              },
              scrollDirection: Axis.horizontal,
              itemCount: workoutList.length,
              shrinkWrap: true,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        Positioned(
          top: -30,
          left: 10,
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              //height: 30,
              padding: const EdgeInsets.all(10),
              child: Text(
                title,
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget buildListVertical(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
        Container(
          height: 500,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          // color: Colors.blue,
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(
              width: 10,
            ),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Container(
                        child: VideoPlayerApp(workoutList[index].videos),
                      ),
                    );
                  },
                ),
                child: Card(
                  elevation: 5,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              workoutList[index].image,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 144,
                          child: Text(
                            workoutList[index].name,
                            style: Theme.of(context).textTheme.headline3,
                            overflow: TextOverflow.clip,
                          ),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Icon(Icons.play_circle_outline),
                      ],
                    ),
                  ),
                ),
              );
            },
            scrollDirection: Axis.vertical,
            itemCount: workoutList.length,
            shrinkWrap: true,
          ),
        ),
      ],
    );
  }
}
//
