import 'dart:math';

import 'package:digital_books/pages/categories/category_data.dart';
import 'package:digital_books/pages/components/progres.dart';
import 'package:digital_books/pages/config.dart';
import 'package:digital_books/pages/provider/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_network/image_network.dart';
import 'package:provider/provider.dart';
import '../books/books_cat.dart';
import '../function.dart';
class SingleCategory extends StatelessWidget {
  int cat_index;
  CategoryData categories;
  SingleCategory({
    required this.cat_index,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    var providerCategory = Provider.of<LoadingControl>(context);
    return MaterialButton(
      padding: const EdgeInsets.only(top: 2, bottom: 2),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BooksCategory(
                    cat_id: categories.cat_id, cat_name: categories.cat_name)));
      },
      child: Card(
        child: Column(
          children: <Widget>[
           
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4.0),
                  margin: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    color: Colors
                        .primaries[Random().nextInt(Colors.primaries.length)],
                  ),
                  child: categories.cat_thumbnail == ""
                      ? ImageNetwork(
                          image: imageCategory + "category.png",
                          height: 90,
                          width: 75,
                          onLoading: const CircularProgressIndicator(
                            color: Colors.indigoAccent,
                          ),
                          onError: const Icon(
                            Icons.error,
                            color: Colors.red,
                          ),
                        )
                      : ImageNetwork(
                          image: imageCategory + categories.cat_thumbnail,
                          height: 90,
                          width: 75,
                          onLoading: CircularProgressIndicator(
                            color: Colors.indigoAccent,
                          ),
                          onError: const Icon(
                            Icons.error,
                            color: Colors.red,
                          ),
                        ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text(
                      categories.cat_name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 25),
                    ),
                    subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(categories.cat_date),
                          
                        ]),
                    // trailing: SizedBox(
                    //   width: 30.0,
                    //   child: Row(
                    //     children: <Widget>[
                    //       GestureDetector(
                    //         onTap: () {
                    //           Navigator.push(
                    //               context,
                    //               MaterialPageRoute(
                    //                   builder: (context) => EditCategory(
                    //                       cat_index: cat_index,
                    //                       mycategory: categories)));
                    //         },
                    //         child: Container(
                    //           padding: const EdgeInsets.all(5),
                    //           child: const Icon(
                    //             Icons.edit,
                    //             color: Colors.white,
                    //             size: 16,
                    //           ),
                    //           decoration: BoxDecoration(
                    //               color: Colors.blue,
                    //               borderRadius: BorderRadius.circular(5.0)),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ),
                ),
              ],
            ),

            // Divider(
            //   color: Colors.grey[500],
            // )
          ],
        ),
      ),
    );
  }
}
