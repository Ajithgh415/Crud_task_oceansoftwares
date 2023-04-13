// To parse this JSON data, do
//
//     final products = productsFromJson(jsonString);

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

Products productsFromJson(String str) => Products.fromJson(json.decode(str));

String productsToJson(Products data) => json.encode(data.toJson());

class Products {
  Products({
    required this.data,
    required this.status,
    required this.message,
  });

  List<Datum> data;
  int status;
  String message;

  factory Products.fromJson(Map<String, dynamic> json) => Products(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status,
        "message": message,
      };
}

class Datum {
  Datum({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    this.description,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.slug,
    this.image,
  });

  String id;
  String title;
  double price;
  Category category;
  String? description;
  String createdBy;
  DateTime createdAt;
  DateTime updatedAt;
  String slug;
  String? image;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        title: json["title"],
        price: json["price"],
        category: Category.fromJson(json["category"]),
        description: json["description"],
        createdBy: json["createdBy"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        slug: json["slug"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "price": price,
        "category": category.toJson(),
        "description": description,
        "createdBy": createdBy,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "slug": slug,
        "image": image,
      };
}

class Category {
  Category({
    required this.id,
    required this.name,
    required this.slug,
  });

  String id;
  String name;
  String slug;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["_id"],
        name: json["name"],
        slug: json["slug"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "slug": slug,
      };
}

class CreatedBy {
  CreatedBy({
    required this.role,
    required this.id,
    required this.name,
  });

  Role role;
  String id;
  String name;

  factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
        role: roleValues.map[json["role"]]!,
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "role": roleValues.reverse[role],
        "_id": id,
        "name": name,
      };
}

enum Role { ROLE_CUSTOMER, ROLE_SUPER_ADMIN }

final roleValues = EnumValues({
  "ROLE_CUSTOMER": Role.ROLE_CUSTOMER,
  "ROLE_SUPER_ADMIN": Role.ROLE_SUPER_ADMIN
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
