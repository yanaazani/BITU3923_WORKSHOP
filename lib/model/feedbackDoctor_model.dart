import 'package:flutter/material.dart';

import '../login.dart';
import 'doctor_model.dart';

class FeedbackDoctor{

  int feedbackDoctorid = 0;
  int rating = 0;
  String review = "";
  Patient patient;
  Doctor doctor;

  FeedbackDoctor({
    required this.feedbackDoctorid,
    required this.rating,
    required this.review,
    required this.patient,
    required this.doctor,
  });

  int get _feedbackDoctorid => feedbackDoctorid;
  set _feedbackDoctorid(int value) => feedbackDoctorid = value;

  int get _rating => rating;
  set _rating(int value) => rating = value;

  String get _review => review;
  set _review(String value) => review = value;

  /**
   * Getter and setter for foreign key
   */
  Patient get _patient => patient;
  set _patient(Patient value) => patient = value;

  Doctor get _doctor => doctor;
  set _doctor(Doctor value) => doctor = value;

  factory FeedbackDoctor.fromJson(Map<String, dynamic> json) {
    return FeedbackDoctor(
      feedbackDoctorid: json['feedbackDoctorid'] ?? 0,
      rating: json['rating'] ?? 0,
      review: json['review'] ?? '',
      patient: Patient.fromJson(json['patientId'] ?? {}),
      doctor: Doctor.fromJson(json['icDoctor'] ?? {}),
    );
  }

}