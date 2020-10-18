import 'package:agora_flutter_quickstart/widgets/videoplayer_widget.dart';
import 'package:flutter/material.dart';
import 'package:shape_of_view/shape_of_view.dart';

class VideoDetail extends StatelessWidget {
  static const routeName = '/videodetail';
  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context).settings.arguments as Map;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Color(0x00000000),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 900,
          child: Stack(
            children: [
              Container(
                height: 300,
                width: double.infinity,
                child: ShapeOfView(
                  elevation: 5,
                  shape: ArcShape(
                    position: ArcPosition.Bottom,
                    direction: ArcDirection.Inside,
                    height: 50,
                  ),
                  child: Image.asset(
                    data['image'],
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Positioned(
                top: 100,
                left: 5,
                child: Card(
                  margin: const EdgeInsets.only(
                    top: 150,
                  ),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.elliptical(300, 40),
                      topRight: Radius.elliptical(300, 40),
                    ),
                  ),
                  child: Container(
                    height: 700,
                    width: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.elliptical(300, 40),
                        topRight: Radius.elliptical(300, 40),
                      ),
                    ),
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  data['category'],
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(
                                  "30 mins",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 10),
                          child: Text(
                            "Perfect For Training Your Body And Endurance",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, bottom: 10),
                          child: Text(
                            "Programs",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        buildPrograms(data),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPrograms(final data) {
    return Container(
      height: 440,
      margin: const EdgeInsets.only(left: 10, right: 10),
      //padding: const EdgeInsets.only(bottom: 10),
      // color: Colors.blue,
      child: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(
          height: 10,
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
                  child: VideoPlayerApp(data["workouts"][index].videos),
                );
              },
            ),
            child: Card(
              elevation: 5,
              child: Container(
                margin: const EdgeInsets.all(10),
                //width: 100,
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
                          data["workouts"][index].image,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 144,
                      height: 150,
                      child: Text(
                        data["workouts"][index].name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
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
        itemCount: data['workouts'].length,
        //shrinkWrap: true,
      ),
    );
  }
}
