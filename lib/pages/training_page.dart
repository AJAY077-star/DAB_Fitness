import 'package:agora_flutter_quickstart/pages/trainer_page.dart';
import 'package:agora_flutter_quickstart/pages/videodetail_page.dart';
import 'package:agora_flutter_quickstart/widgets/appBar_widget.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import '../data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:expansion_card/expansion_card.dart';
import 'package:provider/provider.dart';
import '../provider/database_model.dart';
import '../provider/booking_model.dart';
import './call_page.dart';

class TrainingPage extends StatefulWidget {
  static const routeName = '/trainingPage';
  @override
  _TrainingPageState createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage>
    with SingleTickerProviderStateMixin {
  PageController _pageController;
  int activePage;
  ClientRole _role = ClientRole.Broadcaster;
  var _isInit = true;
  var _isLoading = false;
  List dataList;
  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    activePage = 0;
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Booking>(context, listen: false)
          .loadLiveClass()
          .then((value) => dataList =
              Provider.of<Booking>(context, listen: false).getLiveClass)
          .then((value) {
        setState(
          () {
            _isLoading = false;
          },
        );
        print("dataList " + dataList[0].toString());
      });
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).backgroundColor,
            ),
          )
        : Scaffold(
            body: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: CustomScrollView(
                slivers: [
                  MyAppbar("Choose your Way", "Trainings", false, null),
                  SliverToBoxAdapter(
                    child: buildPageIndicator(),
                  ),
                  // Divider(),
                  SliverFillRemaining(
                    child: PageView(
                      children: [
                        page_1(),
                        page_2(),
                        page_3(),
                      ],
                      controller: _pageController,
                      onPageChanged: (index) {
                        if (index != activePage) {
                          setState(() {
                            activePage = index;
                          });
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          );
  }

  Widget buildPageIndicator() {
    return Card(
      color: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(30),
          right: Radius.circular(30),
        ),
      ),
      elevation: 4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          RaisedButton(
            onPressed: activePage == 0 ? () {} : null,
            child: Text(
              "In-Personal",
              style: Theme.of(context).textTheme.bodyText2,
            ),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(30),
                right: Radius.circular(30),
              ),
            ),
            disabledElevation: 0,
            disabledColor: Colors.grey,
          ),
          RaisedButton(
            onPressed: activePage == 1 ? () {} : null,
            child: Text(
              "Videos",
              style: Theme.of(context).textTheme.bodyText2,
            ),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(30),
                right: Radius.circular(30),
              ),
            ),
            disabledElevation: 0,
            disabledColor: Colors.grey,
          ),
          RaisedButton(
            onPressed: activePage == 2 ? () {} : null,
            child: Text(
              "Online Classes",
              style: Theme.of(context).textTheme.bodyText2,
            ),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(30),
                right: Radius.circular(30),
              ),
            ),
            disabledElevation: 0,
            disabledColor: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget page_1() {
    List<Widget> children = [
      Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Text(
          "Featured Workout Collections",
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Text(
          "Get Guidance to reach your goals",
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    ];

    for (int i = 0; i < workOutCategoryData.length; i++) {
      children.add(buildWorkout(workOutCategoryData[i]));
    }
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: ListView.separated(
        itemBuilder: (context, index) {
          return children[index];
        },
        itemCount: children.length,
        separatorBuilder: (context, index) => SizedBox(
          height: 10,
        ),
      ),
    );
  }

  Widget page_2() {
    var images = [
      'assets/images/6.jpg',
      'assets/images/11.jpg',
      'assets/images/12.jpg',
    ];
    List<Widget> children = [
      Container(
        height: 200,
        margin: const EdgeInsets.all(10),
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
      SizedBox(
        height: 20,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(
          "What's New",
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
      SizedBox(
        height: 20,
      ),
    ];
    for (int i = 0; i < offlineVideosData.length; i++) {
      children.add(buildVideos(offlineVideosData[i]));
    }
    return ListView(
      children: children,
    );
  }

  Widget buildVideos(final data) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(
        VideoDetail.routeName,
        arguments: {
          'category': data.category,
          'workouts': data.workouts,
          'image': data.image,
        },
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          height: 200,
          width: 400,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                //color: Colors.red,
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  data.category,
                  style: Theme.of(context).textTheme.headline3,
                ),
                width: 150,
              ),
              Divider(),
              Container(
                width: 240,
                height: 200,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      data.image,
                      fit: BoxFit.fill,
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0x50828585),
                            const Color(0x20e3e3e3),
                          ],
                        ),
                      ),
                    ),
                    Icon(
                      Icons.play_circle_outline,
                      color: Colors.grey,
                      size: 50,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget page_3() {
    return dataList.length != 0
        ? ListView.builder(
            itemBuilder: (context, index) => buildClass(dataList[index]),
            itemCount: dataList.length,
          )
        : Center(
            child: Text("No Live Classes are available",
                style: Theme.of(context).textTheme.headline3),
          );
  }

  Widget buildWorkout(final data) {
    final trainers =
        Provider.of<DataBase>(context, listen: false).getTrainersData;
    return InkWell(
      onTap: () => Navigator.of(context)
          .pushNamed(TrainerPage.routeName, arguments: trainers),
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Container(
          height: 200,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  data.image,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                child: Text(
                  data.name,
                  style: Theme.of(context).textTheme.headline5,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildClass(final data) {
    print("buildClass" + data.toString());
    return Container(
      margin: const EdgeInsets.all(10),
      child: ExpansionCard(
        borderRadius: 20,
        //backgroundColor: Colors.blue,
        trailing: Icon(
          Icons.arrow_drop_down,
          color: Colors.black,
        ),
        onExpansionChanged: (value) {},
        background: Image.asset(
          data.image,
          fit: BoxFit.fill,
          height: 300,
        ),
        title: Container(
          margin: EdgeInsets.only(top: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                data.title,
                style: Theme.of(context).textTheme.headline5,
              ),
              Text(
                data.name,
                style: Theme.of(context).textTheme.headline2,
              ),
            ],
          ),
        ),
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(10),
            height: 150,
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 250,
                        child: Row(
                          children: [
                            Icon(Icons.access_time),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "${data.date}, ${data.time}",
                              style: Theme.of(context).textTheme.headline2,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 250,
                        child: Row(
                          children: [
                            Icon(Icons.account_circle),
                            SizedBox(
                              width: 30,
                            ),
                            Text(
                              "${data.participants} Attendees",
                              style: Theme.of(context).textTheme.headline2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                RaisedButton(
                  child: Text(
                    "Join",
                    style: Theme.of(context).textTheme.button,
                  ),
                  onPressed: () {
                    onJoin(data.channelName);
                  },
                  color: Colors.white,
                )
              ],
            ),
          ),
        ],
      ),
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
