import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';



class FlipWidget extends StatefulWidget {
  final Widget child;
  final double flipAnimation;
  final double translateY;

  const FlipWidget({
    required this.child,
    required this.flipAnimation,
    required this.translateY,
  });

  @override
  State<FlipWidget> createState() => _FlipWidgetState();
}

class _FlipWidgetState extends State<FlipWidget> with SingleTickerProviderStateMixin{

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _animation = Tween<double>(begin: 0.0, end: 20.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.repeat(reverse: true);

    // Stop the animation after one minute (60 seconds)
    Timer(const Duration(seconds: 2), () {
      _controller.stop();
    });
  }

  bool _isFront = true;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Transform(
        alignment: Alignment.center,
        origin: Offset(0.5, 0.5),
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.002)
          ..rotateY(widget.flipAnimation * pi)
          ..translate(0.0, widget.translateY),
        child: Stack(
          children: [
            Positioned(
              child: widget.child,
            ),
            Positioned(
              top: 30,
              left: 30,
              child: Center(
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(seconds: 7),
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0.0, 10.0 * (1 - value)!),
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.002)
                            ..rotateY(_isFront
                                ? 0
                                : pi), // Rotate horizontally based on _isFront
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _buildAnimatedTextWithIcon(
                                '100',
                                "Coins",
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedTextWithIcon(String? text, icon) {
    return TweenAnimationBuilder<double>(
      duration: Duration(seconds: 5),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.002)
              ..rotateY(value * pi), // Flip vertically
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 23,
                    fontFamily: 'Nunito-SemiBold',
                  ),
                ),
                 Text(
                  "Coins",
                  style: const TextStyle(
                    color: Colors.brown,
                    fontWeight: FontWeight.w800,
                    fontSize: 23,
                    fontFamily: 'Nunito-SemiBold',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class JumpingTextWidget extends StatefulWidget {
  _JumpingTextWidgetState createState() => _JumpingTextWidgetState();
}

class _JumpingTextWidgetState extends State<JumpingTextWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _animation = Tween<double>(begin: 0.0, end: 20.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.repeat(reverse: true);

    // Stop the animation after one minute (60 seconds)
    Timer(const Duration(seconds: 2), () {
      _controller.stop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.70,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0.0, _animation.value),
            child: const Text(
              "Use these coins to get a discount on our services.",
              maxLines: 2,
              style: TextStyle(fontSize: 16.0), // Adjust font size as needed
              textAlign: TextAlign.start,
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
