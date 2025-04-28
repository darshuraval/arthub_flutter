import 'package:flutter/material.dart';
import 'package:arthub_flutter/screens/auth/login_screen.dart';
// import 'package:arthub_flutter/config/app_styles.dart'; // Uncomment if you have AppStyles
// import 'package:arthub_flutter/widgets/custom_button.dart'; // Uncomment if you have CustomButton

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingContent> _contents = [
    _OnboardingContent(
      image: 'images/onboarding1.png',
      title: 'Empowering Artisans, Artist & Designer',
      description: '',
    ),
    _OnboardingContent(
      image: 'images/onboarding2.png',
      title: 'Connecting NGOs, Social Enterprises with Communities',
      description: '',
    ),
    _OnboardingContent(
      image: 'images/onboarding3.png',
      title: 'Donate, Invest & Support infrastructure projects',
      description: '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF389C88), // Or AppStyles.backgroundColor
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
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        if (_contents[index].description.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Text(
                              _contents[index].description,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
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
                      (index) => _buildDot(index),
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF389C88),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                      ),
                      child: Text(_currentPage == _contents.length - 1 ? 'Finish' : 'Next'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
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

class _OnboardingContent {
  final String image;
  final String title;
  final String description;

  _OnboardingContent({
    required this.image,
    required this.title,
    required this.description,
  });
}