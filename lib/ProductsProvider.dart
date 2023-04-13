import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'ProductsModel.dart';

class ProductsProvider extends ChangeNotifier {
  List<Datum> allProducts = [];

  void fetchProducts(mode) async {
    try {
      final response =
          await http.get(Uri.parse('https://api.storerestapi.com/products'));
      var jsonResponse = json.decode(response.body);
      if (response.statusCode == 200) {
        // Extract the 'data' array from the response body
        final List<dynamic> productData = jsonResponse['data'];
        allProducts = [];
        for (var productJson in productData) {
          Datum product = Datum(
            id: productJson['_id'],
            title: productJson['title'],
            price: productJson['price'].toDouble(),
            category: Category(
              id: productJson['category']['_id'],
              name: productJson['category']['name'],
              slug: productJson['category']['slug'],
            ),
            description: productJson['description'],
            createdBy: productJson['createdBy']['name'],
            createdAt: DateTime.parse(productJson['createdAt']),
            updatedAt: DateTime.parse(productJson['updatedAt']),
            slug: productJson['slug'],
            image: productJson['image'],
          );
          // Add the created Product object to the products list
          if (mode == '') {
            allProducts.add(product);
            notifyListeners();
          } else if (mode == 'Men') {
            if (product.category.name == "men's fashion") {
              allProducts.add(product);
              notifyListeners();
            }
          } else if (mode == 'Women') {
            if (product.category.name == "women's fashion") {
              allProducts.add(product);
              notifyListeners();
            }
          }
          print(allProducts.length);
        }
      }
    } catch (error) {
      print(error);
    }
  }
}
