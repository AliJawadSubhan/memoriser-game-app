import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:memorizer/extensions/buildcontext.dart';
import 'package:memorizer/modules/game_/playing_card_model.dart';
import 'package:memorizer/modules/result/result_page.dart';

Map<String, Map> selectedCards = {"first": {}, "second": {}};
List<FlipCardController> correctCards = [];
List<PlayingCard> card = [];

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final carIcon = PlayingCard(LineAwesome.taxi_solid, 1);
  final playIcon = PlayingCard(LineAwesome.video_solid, 2);
  final cameraIcon = PlayingCard(LineAwesome.youtube, 3);
  final shuffleIcon = PlayingCard(LineAwesome.skull_crossbones_solid, 4);
  final closeIcon = PlayingCard(LineAwesome.teamspeak, 5);

  int length = 20;
  int columns = 20 ~/ 5;

  fillCards() {
    for (var i = 0; i < columns; i++) {
      card.add(carIcon);
      card.add(playIcon);
      card.add(cameraIcon);
      card.add(shuffleIcon);
      card.add(closeIcon);
    }
  }

//   Timer? _timer;
//   int _start = 10;
//   void startTimer() {
//     const oneSec = Duration(seconds: 1);
//     _timer = Timer.periodic(
//       oneSec,
//       (Timer timer) {
//         if (_start == 0) {
//           setState(() {
//             timer.cancel();
//           });
//         } else {
//           setState(() {
//             _start--;
//           });
//         }
//       },
//     );
//   }

// @override
// void dispose() {
//   _timer!.cancel();
//   super.dispose();
// }

  List<FlipCardController> controllers = List.generate(20, (index) {
    return FlipCardController();
  });
  @override
  void initState() {
    super.initState();
    fillCards();
    // card.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 2), () {
        for (var co in controllers) {
          co.flipcard();
        }
      });
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.deepPurple[200]!,
              Colors.deepPurple[500]!,
            ],
          ),
        ),
        child: Column(
          children: [
            TweenAnimationBuilder<Duration>(
                duration: const Duration(minutes: 2),
                tween: Tween(
                    begin: const Duration(minutes: 2), end: Duration.zero),
                onEnd: () {
                  if (correctCards.length == card.length) {
                    context.pushScreenTo(const ResultPage(didPass: true));
                  } else {
                    context.pushScreenTo(const ResultPage(didPass: false));
                  }
                },
                builder: (BuildContext context, Duration value, Widget? child) {
                  final minutes = value.inMinutes;
                  final seconds = value.inSeconds % 60;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      '$minutes : $seconds',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 30),
                    ),
                  );
                }),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: card.length,
                  itemBuilder: (context, index) {
                    return CardWidget(
                      card: card[index],
                      controller: controllers[index],
                      index: index,
                      allCController: controllers,
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
}

class CardWidget extends StatefulWidget {
  final PlayingCard card;
  final FlipCardController controller;
  final List<FlipCardController> allCController;
  final int index;

  const CardWidget({
    Key? key,
    required this.card,
    required this.controller,
    required this.index,
    required this.allCController,
  }) : super(key: key);

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return GestureDetector(
      onTap: () {
        if (widget.controller.state!.isFront != true) {
          widget.controller.flipcard();
          if (selectedCards["first"]!.isEmpty) {
            // flip to front
            selectedCards["first"] = {
              "value": widget.card.value,
              'controller': widget.controller,
            };
            log("First ${selectedCards["first"]}");
          } else if (selectedCards["second"]!.isEmpty) {
            selectedCards["second"] = {
              "value": widget.card.value,
              'controller': widget.controller,
            };
            log("Second ${selectedCards["second"]}");
            var isas = resultFunction(widget.allCController, context);
            if (isas) {
              showCustomSnackBar(context);
            }
          }
        }
      },
      child: FlipCard(
        animationDuration: const Duration(milliseconds: 300),
        rotateSide: RotateSide.right,
        controller: widget.controller,
        frontWidget: Center(
          child: Container(
            color: Colors.white,
            width: context.screenWidth,
            height: context.screenHeight,
            child: Icon(
              widget.card.frontImagePath,
              color: Colors.deepPurple[900]!,
              size: 51,
            ),
          ),
        ),
        backWidget: buildBackWidget(),
      ),
    );
  }

  Widget buildBackWidget() => Container(
        color: Colors.deepPurple[200]!,
        width: context.screenWidth,
        height: context.screenHeight,
      );

  @override
  bool get wantKeepAlive => true;
}

dynamic resultFunction(
    List<FlipCardController> allControllers, BuildContext context) {
  if (selectedCards["first"]!['value'] == selectedCards["second"]!['value']) {
    log("It matches");

    FlipCardController firstCardController =
        selectedCards["first"]!['controller'];
    FlipCardController secondCardController =
        selectedCards["second"]!['controller'];

    correctCards.add(firstCardController);
    correctCards.add(secondCardController);
    if (correctCards.length == card.length) {
      context.pushScreenTo(const ResultPage(didPass: true));
    }
  } else {
    log("It Doesn't match");
    Future.delayed(const Duration(milliseconds: 400), () {
      for (var element in allControllers) {
        if (!correctCards.contains(element) && element.state!.isFront) {
          element.flipcard();
        }
      }
    });
  }
  // Reset selected cards
  selectedCards['first'] = {};
  selectedCards['second'] = {};
}

void showCustomSnackBar(BuildContext context) {
  final snackBar = SnackBar(
    content: Text(
      'Hey, congrats, you just finished the game, retry?',
      style: GoogleFonts.montserrat(color: Colors.white, fontSize: 16),
    ),
    backgroundColor: Colors.deepPurple,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.all(50),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    duration: const Duration(days: 1),
    action: SnackBarAction(
      label: 'Yes',
      textColor: Colors.yellow,
      onPressed: () {
        if (context.mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        }
      },
    ),
  );
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
