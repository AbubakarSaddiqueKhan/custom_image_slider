import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:developer' as developers;

Offset getCurrentImageOffsets(int stackIndex, Offset imageDragOffset) {
  switch (stackIndex) {
    case 0:
      return const Offset(-85, 25);
    case 1:
      return const Offset(85, 25);
    case 2:
      return imageDragOffset;
    default:
      return Offset.zero;
  }
}

double getCurrentImageScale(int stackIndex) {
  switch (stackIndex) {
    case 0:
      return 0.95;
    case 1:
      return 0.95;
    case 2:
      return 1;
    default:
      return 1;
  }
}

double getCurrentImageRotation(int stackIndex, double topImageRotationValue) {
  switch (stackIndex) {
    case 0:
      return -pi * 0.1;
    case 1:
      return pi * 0.1;
    case 2:
      return topImageRotationValue;
    default:
      return 0;
  }
}

List<String> images = <String>[
  "assets/images/b1.jpg",
  "assets/images/b2.jpg",
  "assets/images/b3.jpg",
  "assets/images/b4.jpg",
  "assets/images/b5.jpg",
  "assets/images/b6.jpg",
  "assets/images/b7.jpg",
  "assets/images/b11.jpg",
  "assets/images/b12.jpg",
  "assets/images/b13.jpg",
  "assets/images/b14.jpg",
  "assets/images/b15.jpg",
  "assets/images/b16.jpg",
  "assets/images/b17.jpg",
  "assets/images/b18.jpg",
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  Offset topImageTranslateStartOffset = Offset.zero;
  Offset topImageTranslatePanUpdateOffset = Offset.zero;
  double topImageRotationValue = 0;
  final _widgetKey = GlobalKey();
  int currentRemovingImageIndex = 0;

  late AnimationController restoreImageToOriginalPositionAnimationController;

  void onPanStart(DragStartDetails details) {
    if (!restoreImageToOriginalPositionAnimationController.isAnimating) {
      developers.log("Start Moving  .. ${details.globalPosition}");
      setState(() {
        topImageTranslateStartOffset = details.globalPosition;
      });
    }
  }

  void onPanUpdate(DragUpdateDetails details) {
    if (!restoreImageToOriginalPositionAnimationController.isAnimating) {
      setState(() {
        developers.log("Updating ... ${details.globalPosition}");

        topImageTranslatePanUpdateOffset =
            details.globalPosition - topImageTranslateStartOffset;

        if ((details.globalPosition.dx <= 185) &&
            (details.globalPosition.dy >= 200 &&
                details.globalPosition.dy <= 750)) {
          developers.log("Left removed");
          topImageRotationValue = -pi * 0.1;
        } else if (details.globalPosition.dx >= 230 &&
            (details.globalPosition.dy >= 200 &&
                details.globalPosition.dy <= 750)) {
          developers.log("Right removed");
          topImageRotationValue = pi * 0.1;
        } else {
          topImageRotationValue = 0;
        }
      });
    }
  }

  void onPanEnd(DragEndDetails details) {
    developers.log("Pan End ....");

    if (restoreImageToOriginalPositionAnimationController.isAnimating) {
      return;
    }
    restoreImageToOriginalPositionAnimationController.forward();
    setState(() {
      topImageRotationValue = 0;
      if (((details.globalPosition.dx == 0)) &&
          (details.globalPosition.dy >= 300 &&
              details.globalPosition.dy <= 500)) {
        developers.log(
            "removed att  ..... ${details.globalPosition.dx} , ${details.globalPosition.dy}");
        images.removeAt(0);
      } else if (((details.globalPosition.dx >= 350)) &&
          (details.globalPosition.dy >= 300 &&
              details.globalPosition.dy <= 500)) {
        developers.log(
            "removed att  ..... ${details.globalPosition.dx} , ${details.globalPosition.dy}");
        images.removeAt(0);
      }
      // else if (details.globalPosition.dx >= 500 &&
      //     (details.globalPosition.dy >= 300 &&
      //         details.globalPosition.dy <= 500)) {
      //   images.removeAt(0);
      // }
    });
  }

  void restoreAnimationListener() {
    if (restoreImageToOriginalPositionAnimationController.isCompleted) {
      restoreImageToOriginalPositionAnimationController.reset();
      topImageTranslatePanUpdateOffset = Offset.zero;

      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    restoreImageToOriginalPositionAnimationController =
        AnimationController(vsync: this, duration: kThemeAnimationDuration)
          ..addListener(restoreAnimationListener);
  }

  @override
  void dispose() {
    restoreImageToOriginalPositionAnimationController
      ..removeListener(restoreAnimationListener)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Random random = Random();
    final Size(:width, :height) = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(images[2]), fit: BoxFit.contain)),
        alignment: Alignment.center,
        child: Stack(
          key: _widgetKey,
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            3,
            (stackIndex) {
              return GestureDetector(
                onPanStart: onPanStart,
                onPanUpdate: onPanUpdate,
                onPanEnd: onPanEnd,
                child: AnimatedBuilder(
                  animation: restoreImageToOriginalPositionAnimationController,
                  builder: (context, child) {
                    final value = 1 -
                        restoreImageToOriginalPositionAnimationController.value;
                    return Transform.scale(
                      scale: getCurrentImageScale(stackIndex),
                      child: Transform.translate(
                        offset: getCurrentImageOffsets(stackIndex,
                            topImageTranslatePanUpdateOffset * value),
                        child: Transform.rotate(
                          angle: getCurrentImageRotation(
                              stackIndex, topImageRotationValue),
                          child: Container(
                            width: width * 0.5,
                            height: height * 0.275,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                    image: AssetImage(images[stackIndex]))),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}


/**
 * 
 *  // Transform.scale(
            //   scale: 0.9,
            //   child: Transform.translate(
            //     offset: const Offset(85, 25),
            //     child: Transform.rotate(
            //       angle: pi * 0.1,
            //       child: Container(
            //         width: width * 0.55,
            //         height: height * 0.275,
            //         decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(10),
            //             color: Colors.amber),
            //       ),
            //     ),
            //   ),
            // ),
            // GestureDetector(
              // onPanStart: (details) {
              //   developers.log("Start MOving  .. ${details.globalPosition}");
              //   setState(() {
              //     topImageTranslateStartOffset = details.globalPosition;
              //   });
              // },
              // onPanUpdate: (details) {
              //   setState(() {
              //     developers.log("Updating ... ${details.globalPosition}");
              //     topImageTranslatePanUpdateOffset =
              //         details.globalPosition - topImageTranslateStartOffset;
              //   });
              // },
            //   child: Transform.translate(
            //     offset: topImageTranslatePanUpdateOffset,
            //     child: Container(
            //       width: width * 0.55,
            //       height: height * 0.275,
            //       decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(10),
            //           color: Colors.lightGreen),
            //     ),
            //   ),
            // ),

 */