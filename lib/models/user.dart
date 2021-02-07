class User {
  User(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.contact,
      this.gender,
      this.dateOBirth,
      this.carModel,
      this.registrationNumber,
      this.cnic,
      this.alcs});

  int id;
  String firstName, lastName, email, contact, gender;
  DateTime dateOBirth;
  String carModel, registrationNumber, cnic;
  int alcs;

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        email = json['email'],
        contact = json['contact'],
        gender = json['gender'],
        dateOBirth = json['dateOfBirth'] != null
            ? DateTime.parse(json['dateOfBirth'])
            : null,
        carModel = json['carModel'],
        registrationNumber = json['registrationNumber'],
        cnic = json['cnic'],
        alcs = json['alcs'];
}
