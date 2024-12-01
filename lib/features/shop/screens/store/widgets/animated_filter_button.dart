import 'package:flutter/material.dart';

class AnimatedFilterButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isSelected;

  const AnimatedFilterButton({
    Key? key,
    required this.label,
    required this.onPressed,
    required this.isSelected,
  }) : super(key: key);

  @override
  _AnimatedFilterButtonState createState() => _AnimatedFilterButtonState();
}

class _AnimatedFilterButtonState extends State<AnimatedFilterButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _dotSizeAnimation;
  late Animation<Color?> _backgroundColorAnimation;
  late Animation<double> _closeIconScaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _dotSizeAnimation = Tween<double>(begin: 20.0, end: 40.0).animate(_controller);
    _backgroundColorAnimation = ColorTween(
      begin: const Color(0xFF272727), // Solid initial color
      end: const Color(0xFF935EB2),
    ).animate(_controller);
    _closeIconScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    if (widget.isSelected) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedFilterButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isSelected) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      borderRadius: BorderRadius.circular(20.0), // Matches the container's border radius
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            height: 40.0,
            constraints: const BoxConstraints(minWidth: 100.0), // Keeps consistent width
            decoration: BoxDecoration(
              color: _backgroundColorAnimation.value,
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(
                color: const Color(0xFF935EB2),
                width: 1.0,
              ),
            ),
            clipBehavior: Clip.hardEdge, // Ensures no child content overflows
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Circular box
                Container(
                  height: _dotSizeAnimation.value,
                  width: _dotSizeAnimation.value,
                  decoration: const BoxDecoration(
                    color: Color(0xFF935EB2),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8.0),
                // Label text
                Flexible(
                  child: Text(
                    widget.label,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                // Cancel icon
                ScaleTransition(
                  scale: _closeIconScaleAnimation,
                  child: InkWell(
                    onTap: () {
                      _controller.reverse();
                      widget.onPressed();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade400,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
