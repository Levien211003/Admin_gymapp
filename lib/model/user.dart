import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class User {
  final int id;
  final String username;
  final String email;
  final String password;
  final int? age;
  final double? height;
  final double? weight;
  final String? gender;
  final String? mucTieu;
  final String? fullname;
  final String? nickname;
  final String? mobileNumber;
  final String? image;
  final String? level;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    this.age,
    this.height,
    this.weight,
    this.gender,
    this.mucTieu,
    this.fullname,
    this.nickname,
    this.mobileNumber,
    this.image,
    this.level,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      age: json['age'],
      height: json['height']?.toDouble(),
      weight: json['weight']?.toDouble(),
      gender: json['gender'],
      mucTieu: json['mucTieu'],
      fullname: json['fullname'],
      nickname: json['nickname'],
      mobileNumber: json['mobileNumber'],
      image: json['image'],
      level: json['level'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'age': age,
      'height': height,
      'weight': weight,
      'gender': gender,
      'mucTieu': mucTieu,
      'fullname': fullname,
      'nickname': nickname,
      'mobileNumber': mobileNumber,
      'image': image,
      'level': level,
    };
  }
}