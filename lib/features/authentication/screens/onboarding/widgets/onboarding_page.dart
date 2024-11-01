import 'package:flutter/material.dart';
import 'package:food/utils/shimmers/shimmer.dart';
import 'package:food/utils/constants/sizes.dart';
import 'package:food/utils/helpers/helper_functions.dart';
import 'package:lottie/lottie.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({
    super.key,
    required this.animationUrl,
    required this.title,
    required this.subTitle,
  });

  final String animationUrl, title, subTitle;

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  static final Map<String, Widget> _animationCache = {};

  @override
  void initState() {
    super.initState();
    _loadLottieAnimation(widget.animationUrl);
  }

  Future<void> _loadLottieAnimation(String url) async {
    if (_animationCache.containsKey(url)) {
      return; // Animation is already cached
    }
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final animation = Lottie.memory(
          response.bodyBytes,
          width: THelperFunctions.screenWidth() * 0.8,
          height: THelperFunctions.screenHeight() * 0.6,
          fit: BoxFit.contain,
        );
        setState(() {
          _animationCache[url] = animation;
        });
      } else {
        throw Exception('Failed to load animation');
      }
    } on SocketException {
      throw SocketException('No Internet connection');
    } on http.ClientException {
      throw http.ClientException('Client error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final animation = _animationCache[widget.animationUrl];

    return Padding(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        children: [
          Container(
            width: THelperFunctions.screenWidth() * 0.8,
            height: THelperFunctions.screenHeight() * 0.6,
            child: Center(
              child: animation ??
                  TShimmerEffect(
                    width: THelperFunctions.screenWidth() * 0.7,
                    height: THelperFunctions.screenHeight() * 0.35,
                  ),
            ),
          ),
          Text(
            widget.title,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          Text(
            widget.subTitle,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
