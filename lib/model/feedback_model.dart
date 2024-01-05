import 'package:ui/model/patient_model.dart';

class Feedback {

  int id = 0;
  double loginTroubleRating = 0.0;
  double repairQualityRating = 0.0;
  double efficiencyRating = 0.0;
  double personalProfileRating = 0.0;
  String comment = "";
  Patient patient;

  Feedback({
    required this.loginTroubleRating,
    required this.repairQualityRating,
    required this.efficiencyRating,
    required this.personalProfileRating,
    required this.comment,
    required this.patient,
  });

  int get _Id => id;
  set _Id(int value) => id = value;

  String get _comment => comment;
  set _comment(String value) => comment = value;

  double get _loginTroubleRating => loginTroubleRating;
  set _loginTroubleRating(double value) => loginTroubleRating = value;

  double get _repairQualityRating => repairQualityRating;
  set _repairQualityRating(double value) => repairQualityRating = value;

  double get _efficiencyRating => efficiencyRating;
  set _efficiencyRating(double value) => efficiencyRating = value;

  double get _personalProfileRating => personalProfileRating;
  set _personalProfileRating(double value) => personalProfileRating = value;

  /**
   * Getter and setter for foreign key
   */
  Patient get _patient => patient;
  set _patient(Patient value) => patient = value;

  Feedback.fromJson(Map<String, dynamic> json)
      :
        id = json['id'],
        loginTroubleRating = json['loginTroubleRating'],
        repairQualityRating = json['repairQualityRating'],
        efficiencyRating = json['efficiencyRating'],
        personalProfileRating = json['personalProfileRating'],
        comment = json['comment'],
        patient = Patient.fromJson(json["patientId"]);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'loginTroubleRating': loginTroubleRating,
      'repairQualityRating': repairQualityRating,
      'efficiencyRating': efficiencyRating,
      'personalProfileRating': personalProfileRating,
      'comment': comment,
      'patientId': patient.toJson()
    };
  }
}
