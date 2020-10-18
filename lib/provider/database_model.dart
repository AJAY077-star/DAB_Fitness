import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class User {
  final String name;
  final String email;
  final String number;
  final String gender;
  final String userId;
  final String address;

  User({
    @required this.name,
    @required this.email,
    @required this.number,
    @required this.gender,
    @required this.userId,
    @required this.address,
  });
}

class Trainer {
  final String name;
  final String age;
  final int rating;
  final String description;
  final String speciality;
  final String number;
  final String email;
  final String gender;
  final String trainerId;
  final String address;
  final String image;
  final int experience;

  Trainer({
    @required this.name,
    @required this.email,
    @required this.age,
    @required this.rating,
    @required this.description,
    @required this.experience,
    @required this.speciality,
    @required this.number,
    @required this.gender,
    @required this.trainerId,
    @required this.address,
    @required this.image,
  });
}

class DataBase with ChangeNotifier {
  User user;
  Trainer trainer;
  List<Trainer> trainersList = [];

  User get getUser {
    return user;
  }

  Trainer get getTrainer {
    return trainer;
  }

  List<Trainer> get getTrainersData {
    return trainersList;
  }

  Future<void> loadTrainers(final authToken) async {
    print("trainers");
    final trainerUrl =
        'https://dab-fitness.firebaseio.com/trainers.json?auth=$authToken';
    try {
      final trainerResponse = await http.get(trainerUrl);
      final extractedDataTrainer =
          json.decode(trainerResponse.body) as Map<String, dynamic>;
      if (extractedDataTrainer == null) {
        return null;
      }
      extractedDataTrainer.forEach((key, value) {
        var data = extractedDataTrainer[key] as Map;
        data = data.values.first;
        trainersList.add(
          Trainer(
            name: data['Name'],
            email: data['email'],
            number: data['Number'],
            gender: data['Gender'],
            age: data['Age'],
            description: data['Description'],
            speciality: data['Speciality'],
            trainerId: data['Id'],
            address: data['Address'],
            rating: data['rating'],
            image: data['Image'],
            experience: data['experience'],
          ),
        );
      });
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<int> loadData(final authToken, final userId) async {
    final userUrl =
        'https://dab-fitness.firebaseio.com/users.json?auth=$authToken';
    final trainerUrl =
        'https://dab-fitness.firebaseio.com/trainers.json?auth=$authToken';
    try {
      final userResponse = await http.get(userUrl);
      final extractedDataUser =
          json.decode(userResponse.body) as Map<String, dynamic>;
      if (extractedDataUser != null) {
        if (extractedDataUser.containsKey(userId)) {
          var data = extractedDataUser[userId] as Map;
          data = data.values.first;
          user = User(
            name: data['Name'],
            email: data['email'],
            number: data['Number'],
            gender: data['Gender'],
            userId: userId,
            address: data['Address'],
          );
          await loadTrainers(authToken);
          return 1;
        }
      }
      final trainerResponse = await http.get(trainerUrl);
      final extractedDataTrainer =
          json.decode(trainerResponse.body) as Map<String, dynamic>;
      if (extractedDataTrainer != null) {
        if (extractedDataTrainer.containsKey(userId)) {
          var data = extractedDataTrainer[userId] as Map;
          data = data.values.first;
          print(data);
          trainer = Trainer(
            name: data['Name'],
            email: data['email'],
            number: data['Number'],
            gender: data['Gender'],
            age: data['Age'],
            description: data['Description'],
            speciality: data['Speciality'],
            trainerId: userId,
            address: data['Address'],
            rating: data['rating'],
            image: data['Image'],
            experience: data['experience'],
          );
          return 2;
        }
      }
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> registerUserData(
      final authToken, final userId, final data) async {
    final url =
        'https://dab-fitness.firebaseio.com/users/$userId.json?auth=$authToken';
    final timestamp = DateTime.now();
    print(data);
    final response = await http.post(
      url,
      body: json.encode({
        'DateTime': timestamp.toIso8601String(),
        'Name': data['Name'],
        'Email': data['email'],
        'Number': data['Number'],
        'Gender': data['Gender'],
        'Address': data['Address'],
        'Id': userId,
      }),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> registerTrainerData(
      final authToken, final userId, final data) async {
    final url =
        'https://dab-fitness.firebaseio.com/trainers/$userId.json?auth=$authToken';
    final timestamp = DateTime.now();
    print(data);
    final response = await http.post(
      url,
      body: json.encode({
        'DateTime': timestamp.toIso8601String(),
        'Name': data['Name'],
        'Email': data['email'],
        'Age': data['Age'],
        'Number': data['Number'],
        'Gender': data['Gender'],
        'Description': data['Description'],
        'Speciality': data['Speciality'],
        'Address': data['Address'],
        'Id': userId,
        'rating': 4,
        'Image': 'assets/images/Drake.jpg',
        'experience': 2,
      }),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
