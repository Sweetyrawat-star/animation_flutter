import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../../provider/provider.dart';
import 'animation_widgets/flip_coins.dart';

class FlipCoinPopup extends StatefulWidget {
  FlipCoinPopup({
    Key? key,
    required this.closeFun,
    required this.coins,
  }) : super(key: key);

  final Function() closeFun;
  final String coins;

  @override
  _FlipCoinPopupState createState() => _FlipCoinPopupState();
}

class _FlipCoinPopupState extends State<FlipCoinPopup>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late AnimationController _animationController;
  late Animation<double> _animation1;
  late AnimationController _controllerContainer;
  late Animation<double> _animationContainer;
  late Animation<double> _widthAnimation;
  late Animation<double> _heightAnimation;
  late AnimationController _controllerJumpIn;
  late Animation<double> _animationJumpIn;
  List<String> images = [
   'assets/images/coin_front.png',
    'assets/images/coin_background.png',
  ];

  bool _isAnimating = false;
  bool _shouldAnimate = false; // Add this line
  bool _buttonTapped = false;
  bool _buttonFalse = false;
  bool isCardFlipped = false;
  bool shouldShowText = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0.0, end: 20.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _controller.repeat(reverse: true);
    Timer(const Duration(seconds: 3), () {
      _controller.stop();
    });
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation1 = Tween(begin: 0.0, end: 1.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _isAnimating = false;
          });
          _animationController.reset();
        }
      });
    _controllerContainer = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _widthAnimation =
        Tween<double>(begin: 50.0, end: 100.0).animate(_controllerContainer);
    _heightAnimation =
        Tween<double>(begin: 30.0, end: 50.0).animate(_controllerContainer);
    _controllerJumpIn = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _animationJumpIn = Tween<double>(begin: 0.0, end: 20.0).animate(
      CurvedAnimation(
        parent: _controllerJumpIn,
        curve: Curves.easeInOut,
      ),
    );

    _controllerJumpIn.repeat(reverse: true);

    // Stop the animation after one minute (60 seconds)
    Timer(const Duration(seconds: 2), () {
      _controllerJumpIn.stop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RewardsPrvoider>(builder: (context, rewardsProvider, _) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              height: rewardsProvider.isFilped
                  ? MediaQuery.of(context).size.height * 0.52
                  : MediaQuery.of(context).size.height * 0.40,
              decoration: const BoxDecoration(
                color: Color(0xffFFFFFF),
                image: DecorationImage(
                  image: AssetImage('assets/images/bac_star.png'),
                  fit: BoxFit.fitHeight,
                ),
              ),
              child: Material(
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: widget.closeFun,
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Icon(
                            Icons.cancel_outlined,
                            color: Color.fromRGBO(0, 0, 0, 1),
                          ),
                        ),
                      ),
                    ),
                    // CoinFlipAnimation(),
                    _buildCoin(),
                    const SizedBox(
                      height: 15,
                    ),
                
                    Positioned(
                      top: 0,
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: GestureDetector(
                        onTap: shouldShowText != true
                            ? () {
                                setState(() {
                                  _buttonTapped = true;
                                  _buttonFalse = false;
                                });
                                _startAnimation(rewardsProvider);
                                //_startAnimation();
                              }
                            : null,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: AnimatedContainer(
                            duration: Duration(seconds: 1),
                            height: 60,
                            decoration: BoxDecoration(
                              color: (_isAnimating != true &&
                                      _buttonTapped != true)
                                  ? const Color(0xffFAAA52) // Button tapped, set to transparent
                                  : _isAnimating
                                      ? const Color(0xffFAAA52).withOpacity(
                                          0.30) // Animation in progress, set to orange with 30% opacity
                                      : Colors
                                          .transparent, // Animation completed, set to transparent
                            ),
                            child: Center(
                              child: Visibility(
                                visible: !_isAnimating && !shouldShowText,
                                child: const Text(
                                  'Tap Here',
                                  style: TextStyle(
                                    color: Color(0xff000000),
                                    fontSize: 14,
                                    fontFamily: 'Nunito-Bold',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (!_isAnimating && shouldShowText)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 40.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5.0, bottom: 5.0),
                                child: rewardsProvider.isFilpedCoin
                                    ? Lottie.asset(
                                        'assets/lotties/Congratulations.json',
                                        height: 40,
                                        width: 40)
                                    : const SizedBox(),
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              Column(
                                children: [
                                  rewardsProvider.isFilpedCoin
                                      ? const Text(
                                    "CONGRATS !",
                                          style: TextStyle(
                                            color: Color(0xff000000),
                                            fontSize: 20,
                                            fontFamily: 'Nunito-ExtraBold',
                                          ),
                                        )
                                      : SizedBox(),
                                  rewardsProvider.isFilpedCoin
                                      ? const Text(
                                    "You've  Won InSa Coins",
                                          maxLines: 2,
                                          style: TextStyle(
                                            color: Color(0xff000000),
                                            fontSize: 12,
                                            fontFamily: 'Nunito-SemiBold',
                                          ),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  void _startAnimation(RewardsPrvoider rewardsPrvoider) {
    if (!_isAnimating && !_shouldAnimate) {
      setState(() {
        _isAnimating = true;
        _shouldAnimate = true;
        shouldShowText = true; // Set the flag to true when animation starts
        rewardsPrvoider.setFlippedCoin(_shouldAnimate);
      });

      _animationController.forward().then((value) {
        // Animation completed
        setState(() {
          _shouldAnimate =
              false; // Set the flag to false after animation is completed
        });
        // widget.onFlipComplete();
      });
    }
  }

  Widget _buildCoin() {
    return _buttonTapped
        ? TweenAnimationBuilder<double>(
            duration: const Duration(seconds: 5),
            tween: Tween<double>(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              final index = value < 0.5 ? 0 : 1;
              return Column(
                children: [
                  FlipWidget(
                    flipAnimation: value,
                    translateY: 50 * value,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 0.0,
                      ),
                      child: Image.asset(
                        images[index],
                        width: 120,
                        height: 120,
                      ),
                    ),
                  ),
                  //  SizedBox(height: 20,),
                  Align(
                    child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Container(
                            width: _widthAnimation.value,
                            margin:
                                EdgeInsets.only(top: _buttonTapped ? 65 : 15),
                            // height:_heightAnimation.value,
                            height: 30,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 3,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              color: Colors.grey.withOpacity(0.10),
                              borderRadius: const BorderRadius.all(
                                  Radius.elliptical(100, 50)),
                            ),
                          );
                        }),
                  ),
                ],
              );
            },
          )
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 45.0,
                ),
                child: Image.asset(
                  images[0],
                  width: 150,
                  height: 150,
                ),
              ),
              Align(
                child: Container(
                  height: 30,
                  width: 90,
                  margin: const EdgeInsets.only(
                    top: 15,
                  ),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: Offset(0, 3),
                      ),
                    ],
                    color: Colors.grey.withOpacity(0.10),
                    borderRadius: const BorderRadius.all(
                        Radius.elliptical(100, 50)),
                  ),
                ),
              ),
            ],
          );
  }
  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    _controllerContainer.dispose();
    _controllerJumpIn.dispose();
    super.dispose();
  }
}



