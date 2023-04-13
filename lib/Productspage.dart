import 'package:crud_task/ClockPage.dart';
import 'package:crud_task/ProductsProvider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'ProductsModel.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      final auth = Provider.of<ProductsProvider>(context, listen: false);
      auth.fetchProducts("");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductsProvider>(builder: (context, object, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 163, 60, 182),
          title: const Text('Products'),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ClockPage()));
                },
                icon: Icon(Icons.logout))
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          object.fetchProducts("");
                        });
                      },
                      child: Container(
                        color: Colors.blue,
                        padding: const EdgeInsets.all(8.0),
                        child: const Text(
                          "All ",
                          style: TextStyle(fontSize: 14),
                        ),
                      )),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          object.fetchProducts("Men");
                        });
                      },
                      child: Container(
                        color: Colors.green,
                        padding: const EdgeInsets.all(8.0),
                        child: const Text(
                          "  Men's Fashion ",
                          style: TextStyle(fontSize: 14),
                        ),
                      )),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          object.fetchProducts("Women");
                        });
                      },
                      child: Container(
                        color: Colors.red,
                        padding: const EdgeInsets.all(8.0),
                        child: const Text(
                          "  Women's Fashion",
                          style: TextStyle(fontSize: 14),
                        ),
                      )),
                ],
              ),
            ),
            object.allProducts.isEmpty
                ? const Center(child: Text("No Products Available!"))
                : Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 25,
                      ),
                      itemCount: object.allProducts.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  Image.network(
                                    "https://media.istockphoto.com/id/864505242/photo/mens-clothing-and-personal-accessories.jpg?s=612x612&w=0&k=20&c=TaJuW3UY9IZMijRrj1IdJRwd6iWzXBlrZyQd1uyBzEY=", // Placeholder image URL
                                    height:
                                        MediaQuery.of(context).size.height / 8,
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    fit: BoxFit.fill,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          object.allProducts[index].title,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        Text(
                                          // "\$250.00",
                                          '\$${object.allProducts[index].price.toStringAsFixed(2)}', // Displaying price with 2 decimal places
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    // productController.favoriteProducts.contains(product)
                                    // ? Icons.favorite
                                    // :
                                    Icons.favorite_border,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      );
    });
  }
}
