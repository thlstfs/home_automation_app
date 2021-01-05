import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_automation/http_service.dart';
import 'package:home_automation/screens/light_screen.dart';
import 'package:home_automation/utils/StatusNavBarColorChanger.dart';
import 'package:home_automation/utils/circle_color_picker.dart';
import 'package:pigment/pigment.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../utils/custom_colors.dart';

class HomeScreen extends StatefulWidget {
  static const id = 'home_screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  PageController _pageController;
  double height;
  bool light = false;
  bool _light = false;
  double lightIntensity = 0.0;
  Color lightColor = Colors.black;
  Color oldLightColor = Colors.white;
  double lightness = 0.5;
  HttpService service = HttpService();

  @override
  void initState() {
    super.initState();
    HttpService.service = service;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    _pageController = PageController();
    service.connect().then((value) {
      setState(() {
        if (value != null && value != Colors.black) {
          lightColor = value;
          oldLightColor = lightColor;
          _light = true;
        } else {
          lightColor = Colors.black;
        }
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    StatusNavBarColorChanger.changeNavBarColor(
      CustomColors.darkGrey,
    );
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: CustomColors.darkPurple,
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            Container(
              child: SafeArea(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Card(
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
                            child: Column(
                              children: [
                                InkWell(
                                  splashColor: Colors.purple[300],
                                  highlightColor: CustomColors.darkPurple,
                                  borderRadius: BorderRadius.circular(
                                    ((2.032 * height) / 100),
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(context, LightScreen.id,
                                            arguments: lightColor)
                                        .then((value) {
                                      setState(() {
                                        StatusNavBarColorChanger
                                            .changeStatusBarColor(
                                          CustomColors.darkGrey,
                                        );
                                        lightColor = value;
                                        oldLightColor = lightColor;
                                        if (value == Colors.black) {
                                          _light = false;
                                        } else {
                                          _light = true;
                                        }
                                      });
                                    });
                                  },
                                  child: Image.asset(
                                    "assets/bulb_gif.gif",
                                    // height: ((6 * height) / 20),
                                    // width: ((6 * height) / 80),
                                  ),
                                ),
                                SwitchListTile(
                                  title: Text(
                                    'Room Light',
                                    style: TextStyle(color: Colors.amber),
                                  ),
                                  activeColor: Colors.amber,
                                  value: _light,
                                  onChanged: (bool value) {
                                    if (value) {
                                      service
                                          .changeColor(color: oldLightColor)
                                          .then((color) {
                                        setState(() {
                                          if (color != null) {
                                            _light = value;
                                          }
                                        });
                                      });
                                    } else {
                                      service
                                          .changeColor(color: Colors.black)
                                          .then((color) {
                                        setState(() {
                                          if (color != null) {
                                            _light = value;
                                          }
                                        });
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(flex: 1, child: Container())
                      ],
                    ),
                  ],
                ),
              ),
              color: CustomColors.darkGrey,
            ),
            Container(
              color: CustomColors.darkGrey,
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        child: BottomNavyBar(
          showElevation: true,
          selectedIndex: _currentIndex,
          backgroundColor: CustomColors.darkGrey,
          onItemSelected: (index) {
            setState(() => _currentIndex = index);
            _pageController.animateToPage(index,
                duration: Duration(milliseconds: 300), curve: Curves.ease);
          },
          items: [
            BottomNavyBarItem(
              inactiveColor: Colors.white,
              icon: Icon(Icons.home),
              title: Text('Home'),
              activeColor: Colors.amber,
            ),
            BottomNavyBarItem(
              inactiveColor: Colors.white,
              icon: Icon(Icons.settings),
              title: Text('Settings'),
              activeColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
