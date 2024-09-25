import 'package:example/home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import 'components/animation_header_usecase.dart';

void main() {
  runApp(const WidgetbookApp());
}

class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  // final _devices = [
  //   DeviceInfo.genericPhone(
  //     platform: TargetPlatform.android,
  //     id: 'android',
  //     name: 'Android',
  //     screenSize: const Size(393, 786),
  //     pixelRatio: 2.75,
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      addons: [
        InspectorAddon(),
        if (kIsWeb) ZoomAddon(),
        if (kIsWeb)
          DeviceFrameAddon(
            devices: [
              Devices.ios.iPhone13ProMax,
            ],
            initialDevice: Devices.ios.iPhone13ProMax,
          ),
      ],
      directories: [
        HomeUsecase(),
        AnimationHeaderUsecase()
      ],
      initialRoute: '/?path=learning-ds',
    );
  }
}
