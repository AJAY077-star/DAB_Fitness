import '../utils/Strings.dart';
import './welcome_page.dart';
import 'package:flutter/material.dart';

class LaunchPage extends StatefulWidget {
  @override
  _LaunchPageState createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  PageController _pageController;
  int currentIndex = 0;
  int currentImage = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: currentIndex != 3
            ? <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 20, top: 20),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  WelcomePage()));
                    },
                    child: Text(
                      'Skip',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                )
              ]
            : null,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          PageView(
            onPageChanged: (int page) {
              setState(() {
                currentIndex = page;
              });
            },
            controller: _pageController,
            children: <Widget>[
              makePage(
                  image: 'assets/images/launch-4.png',
                  title: Strings.stepOneTitle,
                  content: Strings.stepOneContent),
              makePage(
                  reverse: true,
                  image: 'assets/images/launch-1.png',
                  title: Strings.stepTwoTitle,
                  content: Strings.stepTwoContent),
              makePage(
                  image: 'assets/images/launch-3.jpg',
                  title: Strings.stepThreeTitle,
                  content: Strings.stepThreeContent),
              makePage(
                  image: 'assets/images/launch-2.jpg',
                  title: Strings.stepThreeTitle,
                  content: ""),
              //buildLastPage(),
            ],
          ),
          Container(
            margin: EdgeInsets.only(bottom: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildIndicator(),
            ),
          )
        ],
      ),
    );
  }

  Widget makePage({image, title, content, reverse = false}) {
    return Container(
      padding: EdgeInsets.only(left: 50, right: 50, bottom: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          !reverse
              ? Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Image.asset(image),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                )
              : SizedBox(),
          SizedBox(
            height: 20,
          ),
          Text(
            content,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          if (currentIndex == 3)
            RaisedButton(
              onPressed: () => Navigator.of(context)
                  .pushReplacementNamed(WelcomePage.routeName),
              child: Text(
                "Get Started !!!",
                style: Theme.of(context).textTheme.button,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Colors.tealAccent[400],
            ),
          reverse
              ? Column(
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Image.asset(image),
                    ),
                  ],
                )
              : SizedBox(),
        ],
      ),
    );
  }

  void handleTap() {
    if (currentImage < 4)
      setState(() {
        currentImage = currentImage + 1;
      });
    else if (currentImage == 4)
      setState(() {
        currentImage = 0;
      });
  }

  Widget buildLastPage() {
    int tapCount = 0;
    final List<String> image = [
      'assets/images/icon1.jpg',
      'assets/images/icon2.jpg',
      'assets/images/icon3.jpg',
      'assets/images/icon4.jpg',
    ];
    final colors = [Colors.red, Colors.blue, Colors.green, Colors.pink];
    return Container(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            // child: Image.asset(
            //   image[currentImage],
            // ),
            child: Icon(
              Icons.ac_unit,
              color: colors[currentImage],
            ),
          ),
          GestureDetector(
            onTap: () {
              switch (tapCount) {
                case 3:
                  handleTap();
                  break;
                case 6:
                  handleTap();
                  break;
                case 9:
                  handleTap();
                  break;
                case 12:
                  handleTap();
                  break;
              }
              if (tapCount > 12) tapCount = 0;
              tapCount++;
            },
            child: Container(
              width: 100,
              height: 50,
              color: Colors.blue,
              child: Center(child: Text("Tap!!!")),
            ),
          ),
        ],
      ),
    );
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: 6,
      width: isActive ? 30 : 6,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
          color: Colors.orange, borderRadius: BorderRadius.circular(5)),
    );
  }

  List<Widget> _buildIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < 4; i++) {
      if (currentIndex == i) {
        indicators.add(_indicator(true));
      } else {
        indicators.add(_indicator(false));
      }
    }

    return indicators;
  }
}
