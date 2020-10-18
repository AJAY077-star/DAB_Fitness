import 'package:agora_flutter_quickstart/pages/login_page.dart';

import '../provider/auth_model.dart';
import 'package:agora_flutter_quickstart/provider/booking_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  final user;
  ProfilePage(this.user);
  static const routeName = '/profile';
  @override
  Widget build(BuildContext context) {
    final appoinments =
        Provider.of<Booking>(context, listen: false).getAppoinments;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        elevation: 0,
      ),
      body: ListView(
        children: [
          Container(
            color: Colors.lightBlue,
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_circle,
                  size: 50,
                ),
                Text(user.name),
              ],
            ),
          ),
          ListTile(
            leading: Icon(FlutterIcons.notebook_mco),
            title: Text("My Appointments"),
            onTap: () => showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  child: Container(
                    height: 100,
                    child: appoinments.length != 0
                        ? ListView.separated(
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                      content: Text(
                                        'Do you want to cancel the appoinment',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text(
                                            'No',
                                            style: Theme.of(context)
                                                .textTheme
                                                .button,
                                          ),
                                          onPressed: () {
                                            Navigator.of(ctx).pop(false);
                                          },
                                        ),
                                        FlatButton(
                                          child: Text(
                                            'Yes',
                                            style: Theme.of(context)
                                                .textTheme
                                                .button,
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                      subtitle: Text(
                                        appoinments[index].time,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                      // trailing: Text(),
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => SizedBox(
                              height: 10,
                            ),
                            itemCount: appoinments.length,
                          )
                        : Center(
                            child: Text("No Appoinments scheduled",
                                style: Theme.of(context).textTheme.headline2),
                          ),
                  ),
                );
              },
            ),
          ),
          Divider(
            color: Colors.grey,
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Logout of this app"),
            onTap: () => Provider.of<Auth>(context, listen: false)
                .logout()
                .then((value) => Navigator.of(context)
                    .pushReplacementNamed(LoginPage.routeName)),
          ),
        ],
      ),
    );
  }
}
