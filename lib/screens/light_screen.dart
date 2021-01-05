import 'package:flutter/material.dart';
import 'package:home_automation/http_service.dart';
import 'package:home_automation/utils/StatusNavBarColorChanger.dart';
import 'package:home_automation/utils/circle_color_picker.dart';
import 'package:home_automation/utils/custom_colors.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class LightScreen extends StatefulWidget {
  static const id = "light_screen";
  final Color color;
  LightScreen({this.color});
  @override
  _LightScreenState createState() => _LightScreenState();
}

class _LightScreenState extends State<LightScreen> {
  double height;
  bool light = false;
  double lightIntensity = 0.0;
  Color lightColor = Colors.white;
  Color oldLightColor = Colors.white;
  Color appBarColor = CustomColors.darkGrey;
  double lightness = 0.5;
  double initialLightness = 0.5;
  HttpService service = HttpService.service;

  @override
  void initState() {
    super.initState();
    setState(() {
      lightColor = widget.color;
      oldLightColor = lightColor;
      appBarColor = lightColor;
      initialLightness = HSLColor.fromColor(lightColor).lightness;
      lightness = initialLightness;
      StatusNavBarColorChanger.changeStatusBarColor(lightColor);
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, lightColor);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          centerTitle: true,
          toolbarHeight: 75,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ((2.032 * height) / 100),
            ),
          ),
          title: Text("Room Light"),
        ),
        backgroundColor: CustomColors.darkGrey,
        body: Container(
          child: SafeArea(
            child: Column(
              children: [
                Card(
                  borderOnForeground: false,
                  margin: EdgeInsets.only(
                    top: ((1.354 * height) / 100),
                    left: ((1.354 * height) / 100),
                    right: ((1.354 * height) / 100),
                    // bottom: ((2.709 * height) / 100),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      ((2.032 * height) / 100),
                    ),
                  ),
                  color: CustomColors.grey,
                  elevation: ((0.406 * height) / 100),
                  child: InkWell(
                    child: Container(
                      padding: EdgeInsets.only(
                        top: ((2.032 * height) / 100),
                        left: ((2.032 * height) / 100),
                        right: ((2.032 * height) / 100),
                        // bottom: ((2.709 * height) / 100),
                      ),
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Row(
                              // mainAxisSize: MainAxisSize.m,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 30),
                                  child: Image.asset(
                                    "assets/bulb.png",
                                    color: lightColor,
                                    height: ((6 * height) / 50),
                                    width: ((6 * height) / 50),
                                  ),
                                ),
                                SleekCircularSlider(
                                    key: Key(
                                        (initialLightness * 100).toString()),
                                    initialValue: initialLightness * 100,
                                    appearance: CircularSliderAppearance(
                                        infoProperties: InfoProperties(
                                            mainLabelStyle: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 27,
                                                color: Color.fromRGBO(
                                                    147, 81, 120, 1.0)))),
                                    onChange: (double value) {
                                      setState(() {
                                        lightness = value / 100;
                                        lightColor =
                                            HSLColor.fromColor(lightColor)
                                                .withLightness(
                                                  lightness * 4 / 5,
                                                )
                                                .toColor();
                                        StatusNavBarColorChanger
                                            .changeStatusBarColor(lightColor);
                                        appBarColor = lightColor;
                                        service.changeColor(color: lightColor);
                                      });
                                      // lightness = value / 100;
                                      print(lightColor);
                                    })
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    splashColor: Colors.purple[300],
                    highlightColor: CustomColors.darkPurple,
                    onTap: () {
                      setState(() {
                        if (lightness > 0) {
                          oldLightColor = lightColor;
                          lightness = 0;
                          initialLightness = 0;
                          lightColor = Colors.black;
                        } else {
                          if (oldLightColor == Colors.black) {
                            oldLightColor = Colors.white;
                          }
                          lightColor = oldLightColor;

                          lightness = HSLColor.fromColor(lightColor).lightness;
                          initialLightness = lightness;
                        }
                        StatusNavBarColorChanger.changeStatusBarColor(
                            lightColor);
                        appBarColor = lightColor;
                        service.changeColor(color: lightColor);
                      });
                    },
                    borderRadius: BorderRadius.circular(
                      ((2.032 * height) / 100),
                    ),
                  ),
                ),
                Card(
                  borderOnForeground: false,
                  margin: EdgeInsets.only(
                    top: ((1.354 * height) / 100),
                    left: ((1.354 * height) / 100),
                    right: ((1.354 * height) / 100),
                    // bottom: ((2.709 * height) / 100),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      ((2.032 * height) / 100),
                    ),
                  ),
                  color: CustomColors.grey,
                  elevation: ((0.406 * height) / 100),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(
                      ((2.032 * height) / 100),
                    ),
                    child: Container(
                      padding: EdgeInsets.only(
                        top: ((2.032 * height) / 100),
                        left: ((2.032 * height) / 100),
                        right: ((2.032 * height) / 100),
                        // bottom: ((2.709 * height) / 100),
                      ),
                      child: Center(
                        child: CircleColorPicker(
                          key: Key(lightness.toString()),
                          textStyle: TextStyle(color: Colors.transparent),
                          initialColor: lightColor,
                          lightness: lightness,
                          onChanged: (color) {
                            StatusNavBarColorChanger.changeStatusBarColor(
                                color);
                            setState(() {
                              lightColor = color;
                              appBarColor = color;
                              initialLightness =
                                  HSLColor.fromColor(color).lightness;
                            });
                            print(color.toString());
                            service.changeColor(color: color);
                          },
                          size: const Size(300, 300),
                          strokeWidth: 10,
                          thumbSize: 60,
                        ),
                      ),
                    ),
                    splashColor: Colors.purple[300],
                    highlightColor: CustomColors.darkPurple,
                    onTap: () {},
                  ),
                )
              ],
            ),
          ),
          color: CustomColors.darkGrey,
        ),
      ),
    );
  }
}
