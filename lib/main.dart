import 'package:google_fonts/google_fonts.dart';
import 'package:agora_flutter_quickstart/pages/videodetail_page.dart';

import './pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './provider/auth_model.dart';
import './provider/booking_model.dart';
import './provider/database_model.dart';
import './pages/launch_page.dart';
import './pages/trainer_page.dart';
import './pages/trainerhome_page.dart';

import './pages/training_page.dart';
import './pages/login_page.dart';
import './pages/signup_page.dart';
import './pages/welcome_page.dart';
import './pages/splashscreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(
          value: DataBase(),
        ),
        ChangeNotifierProxyProvider<Auth, Booking>(
          create: null,
          update: (context, auth, previous) => Booking(
            auth.token,
            auth.userId,
          ),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.white,
          accentColor: Colors.blue[400],
          backgroundColor: Colors.white,
          buttonColor: Colors.lightBlue[300],
          appBarTheme: AppBarTheme(
              color: Colors.white, elevation: 4, shadowColor: Colors.grey),
          textTheme: TextTheme(
            headline1: GoogleFonts.openSans(
              color: Colors.white,
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
            subtitle1: GoogleFonts.lato(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            headline2: GoogleFonts.openSans(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            headline3: GoogleFonts.openSans(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            headline4: GoogleFonts.openSans(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
            headline5: GoogleFonts.openSans(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
            bodyText1: GoogleFonts.openSans(
              color: Colors.grey,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
            bodyText2: GoogleFonts.lato(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
            button: GoogleFonts.roboto(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        home: SplashScreen(),
        //home: VideoDetail(),
        // home: Example(),
        routes: {
          WelcomePage.routeName: (ctx) => WelcomePage(),
          LoginPage.routeName: (ctx) => LoginPage(),
          SignUpPage.routeName: (ctx) => SignUpPage(),
          TrainerPage.routeName: (ctx) => TrainerPage(),
          HomePage.routeName: (ctx) => HomePage(),
          TrainingPage.routeName: (ctx) => TrainingPage(),
          VideoDetail.routeName: (ctx) => VideoDetail(),
          TrainerHome.routeName: (ctx) => TrainerHome(),
        },
      ),
    );
  }
}
