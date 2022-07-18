import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gyroscope_card/Constants/image_constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (
      context,
      orientation,
      screenType,
    ) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      );
    });
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  AccelerometerEvent acceleration = AccelerometerEvent(0, 0, 0);
  late StreamSubscription<AccelerometerEvent> _streamSubscription;

  int foreGroundMotionSensitivity = 4;
  int bgMotionSensitivity = 2;

  @override
  void initState() {
    _streamSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        acceleration = event;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomCard(
              acceleration: acceleration,
              bgMotionSensitivity: bgMotionSensitivity,
              fgImage: ImageConstants.mt2,
              bgImage: ImageConstants.jwstImage,
            ),
            CustomCard(
              acceleration: acceleration,
              bgMotionSensitivity: bgMotionSensitivity,
              fgImage: ImageConstants.gojo,
              bgImage: ImageConstants.hollowPurple,
            ),
            CustomCard(
              acceleration: acceleration,
              bgMotionSensitivity: bgMotionSensitivity,
              fgImage: ImageConstants.tanjiro,
              bgImage: ImageConstants.flames,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  const CustomCard({
    Key? key,
    required this.acceleration,
    required this.bgMotionSensitivity,
    required this.bgImage,
    required this.fgImage,
  }) : super(key: key);

  final AccelerometerEvent acceleration;
  final int bgMotionSensitivity;
  final String bgImage;
  final String fgImage;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 100.h / 3,
        maxWidth: 100.w,
        minHeight: 100.h / 3,
        minWidth: 100.w,
      ),
      child: Stack(
        children: <Widget>[
          Image.asset(
            bgImage,
            height: 100.h,
            width: 100.w,
            fit: BoxFit.fill,
          ),
          Positioned(
            top: acceleration.y * bgMotionSensitivity.toDouble(),
            bottom: acceleration.y * -bgMotionSensitivity.toDouble(),
            right: acceleration.x * -bgMotionSensitivity.toDouble(),
            left: acceleration.x * bgMotionSensitivity.toDouble(),
            child: Align(
              child: Image.asset(
                bgImage,
                height: 100.h,
                width: 100.w * 2,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Positioned(
            // top: acceleration.y * foreGroundMotionSensitivity,
            // bottom: acceleration.y * -foreGroundMotionSensitivity,
            // right: acceleration.x * -foreGroundMotionSensitivity,
            // left: acceleration.x * foreGroundMotionSensitivity,
            bottom: 0,
            child: Align(
              child: Image.asset(
                fgImage,
                width: 100.w,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
