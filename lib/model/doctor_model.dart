/** import 'package:ui/model/patient_model.dart';

class Doctor {

  String firstName = "";
  String lastName = "";
  String email ="";
  int rating = 0;
  String review = "";
  Patient patient;

  Doctor({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.rating,
    required this.review,
    required this.patient,
  });

  String get _firstName => firstName;
  set _firstName(String value) => firstName = value;

  String get _lastName => lastName;
  set _lastName(String value) => lastName = value;

  String get _email => email;
  set _email(String value) => email = value;

  int get _rating => rating;
  set _rating(int value) => rating = value;

  String get _review => review;
  set _review(String value) => review = value;

  /**
   * Getter and setter for foreign key
   */
  Patient get _patient => patient;
  set _patient(Patient value) => patient = value;


  Doctor.fromJson(Map<String, dynamic> json)
      :
        firstName = json['firstName'],
        lastName = json['lastName'],
        email = json['email'],
        rating = json['rating'],
        review = json['review'],
        patient = Patient.fromJson(json["patientId"]),

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'rating': rating,
      'review': review,
      'patientId': patient.toJson(),
    };
  }
}
    **/
