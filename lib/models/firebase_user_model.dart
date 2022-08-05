import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FireBaseUserModel {
  String? id;
  String? firstname;
  String? lastname;
  String? gender;
  String? dob;
  String? areaOfInterest;
  String? email;
  String? phone;
  String? address;
  String? country;
  String? state;
  String? pinCode;
  String? username;
  String? password;
  String? confirmPassword;
  String? securityQuestion;
  String? securityAnswer;

  FireBaseUserModel(
      this.id,
      this.firstname,
      this.lastname,
      this.gender,
      this.dob,
      this.areaOfInterest,
      this.email,
      this.phone,
      this.address,
      this.country,
      this.state,
      this.pinCode,
      this.username,
      this.password,
      this.confirmPassword,
      this.securityQuestion,
      this.securityAnswer);

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstname': firstname,
        'lastname': lastname,
        'gender': gender,
        'dob': dob,
        'areaOfInterest': areaOfInterest,
        'email': email,
        'phoneNo': phone,
        'address': address,
        'country': country,
        'state': state,
        'pinCode': pinCode,
        'userName': username,
        'securityQuestion': securityQuestion,
        'securityAnswer': securityAnswer,
      };

  FireBaseUserModel.fromSnapshot(Map snapshot)
      : id = snapshot['id'],
        firstname = snapshot['firstname'],
        lastname = snapshot['lastname'],
        gender = snapshot['gender'],
        dob = snapshot['dob'],
        areaOfInterest = snapshot['areaOfInterest'],
        email = snapshot['email'],
        phone = snapshot['phone'],
        address = snapshot['address'],
        country = snapshot['country'],
        state = snapshot['state'],
        pinCode = snapshot['pinCode'],
        username = snapshot['username'],
        password = snapshot['password'],
        confirmPassword = snapshot['confirmPassword'],
        securityQuestion = snapshot['securityQuestion'],
        securityAnswer = snapshot['securityAnswer'];

  FireBaseUserModel.SignIn(this.email, this.password);
}
