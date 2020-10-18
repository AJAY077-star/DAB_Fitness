import 'package:flutter/material.dart';
import '../pages/training_page.dart';
import '../pages/profile_page.dart';

class MyAppbar extends StatelessWidget {
  final String content;
  final String title;
  final bool ishome;
  final user;
  MyAppbar(this.content, this.title, this.ishome, this.user);
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      actions: [
        if (user != null)
          IconButton(
            icon: Icon(
              Icons.account_circle,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProfilePage(user),
              ),
            ),
          )
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          //width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(top: 120, right: 17),
          //color: Colors.amber,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
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
          // height: 100,
          width: 500,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 350,
                child: Text(
                  content,
                  style: Theme.of(context).textTheme.headline1,
                  overflow: TextOverflow.clip,
                ),
              ),
              if (ishome)
                InkWell(
                  onTap: () =>
                      Navigator.of(context).pushNamed(TrainingPage.routeName),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                ),
            ],
          ),
        ),
        //centerTitle: true,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      expandedHeight: 200.0,
      floating: true,
      pinned: true,
      snap: true,
      elevation: 50,
      backgroundColor: const Color(0xff00e0ff),
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline2,
      ),
    );
  }
}
