import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Slot {
  final String date;
  final String time;
  final String address;
  final String trainerId;
  final String user;

  Slot({
    @required this.date,
    @required this.time,
    @required this.address,
    @required this.trainerId,
    @required this.user,
  });
}

class LiveClass {
  final String date;
  final String time;
  final String title;
  final String name;
  final String channelName;
  final int participants;
  final String image;

  LiveClass({
    @required this.date,
    @required this.time,
    @required this.title,
    @required this.name,
    @required this.participants,
    @required this.channelName,
    @required this.image,
  });
}

class Booking with ChangeNotifier {
  final authToken;
  final userId;

  List<Slot> bookings = [];
  List<LiveClass> liveClass = [];
  Booking(this.authToken, this.userId);

  List get getAppoinments {
    return bookings;
  }

  List get getLiveClass {
    return liveClass;
  }

  Future<void> book(final date, final time, final address, final trainerId,
      final name) async {
    print(authToken + " " + userId);
    final url =
        'https://dab-fitness.firebaseio.com/$userId.json?auth?auth=$authToken';
    var newTime = time.toString().substring(0, 5);
    final response = await http.post(
      url,
      body: json.encode({
        'Date': date,
        'Time': newTime,
        'Address': address,
        'Id': userId,
        'user': name,
        'TrainerId': trainerId,
      }),
    );

    if (response.statusCode == 200) {
      print("done appoinments");
      bookings.add(Slot(
        address: address,
        trainerId: trainerId,
        date: date,
        time: newTime,
        user: name,
      ));
      return true;
    } else {
      print("failed appoinments");
      return false;
    }
  }

  Future<void> getMyAppoinments() async {
    print("appoinments");
    final trainerUrl =
        'https://dab-fitness.firebaseio.com/appoinments.json?auth=$authToken';
    try {
      final trainerResponse = await http.get(trainerUrl);
      final extractedDataTrainer =
          json.decode(trainerResponse.body) as Map<String, dynamic>;
      print("extrated data " + extractedDataTrainer.toString());
      if (extractedDataTrainer == null) {
        return null;
      }
      extractedDataTrainer.forEach((key, value) {
        var data = extractedDataTrainer[key] as Map;
        data = data.values.first;
        if (userId == data['TrainerId']) {
          bookings.add(
            Slot(
                trainerId: data['TrainerId'],
                address: data['Address'],
                date: data['Date'],
                time: data["Time"],
                user: data['user']),
          );
        }
      });
      print("bookings" + bookings.toString());
      notifyListeners();
    } catch (error) {
      throw (error);
    }
    return;
  }

  Future<void> loadMyAppoinments() async {
    print("appoinments");
    final url =
        'https://dab-fitness.firebaseio.com/appoinments/$userId.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      print("extrated data " + extractedData.toString());
      if (extractedData == null) {
        return null;
      }
      extractedData.forEach((key, value) {
        var data = extractedData[key] as Map;
        //data = data.values.first;
        bookings.add(
          Slot(
              trainerId: data['TrainerId'],
              address: data['Address'],
              date: data['Date'],
              time: data["Time"],
              user: data['user']),
        );
      });
      print("bookings" + bookings.toString());
      notifyListeners();
    } catch (error) {
      throw (error);
    }
    return;
  }

  Future<List> startLiveClass(
      final date, final time, final name, final title) async {
    final url =
        'https://dab-fitness.firebaseio.com/liveClass/$userId.json?auth?auth=$authToken';

    var newTime = time.toString().substring(0, 5);
    print(title);
    final response = await http.post(
      url,
      body: json.encode({
        'Date': date,
        'Time': newTime,
        'Id': userId,
        'user': name,
        'title': title,
        'participants': 0,
        'channelName': userId,
        'image': 'assets/images/Strength.jpg',
      }),
    );

    if (response.statusCode == 200) {
      print("done liveClass");
      liveClass.add(
        LiveClass(
          date: date,
          time: newTime,
          name: name,
          title: title,
          participants: 0,
          image: 'assets/images/Strength.jpg',
          channelName: userId,
        ),
      );
      notifyListeners();
      return liveClass;
    } else {
      print("failed liveClass");
      return liveClass;
    }
  }

  Future<void> loadLiveClass() async {
    print("LiveClass");
    final url =
        'https://dab-fitness.firebaseio.com/liveClass.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      print("extrated data " + extractedData.toString());
      if (extractedData == null) {
        return null;
      }
      extractedData.forEach((key, value) {
        var data = extractedData[key] as Map;
        data = data.values.first;
        liveClass.add(
          LiveClass(
            date: data['Date'],
            time: data['Time'],
            name: data['user'],
            title: data['title'],
            participants: data['participants'],
            image: data['image'],
            channelName: data['channelName'],
          ),
        );
      });
      print("liveClass" + liveClass.toString());
      notifyListeners();
    } catch (error) {
      throw (error);
    }
    return;
  }

  Future<void> loadLiveClassTrainer() async {
    print("LiveClass");
    final url =
        'https://dab-fitness.firebaseio.com/liveClass/$userId.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      print("extrated data " + extractedData.toString());
      if (extractedData == null) {
        return null;
      }
      extractedData.forEach((key, value) {
        var data = extractedData[key] as Map;
        //data = data.values.first;
        liveClass.add(
          LiveClass(
            date: data['Date'],
            time: data['Time'],
            name: data['user'],
            title: data['title'],
            participants: data['participants'],
            image: data['image'],
            channelName: data['channelName'],
          ),
        );
      });
      print("liveClass" + liveClass.toString());
      notifyListeners();
    } catch (error) {
      throw (error);
    }
    return;
  }
}
