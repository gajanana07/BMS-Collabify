import 'package:classico/onboardcontent.dart';
import 'package:classico/signup.dart';
import 'package:flutter/material.dart';
import 'package:classico/addProject.dart';
import 'package:classico/widget_support.dart';
import 'package:classico/dashboard.dart';
import 'package:classico/message1.dart';
import 'package:classico/message2.dart';
import 'package:classico/profile1.dart';
import 'package:classico/search3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'search.dart';

class Onboard extends StatefulWidget {
  const Onboard({super.key});

  @override
  State<Onboard> createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: contents.length,
              onPageChanged: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (_, i) {
                return Padding(
                  padding:
                      const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height *
                            0.5, // Adjusted height
                        width: double.infinity, // Full width
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              left: MediaQuery.of(context).size.width *
                                  -0.05, // Adjust position to the left
                              child: Image.asset(
                                contents[i].image,
                                height: MediaQuery.of(context).size.height *
                                    0.5, // Adjusted height
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50.0),
                      Text(
                        contents[i].title,
                        style: AppWidget.HeadlineTextFeildStyle(),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        contents[i].description,
                        style: AppWidget.LightTextFeildStyle(),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                contents.length,
                (index) => buildDot(index, context),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (currentIndex == contents.length - 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              }
              _controller.nextPage(
                duration: const Duration(milliseconds: 100),
                curve: Curves.bounceIn,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF009FFF),
                    Colors.blue,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              height: 60,
              margin: const EdgeInsets.all(40),
              width: double.infinity,
              child: Center(
                child: Text(
                  currentIndex == contents.length - 1 ? "Start" : "Next",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10.0,
      width: currentIndex == index ? 18 : 7,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6), color: Colors.black38),
    );
  }
}
