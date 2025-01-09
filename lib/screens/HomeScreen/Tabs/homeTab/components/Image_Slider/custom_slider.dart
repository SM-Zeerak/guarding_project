import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:guarding_project/utils/color_utils.dart';

class CustomSlider extends StatefulWidget {
  final List<String> image;

  const CustomSlider({super.key, required this.image});
  @override
  _CustomSliderState createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Image Slider
        PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          // itemCount: _images.length,
          itemCount: widget.image.length,
          itemBuilder: (context, index) {
            return Padding(
               padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: Container(
                decoration: BoxDecoration(
                     boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 8.0,
                      offset: Offset(4, 4),
                    ),
                  ],
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: AssetImage(
                        widget.image[index],
                      ),
                      fit: BoxFit.cover,
                    )),
              ),
            );
          },
        ),
        // "1 of 3" Indicator
        Positioned(
          bottom: 20,
          child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                // width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      color: Colors.black.withOpacity(0.2),
                      child: Center(
                        child: Text(
                          "${_currentIndex + 1} of ${widget.image.length}",
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                ),
              )),
        ),
        // Dots Indicator
        Positioned(
          bottom: 5,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.image.length, (index) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  height: 8,
                  width:
                      _currentIndex == index ? 20 : 8, // Active dot is larger
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? ClrUtls.primary
                        : Colors.black,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class CustomSlider extends StatefulWidget {
//   @override
//   _CustomSliderState createState() => _CustomSliderState();
// }

// class _CustomSliderState extends State<CustomSlider> {
//   final PageController _pageController = PageController();
//   int _currentIndex = 0;
//   List<String> sliderImages = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchSliderImages();
//   }

//   Future<void> fetchSliderImages() async {
//     QuerySnapshot snapshot = await FirebaseFirestore.instance
//         .collection('slider_images')
//         .get();

//     setState(() {
//       sliderImages = snapshot.docs
//           .map((doc) => doc['url'] as String)
//           .toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (sliderImages.isEmpty) {
//       return Center(child: CircularProgressIndicator());
//     }

//     return Stack(
//       alignment: Alignment.bottomCenter,
//       children: [
//         // Image Slider
//         PageView.builder(
//           controller: _pageController,
//           onPageChanged: (index) {
//             setState(() {
//               _currentIndex = index;
//             });
//           },
//           itemCount: sliderImages.length,
//           itemBuilder: (context, index) {
//             return Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
//               child: Container(
//                 decoration: BoxDecoration(
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.5),
//                       blurRadius: 8.0,
//                       offset: Offset(4, 4),
//                     ),
//                   ],
//                   borderRadius: BorderRadius.circular(20),
//                   image: DecorationImage(
//                     image: NetworkImage(sliderImages[index]),
//                     fit: BoxFit.fill,
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//         // Dots Indicator
//         Positioned(
//           bottom: 5,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: List.generate(sliderImages.length, (index) {
//               return AnimatedContainer(
//                 duration: Duration(milliseconds: 300),
//                 margin: EdgeInsets.symmetric(horizontal: 4.0),
//                 height: 8,
//                 width: _currentIndex == index ? 20 : 8,
//                 decoration: BoxDecoration(
//                   color: _currentIndex == index
//                       ? Colors.blue
//                       : Colors.black,
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//               );
//             }),
//           ),
//         ),
//       ],
//     );
//   }
// }
