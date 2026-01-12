import 'dart:ui';

import 'package:get/get.dart';

class CardController extends GetxController {

  final double cardHeight = 344;
  final double overlap = 40;

  bool isAnimating = false;
  bool swipeDown = true;

  int selectedCardColorIndex = 0;


  List<List<Color>> cards = [
    [
      Color(0xff24113E),
      Color(0xff24113E),
      // Color(0xff565564),
      Color(0xff641990),
      Color(0xff5B16DF),
    ],
    [
      Color(0xff0D0B2A),
      Color(0xff481928),
      Color(0xffEA3E23),
      Color(0xffF89E26),
    ],
    [
      Color(0xff121630),
      Color(0xff7D13D2),
      Color(0xff5576EF),
      // Color(0xff121630),
      // Color(0xff5CA3F7),
    ],
  ];

  void onSwipe(bool down) async {
    if (isAnimating) return;

      isAnimating = true;
      swipeDown = down;
      update();


    // Wait for animation
    await Future.delayed(const Duration(milliseconds: 260));
      if (down) {
        cards.add(cards.removeAt(0));
      } else {
        cards.insert(0, cards.removeLast());
      }
      isAnimating = false;
      update();
  }
}

class CardInfo{
  List<Color> color;

  CardInfo({required this.color});
}