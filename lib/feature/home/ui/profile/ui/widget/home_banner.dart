import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeBanner extends StatefulWidget {
  const HomeBanner({super.key});

  @override
  State<HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  int _current = 0;

  static const Color primary = Color(0xFF004182);

  final List<String> _images = [
    'assets/image/Group 11.png',
    'assets/image/Property 1=Variant2.png',
    'assets/image/Property 1=Variant3.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CarouselSlider.builder(
          itemCount: _images.length,
          itemBuilder: (context, index, realIndex) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                _images[index],
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            );
          },
          options: CarouselOptions(
            height: 170,
            viewportFraction: 1,
            autoPlay: false,
            autoPlayInterval: const Duration(seconds: 3),
            onPageChanged: (index, reason) =>
                setState(() => _current = index),
          ),
        ),
        Positioned(
          bottom: 8,
          child: AnimatedSmoothIndicator(
            activeIndex: _current,
            count: _images.length,
            effect: const ScaleEffect(
              dotHeight: 8,
              dotWidth: 8,
              activeDotColor: primary,
              dotColor: Colors.white,
              
            ),
          ),
        ),
      ],
    );
  }
}