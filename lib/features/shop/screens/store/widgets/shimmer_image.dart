import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerImage extends StatefulWidget {
  final String imageUrl;
  final double width;
  final double height;

  const ShimmerImage({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
  });

  @override
  State<ShimmerImage> createState() => _ShimmerImageState();
}

class _ShimmerImageState extends State<ShimmerImage> {
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Visibility(
          visible: !_isLoading,
          child: FadeInImage.assetNetwork(
            placeholder: 'assets/images/products/chicken pizza.png',
            image: widget.imageUrl,
            width: widget.width,
            height: widget.height,
            fit: BoxFit.cover,
            fadeInDuration: const Duration(milliseconds: 300),
            fadeOutDuration: const Duration(milliseconds: 100),
          ),
        ),
        Visibility(
          visible: _isLoading,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: widget.width,
              height: widget.height,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _checkImage();
  }

  void _checkImage() async {
    final image = NetworkImage(widget.imageUrl);
    image.resolve(const ImageConfiguration()).addListener(
          ImageStreamListener(
            (info, _) {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
              }
            },
            onError: (exception, stackTrace) {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
              }
            },
          ),
        );
  }
}
