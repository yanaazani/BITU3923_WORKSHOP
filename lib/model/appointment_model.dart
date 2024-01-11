import 'package:ui/model/patient_model.dart';
import 'package:ui/model/room_model.dart';

class Appointment {

  int appointmentId = 0;
  String bookingDate = "";
  String bookingTime = "";
  String status = "";
  String serviceType = "";
  int serviceRate = 0;
  Patient patient;
  Room room;

  Appointment({
    required this.appointmentId,
    required this.bookingDate,
    required this.bookingTime,
    required this.status,
    required this.serviceType,
    required this.serviceRate,
    required this.patient,
    required this.room,
  });

  int get _Id => appointmentId;

  set _Id(int value) => appointmentId = value;

  String get _bookingDate => bookingDate;

  set _bookingDate(String value) => bookingDate = value;

  String get _bookingTime => bookingTime;

  set _bookingTime(String value) => _bookingTime = value;

  String get _bookingStatus => status;

  set _bookingstatus(String value) => status = value;

  String get _serviceType => serviceType;

  set _serviceType(String value) => serviceType = value;

  int get _serviceRate => serviceRate;

  set _serviceRate(int value) => serviceRate = value;

  /**
   * Getter and setter for foreign key
   */
  Patient get _patient => patient;

  set _patient(Patient value) => patient = value;

  Room get _room => room;

  set _room(Room value) => room = value;

  Appointment.fromJson(Map<String, dynamic> json)
      :
        appointmentId = json['id'] as int? ?? 0,
        bookingDate = json['bookingDate'],
        bookingTime = json['bookingTime'],
        status = json['status'],
        serviceType = json['serviceType'],
        serviceRate = json['serviceRate'] as int? ?? 0,
        patient = Patient.fromJson(json["patientId"]),
        room = Room.fromJson(json['roomId']);

  Map<String, dynamic> toJson() {
    return {
      'id': appointmentId,
      'bookingDate': bookingDate,
      'bookingTime': bookingTime,
      'status': status,
      'serviceType': serviceType,
      'serviceRate': serviceRate,
      'patientId': patient.toJson(),
      'roomId': room.toJson(),
    };
  }
}
