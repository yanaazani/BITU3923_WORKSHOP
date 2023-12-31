class Patient {
  int patientId = 0;
  String email = "";
  String ic = "";
  String name = "";
  String phone = "";
  String password = "";
  double height = 0.0;
  String gender = "";
  double weight = 0.0;

  Patient(this.patientId, this.email, this.ic, this.name,
      this.phone, this.password, this.gender, this.height, this.weight);

  Patient.fromJson(Map<String, dynamic> json) {
    patientId = json["id"];
    email = json["email"];
    name = json["name"];
    ic = json["ic"];
    phone = json["phone"];
    password = json["password"];
    gender = json["gender"];
    height = double.parse(json["height"]);
    weight = double.parse(json["weight"]);
  }

  int get _Id => patientId;
  set _Id(int value) => patientId = value;

  String get _ic => ic;
  set _ic(String value) => ic = value;

  String get _name => name;
  set _name(String value) => name = value;

  String get _Email => email;
  set _Email(String value) => email = value;

  String get _password => password;
  set _password(String value) => password = value;

  String get _phone => phone;
  set _phone(String value) => phone = value;

  double get _weight => weight;
  set _weight(double value) => weight = value;

  double get _height => height;
  set _height(double value) => height = value;

  String get _gender => gender;
  set _gender(String value) => gender = value;

  Map<String, dynamic> toJson() {
    return {
      "id": patientId,
      "email": email,
      "name": name,
      "ic": ic,
      "phone": phone,
      "password": password,
      "gender": gender,
      "height": height,
      "weight": weight,
    };
  }
}