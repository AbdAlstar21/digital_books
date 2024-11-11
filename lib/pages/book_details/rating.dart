import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class Rating extends StatefulWidget {
  const Rating({ Key? key }) : super(key: key);

  @override
  _RatingState createState() => _RatingState();
}

class _RatingState extends State<Rating> {

double rating = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
           body:Container(
             child:Column(
              children: 
            [
                   SmoothStarRating(
                  allowHalfRating: true,
                  halfFilledIconData: Icons.star_half,
                  // onRatingChanged: (v) {
                  //   this.rating = v;
                  //   setState(() {});
                  // },
                  starCount: 5,
                  rating: rating,
                  size: 60.0,
                  filledIconData: Icons.star,
                  color: Colors.orange,
                  borderColor: Colors.grey,
                  spacing: 0.0),]),

// TextFormField(labelText: "Review Title (i.e Nice trip)",
//                 ),
// TextFormField(labelText: "Your review...",
//                 ),

// RawMaterialButton(onPressed: (){
//   // ...your submission to rest API here...
//                   },
//                        child: Text(
//                       "Send Review",
//                     ),
)
          
);

  }
}