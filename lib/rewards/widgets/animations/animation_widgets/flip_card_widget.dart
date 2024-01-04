import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';


class FlipCard extends StatefulWidget {
  FlipCard({
    Key? key,
    required this.flipCoin,
    required this.isFilped,
    required this.onFlipComplete,
  }) : super(key: key);

  final Function(bool value) flipCoin;
  late bool isFilped;
  final VoidCallback onFlipComplete;
  @override
  _FlipCardState createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard>
    with TickerProviderStateMixin{
  late AnimationController _animationController;
  late Animation<double> _animation;
  late AnimationController _controllerCard;
  late Animation<double> _animationCard;

  bool _isFront = true;
  bool _hasFlipped = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_animationController);
    _controllerCard = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animationCard = Tween<double>(begin: 0.0, end: 20.0).animate(
      CurvedAnimation(
        parent: _controllerCard,
        curve: Curves.easeInOut,
      ),
    );
    _controllerCard.repeat(reverse: true);
    Timer(const Duration(seconds: 3), () {
      _controllerCard.stop();
    });
  }

  void _flipCard() {
    if (!_hasFlipped) {
      widget.flipCoin(!_hasFlipped);
      if (_isFront) {
        _animationController.forward().then((value) {
          widget.onFlipComplete();
        });
      } else {
        _animationController.reverse().then((value) {
          widget.onFlipComplete();
        });
      }

      setState(() {
        _isFront = !_isFront;
        _hasFlipped = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GestureDetector(
        onTap: _flipCard,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.002)
                ..rotateY(_animation.value * pi),
              child: _isFront ? _buildFrontCard() : _buildBackCard(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFrontCard() {
    return Container(
      width: 250.0,
      height: 150.0,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        image: DecorationImage(
            image: AssetImage('assets/images/tap_collect.png'),
            fit: BoxFit.fill),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildText("TAB TO"),
            _buildText("COLLECT"),
          ],
        ),
      ),
    );
  }

  Widget _buildBackCard() {
    return AnimatedBuilder(
      animation: _controllerCard,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0.0, _animationCard.value),
          child: GestureDetector(
            onTap: () {
              // Add your logic here for handling tap on the back card
            },
            child: Container(
              width: 250.0,
              height: 150.0,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                image: DecorationImage(
                  image: AssetImage('assets/images/tap_back.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Center(
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(seconds: 2),
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0.0, -10.0 * (1 - value)!),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 40,
                              left: 0,
                              right: 0,
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
                                      'assets/images/coin_front.png',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 100,
                              left: 0,
                              right: 0,
                              bottom: 10,
                              child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()
                                  ..setEntry(3, 2, 0.002)
                                  ..rotateY(_isFront
                                      ? 0
                                      : pi), // Rotate horizontally based on _isFront
                                child: _buildAnimatedText(
                                  "You've  Won InSa Coins",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }


  Widget _buildAnimatedTextWithIcon(String? text, icon) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1000),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0.0, -5.0 * (1 - value)!),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               Image.asset(icon, height: 26, width: 26),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  text!,
                  style: const TextStyle(
                    color: Color(0xff2D9E7F),
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

  Widget _buildAnimatedText(String? text) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0.0, -10.0 * (1 - value)!),
            child: Center(
              child: Text(
                text!,
                style: const TextStyle(
                  color: Color(0xff000000),
                  fontSize: 13,
                  fontFamily: 'Nunito-Bold',
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildText(String text) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.002)
        ..rotateX(_animation.value * pi),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xff7B5951),
          fontSize: 18,
          fontFamily: 'Nunito-SemiBold',
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controllerCard.dispose();
    super.dispose();
  }
}
