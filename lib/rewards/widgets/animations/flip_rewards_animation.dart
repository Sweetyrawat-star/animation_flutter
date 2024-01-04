import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../provider/provider.dart';
import 'animation_widgets/flip_card_widget.dart';

class FlipCardPopup extends StatefulWidget {
  FlipCardPopup({
    Key? key,
    required this.closeFun,
    required this.coins,
  }) : super(key: key);

  final Function() closeFun;
  final String coins;

  @override
  _FlipCardPopupState createState() => _FlipCardPopupState();
}

class _FlipCardPopupState extends State<FlipCardPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
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
              decoration:  const BoxDecoration(
                color: Color(0xffFFFFFF),
                image: DecorationImage(
                  image: AssetImage('assets/images/bac_star.png'),
                  fit: BoxFit.fitHeight,
                ),
              ),
              child: Material(
                child: Column(children: [
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
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                        child: rewardsProvider.isFilped
                            ? Lottie.asset('assets/lotties/Congratulations.json',
                                height: 40, width: 40)
                            : const SizedBox(),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          rewardsProvider.isFilped
                              ? const Text(
                                "CONGRATS !",
                                  style:  TextStyle(
                                    color: Color(0xff000000),
                                    fontSize: 20,
                                    fontFamily: 'Nunito-ExtraBold',
                                  ),
                                )
                              : const SizedBox(),
                          rewardsProvider.isFilped
                              ? const Text(
                                  "You've  Won InSa Coins",
                                  maxLines: 2,
                                  style:  TextStyle(
                                    color: Color(0xff000000),
                                    fontSize: 12,
                                    fontFamily: 'Nunito-SemiBold',
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FlipCard(
                    flipCoin: (bool value) {
                      setState(() {
                        rewardsProvider.setFlippedCard(value);
                      });
                    },
                    isFilped: true,
                    onFlipComplete: () {
                      setState(() {
                        shouldShowText = true;
                      });
                    },
                  ),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0.0, _animation.value),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            if (rewardsProvider.isFilped && shouldShowText)
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      height: 30,
                                      width: 30,
                                      'assets/svg/back_rewards.svg',
                                    ),
                                    const SizedBox(width: 15.0),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.70,
                                      child: const Text(
                                        "Use these coins to get a discount on our services.",
                                        maxLines: 2,
                                        style: TextStyle(
                                          color: Color(0xff000000),
                                          fontSize: 14,
                                          fontFamily: 'Nunito-Bold',
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              SizedBox(),
                            if (rewardsProvider.isFilped && shouldShowText)
                              const SizedBox(
                                height: 10,
                              )
                            else
                              SizedBox(),
                            if (rewardsProvider.isFilped && shouldShowText)
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      height: 30,
                                      width: 30,
                                      'assets/svg/back_rewards.svg',
                                    ),
                                    const SizedBox(width: 15.0),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.70,
                                      child: const Text(
                                        "Coins will be collected in your wallet.",
                                        maxLines: 2,
                                        style: TextStyle(
                                          color: Color(0xff000000),
                                          fontSize: 14,
                                          fontFamily: 'Nunito-Bold',),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              const SizedBox(),
                          ],
                        ),
                      );
                    },
                  ),
                ]),
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// class JumpingTextWidget extends StatefulWidget {
//   _JumpingTextWidgetState createState() => _JumpingTextWidgetState();
// }
//
// class _JumpingTextWidgetState extends State<JumpingTextWidget>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 500),
//     );
//
//     _animation = Tween<double>(begin: 0.0, end: 20.0).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: Curves.easeInOut,
//       ),
//     );
//
//     _controller.repeat(reverse: true);
//
//     // Stop the animation after one minute (60 seconds)
//     Timer(const Duration(seconds: 2), () {
//       _controller.stop();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: MediaQuery.of(context).size.width * 0.70,
//       child: AnimatedBuilder(
//         animation: _controller,
//         builder: (context, child) {
//           return Transform.translate(
//             offset: Offset(0.0, _animation.value),
//             child: Text(
//               'Use these coins to get a discount on our services.',
//               maxLines: 2,
//               style: TextStyle(fontSize: 16.0), // Adjust font size as needed
//               textAlign: TextAlign.start,
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }
