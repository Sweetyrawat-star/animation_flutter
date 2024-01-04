import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:scratcher/scratcher.dart';

class ScratchCoinPopup extends StatefulWidget {
  ScratchCoinPopup({
    super.key,
    required this.closeFun,
    required this.coins,
  });
  final Function() closeFun;
  final String coins;

  @override
  State<ScratchCoinPopup> createState() => _ScratchCoinPopupState();
}

class _ScratchCoinPopupState extends State<ScratchCoinPopup> {
  double _opacity = 0.0;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 20,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 300,
          decoration: const BoxDecoration(
            color: Color(0xffFFFFFF),
            image: DecorationImage(
                image: AssetImage('assets/images/bac_star.png'),
                fit: BoxFit.fill),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
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
            Material(
              child: Container(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: StatefulBuilder(builder: (context, StateSetter setState) {
                  return Scratcher(
                   // color: Colors.transparent,
                    image: const Image(image: AssetImage('assets/images/scratch.png')),
                    accuracy: ScratchAccuracy.low,
                    threshold: 30,
                    brushSize: 40,
                    onThreshold: () {
                      setState(() {
                        _opacity = 1;
                      });
                    },
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 100),
                      opacity: _opacity,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width * 0.6,
                        decoration: BoxDecoration(
                          color: const Color(0xffFFECE5),
                          border: Border.all(
                              color: const Color(0xffE2BBAC), width: 1.0),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                                top: 10,
                                //bottom: 10,
                                right: -4,
                                //left: 10,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 55,
                                      padding: const EdgeInsets.only(
                                          left: 15,
                                          right: 15,
                                          top: 10,
                                          bottom: 10),
                                      width: MediaQuery.of(context).size.width *
                                          0.55,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(30),
                                            bottomLeft: Radius.circular(30)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Lottie.asset(
                                              'assets/lotties/Congratulations.json',
                                              height: 26,
                                              width: 26),
                                          const SizedBox(
                                            width: 2,
                                          ),
                                          const SizedBox(
                                            width: 120,
                                            child: Text(
                                                "Congratulations! You Won",
                                              maxLines: 2,
                                              style: TextStyle(
                                                color: Color(0xff000000),
                                                fontSize: 13,
                                                fontFamily: 'Nunito-Bold',
                                              )
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                            Positioned(
                                top: 50,
                                bottom: 10,
                                right: -4,
                                left: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/images/coin_front.png',
                                        height: 26, width: 26),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      widget.coins,
                                      style: const TextStyle(
                                        color: Color(0xff2D9E7F),
                                        fontSize: 23,
                                        fontFamily: 'Nunito-SemiBold',
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(top: 5.0),
                                      child: Text(
                                        'Coins',
                                        style: TextStyle(
                                          color: Color(0xff000000),
                                          fontSize: 14,
                                          fontFamily: 'Nunito-Bold',
                                        )
                                      ),
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      ),
                    ), // Placeholder for the required 'child' parameter
                  );
                }),
              ),
            ),
          ]),
        ),
      ),
    ));
  }
}
