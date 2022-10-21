import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Usage:
// class _MyAppState extends State<MyApp> with DynamicSize {
//   @override
//   Widget build(BuildContext context) {
//     initDynamicSize(context);
//     return Container();
//   }
// }

mixin DynamicSize {
  // check for logical size of the device https://www.ios-resolution.com/
  void initDynamicSize(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(
        390, // iPhone 13 logical width (in points)
        844, // iPhone 13 logical height (in points)
      ),
    );
  }
}

// to import this file use the class given bellow, most of the IDE will automatically import this file.
class ImportScreenUtil {}

// Extension for screen util
// To set differnt font size and different height and width of element based on devices.
// eg. fontSize: 20.spExt
extension SizeExtension on num {
  // setWidth
  double get wExt => w.toDouble();

  // setHeight
  double get hExt => h.toDouble();

  // Set sp with default allowFontScalingSelf = false
  double get spExt => sp.toDouble();

  // % of screen width
  double get swExt => sw.toDouble();

  // % of screen height
  double get shExt => sh.toDouble();
}
