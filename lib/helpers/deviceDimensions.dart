import 'dart:ui';

class Dimension {
  late double deviceHeight;
  late double deviceWidth;

  Dimension(double pixelRatio) {
    var pRatio = pixelRatio;

//Size in physical pixels
    var physicalScreenSize = window.physicalSize;

//Size in logical pixels
    var logicalScreenSize = physicalScreenSize / pRatio;
    var logicalWidth = logicalScreenSize.width;
    var logicalHeight = logicalScreenSize.height;

//Padding in physical pixels
    var padding = window.padding;

//Safe area paddings in logical pixels
    var paddingLeft = padding.left / window.devicePixelRatio;
    var paddingRight = padding.right / window.devicePixelRatio;
    var paddingTop = window.padding.top / window.devicePixelRatio;
    var paddingBottom = window.padding.bottom / window.devicePixelRatio;

//Safe area in logical pixels
    var safeWidth = logicalWidth - paddingLeft - paddingRight;
    var safeHeight = logicalHeight - paddingBottom;

    this.deviceHeight = safeHeight;
    this.deviceWidth = safeWidth;
  }

  double getDeviceHeight() {
    return deviceHeight;
  }

  double getDeviceWidth() {
    return deviceHeight;
  }
}
