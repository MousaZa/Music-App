import 'package:get/get.dart';

class MainController extends GetxController {

  Duration position = Duration.zero;

  void setPosition(Duration newPosition) {
    position = newPosition;
    update();
  }

  bool isPlaying = true;

  void togglePlaying() {
    isPlaying = !isPlaying;
    update();
  }
}
