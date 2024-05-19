import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:umbrella/presentation/on_boarding/on_boarding_controller.dart';
import 'package:umbrella/presentation/ressources/colors.dart';
import 'package:umbrella/presentation/ressources/dimensions/constants.dart';

import '../Authentication/Sign_in/sign_in.dart';
import 'on_boarding_content.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

PageController _controller = PageController();
int currentPage = 0;
List<Content> contentList = [
  Content(
    img: 'assets/lotties/on1.json',
    description: 'Êtes-vous fatigués de chercher un parasol disponible ? ',
    title: 'Bienvenue chez Sunset View',
  ),
  Content(
    img: 'assets/lotties/on2.json',
    description: "Nous vous proposons l'application mobile Sunset View pour faciliter la tâche.",
    title: '',
  ),
  Content(
    img: 'assets/lotties/on3.json',
    description: 'Rejoignez-nous dès maintenant et explorez notre application.',
    title: '',
  )
];
OnBoardingController onBoardingController = OnBoardingController();

class _OnBoardingPageState extends State<OnBoardingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                  itemCount: contentList.length,
                  scrollDirection: Axis.horizontal, // the axis
                  controller: _controller,
                  itemBuilder: (context, int index) {
                    return contentList[index];
                  }),
            ),
            Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(contentList.length, (int index) {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        height: Constants.screenHeight * 0.01,
                        width: (index == currentPage)
                            ? Constants.screenWidth * 0.08
                            : Constants.screenWidth * 0.04, // condition au lieu de if else
                        margin: EdgeInsets.symmetric(horizontal: 5, vertical: Constants.screenHeight * 0.03),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: (index == currentPage) ? AppColors.CustomGrey : AppColors.primary),
                      );
                    }),
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: Constants.screenWidth * 0.02, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                onBoardingController.check();
                                Get.to(SignInScreen());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.CustomGrey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5), // Adjust the value to change the border radius
                                ),
                              ),
                              child: Text(
                                "Ignorer",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 45,
                                child: ElevatedButton(
                                    onPressed: (currentPage == contentList.length - 1)
                                        ? () {
                                            Get.to(SignInScreen());
                                          }
                                        : () {
                                            onBoardingController.check();
                                            _controller.nextPage(
                                                duration: Duration(milliseconds: 400), curve: Curves.easeInOutQuint);
                                          },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                      backgroundColor: AppColors.primary,
                                    ),
                                    child: (currentPage == contentList.length - 1)
                                        ? Text(
                                            "Commencer",
                                            style: TextStyle(color: Colors.white),
                                          )
                                        : Text(
                                            'Suivant',
                                            style: TextStyle(color: Colors.white),
                                          )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
