import 'package:flutter/material.dart';
import 'package:arthub_flutter/screens/auth/login_screen.dart';
import 'package:arthub_flutter/config/app_styles.dart';
import 'package:arthub_flutter/widgets/custom_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingContent> _contents = [
    OnboardingContent(
      image: 'images/onboarding1.png',
      title: 'Empowering Artisans, Artist & Designer',
      description: '',
    ),
    OnboardingContent(
      image: 'images/onboarding2.png',
      title: 'Connecting NGOs, Social Enterprises with Communities',
      description: '',
    ),
    OnboardingContent(
      image: 'images/onboarding3.png',
      title: 'Donate, Invest & Support infrastructure projects',
      description: '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _contents.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          _contents[index].image,
                          height: 300,
                        ),
                        const SizedBox(height: 30),
                        Text(
                          _contents[index].title,
                          textAlign: TextAlign.center,
                          style: AppStyles.headingStyle,
                        ),
                        if (_contents[index].description.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Text(
                              _contents[index].description,
                              textAlign: TextAlign.center,
                              style: AppStyles.subheadingStyle,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(
                      _contents.length,
                      (index) => buildDot(index),
                    ),
                  ),
                  CustomButton(
                    text: _currentPage == _contents.length - 1 ? 'Finish' : 'Next',
                    onPressed: () {
                      if (_currentPage == _contents.length - 1) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      }
                    },
                    width: 120,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDot(int index) {
    return Container(
      height: 10,
      width: 10,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index ? Colors.white : Colors.white38,
      ),
    );
  }
}

class OnboardingContent {
  final String image;
  final String title;
  final String description;

  OnboardingContent({
    required this.image,
    required this.title,
    required this.description,
  });
} 