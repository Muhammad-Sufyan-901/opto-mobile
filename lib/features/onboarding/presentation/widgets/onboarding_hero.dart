import 'package:flutter/material.dart';

import 'package:ids_elder_rehab_app/core/constants/app_assets.dart';

class OnboardingHero extends StatelessWidget {
  const OnboardingHero({super.key});

  static const Color heroBackgroundColor = Color(0xFFE0F2FE);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          child: ClipPath(
            clipper: _OnboardingBackgroundClipper(),
            child: Container(
              color: heroBackgroundColor,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 60,
          ),
          child: Image.asset(
            AppAssets.onboardingPerson,
            fit: BoxFit.contain,
            width: MediaQuery.of(context).size.width * 0.95,
          ),
        ),
      ],
    );
  }
}

class _OnboardingBackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 40);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
