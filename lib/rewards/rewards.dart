import 'dart:math';
import 'package:animation_flutter/rewards/Commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../provider/provider.dart';


class Rewards extends StatefulWidget {
  const Rewards({Key? key}) : super(key: key);

  @override
  State<Rewards> createState() => _RewardsState();
}

class _RewardsState extends State<Rewards> {
  final key = GlobalKey<ScaffoldState>();

  String? link;
  String? userDetails;
  bool isPopUpVisible = false;
  bool value = true;
  late RewardsPrvoider rewardsPrvoider;

  List<Function> popupMethods = [];

  @override
  void initState() {
    super.initState();
    rewardsPrvoider = Provider.of<RewardsPrvoider>(context, listen: false);
    popupMethods = [
     // showNotEligiblePopUp,
      showScratchPopUp,
      showFlipCardPopUp,
     showFlipCoinPopUp,
     // showReedemPercentage
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      body: Consumer<RewardsPrvoider>(builder: (context, rewardsProvider, _) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height /
                  1.47, // Adjust the height as needed
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                          setState(() {
                            isPopUpVisible = !isPopUpVisible;
                        });
                        final randomPopupMethod = popupMethods[Random().nextInt(popupMethods.length)];
                        randomPopupMethod();
                        // showScratchPopUp();
                        //showFlipCardPopUp();
                        //showFlipCoinPopUp();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color(0xffD4E8DA),
                                width: 1.0),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(8)),
                            image:  const DecorationImage(
                                image: AssetImage(
                                    'assets/images/reward_redeem_bac.png'),
                                fit: BoxFit.fill),
                          ),
                          child: ListTile(
                            title: const Text(
                             "Reedem Your  Coin",
                              style: TextStyle(
                                color: Color(0xff000000),
                                fontSize: 13,
                                fontFamily: 'Nunito-Bold',
                              ),
                            ),
                            subtitle: const Text(
                              "Convert your Insa coins into Money",
                              style: TextStyle(
                                color: Color(0xff000000),
                                fontSize: 12,
                                fontFamily: 'Nunito-SemiBold',
                              ),
                            ),
                            leading: SvgPicture.asset(
                              'assets/svg/double_coin_polyfix.svg',
                              fit: BoxFit.contain,
                              height: 40,
                              width: 44,
                            ),
                            trailing: Image.asset(
                              'assets/images/green_back_arrow.png',
                              height: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //  SizedBox(height: 10,),
                  ]),
            ),
            if (isPopUpVisible)
              Container(
                color: Colors.black.withOpacity(0.5),
              ),
          ],
        );
      }),
    );
  }





  Future<void> showScratchPopUp() async {
    await scratchPopUp(
      coins: '500',
      context: context,
      closeFun: () {
        Navigator.pop(context);
        setState(() {
          isPopUpVisible = false;
        });
      },
    );
    // }
  }

  Future<void> showFlipCardPopUp() async {
   // if (response != null) {
    await flipCardPopUp(
      coins: '500',
      context: context,
      closeFun: () {
        Navigator.pop(context);
        rewardsPrvoider.setFlippedCard(false);
        setState(() {
          isPopUpVisible = false;
        });
      },
    );
    // }
  }
  Future<void> showFlipCoinPopUp() async {
    // if (response != null) {
    await flipCoinPopUp(
      coins: '500',
      context: context,
      closeFun: () {
        Navigator.pop(context);
        rewardsPrvoider.setFlippedCoin(false);
        setState(() {
          isPopUpVisible = false;
        });
      },
    );
    // }
  }
}
