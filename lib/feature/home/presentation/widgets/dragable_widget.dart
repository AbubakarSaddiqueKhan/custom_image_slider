import 'package:flutter/material.dart';

class DragAbleWidget extends StatefulWidget {
  const DragAbleWidget({super.key});

  @override
  State<DragAbleWidget> createState() => _DragAbleWidgetState();
}

class _DragAbleWidgetState extends State<DragAbleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController restoreImageToOriginalPositionAnimationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    restoreImageToOriginalPositionAnimationController =
        AnimationController(vsync: this, duration: kThemeAnimationDuration);
  }

  @override
  void dispose() {
    restoreImageToOriginalPositionAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
