// import 'package:digital_books/pages/config.dart';
// import 'package:flutter/material.dart';

// import 'pdf_viewer.dart';

// class FooterBookDetails extends StatefulWidget {
//   const FooterBookDetails({Key? key}) : super(key: key);

//   @override
//   _FooterBookDetailsState createState() => _FooterBookDetailsState();
// }

// class _FooterBookDetailsState extends State<FooterBookDetails> {
//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Container(
//         decoration: BoxDecoration(
//             color: Colors.blue[100],
//             border: Border.all(color: Colors.blue, width: 5),
//             borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(45), topRight: Radius.circular(45))),
//         child: SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Row(
//             children: [
//               Container(
//                 alignment: Alignment.bottomRight,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     MaterialButton(
//                       onPressed: () {
//                         Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => PdfViewPage(
//                                     url:
//                                         "http://192.168.1.103/upload_video_tutorial/pdf/" +
//                                             pdfList[index]["pdffile"],
//                                     name: pdfList[index]["name"],
//                                   ),
//                                 ),
//                               );
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                             color: Colors.white,
//                             border: Border.all(color: Colors.blue, width: 3),
//                             borderRadius: BorderRadius.circular(180)),
//                         padding: const EdgeInsets.all(5),
//                         margin: const EdgeInsets.all(5),
//                         alignment: Alignment.center,
//                         width: MediaQuery.of(context).size.width / 3.7,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: const <Widget>[
//                             Text(
//                               " تحميل",
//                               style: TextStyle(
//                                   color: Colors.blue,
//                                   fontSize: 20,
//                                   fontFamily: "Cairo",
//                                   fontWeight: FontWeight.bold),
//                             ),
//                             Icon(
//                               Icons.download,
//                               color: Colors.blue,
//                               size: 30,
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 alignment: Alignment.bottomRight,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     MaterialButton(
//                       onPressed: () {},
//                       child: Container(
//                         decoration: BoxDecoration(
//                             color: Colors.white,
//                             border: Border.all(color: Colors.blue, width: 3),
//                             borderRadius: BorderRadius.circular(180)),
//                         padding: const EdgeInsets.all(5),
//                         margin: const EdgeInsets.all(5),
//                         alignment: Alignment.center,
//                         width: MediaQuery.of(context).size.width / 3.7,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: const <Widget>[
//                             Text(
//                               " قراءة",
//                               style: TextStyle(
//                                   color: Colors.blue,
//                                   fontSize: 20,
//                                   fontFamily: "Cairo",
//                                   fontWeight: FontWeight.bold),
//                             ),
//                             Icon(
//                               Icons.book,
//                               color: Colors.blue,
//                               size: 30,
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                     color: Colors.blue[100],
//                     border: Border.all(color: Colors.blue, width: 3),
//                     borderRadius: BorderRadius.circular(180)),
//                 //padding: const EdgeInsets.all(5),
//                 margin: const EdgeInsets.all(5),
//                 alignment: Alignment.center,
//                 width: MediaQuery.of(context).size.width / 5,
//                 child: IconButton(
//                   alignment: Alignment.center,
//                   icon: Icon(
//                     Icons.favorite,
//                     color: w,
//                     size: 30,
//                   ),
//                   onPressed: () => setState(() {
//                     w = w == Colors.white ? Colors.blue : Colors.white;
//                     b = b == Colors.blue ? Colors.white : Colors.blue;
//                   }),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
