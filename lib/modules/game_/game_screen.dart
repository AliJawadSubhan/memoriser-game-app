import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:memorizer/extensions/buildcontext.dart';
import 'package:memorizer/modules/game_/playing_card_model.dart';

Map<String, Map> selectedCards = {"first": {}, "second": {}};
List<FlipCardController> correctCards = [];
List<PlayingCard> card = [];

class CardDistributionScreen extends StatefulWidget {
  const CardDistributionScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CardDistributionScreenState createState() => _CardDistributionScreenState();
}

class _CardDistributionScreenState extends State<CardDistributionScreen> {
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

  List<FlipCardController> controllers = List.generate(20, (index) {
    return FlipCardController();
  });
  @override
  void initState() {
    super.initState();
    fillCards();
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
      backgroundColor: Colors.pink.shade300,
      body: Padding(
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
            resultFunction(widget.allCController);
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
              color: Colors.pink,
              size: 31,
            ),
          ),
        ),
        backWidget: buildBackWidget(),
      ),
    );
  }

  Widget buildFrontWidget() => Center(
        child: Container(
          color: Colors.white,
          width: context.screenWidth,
          height: context.screenHeight,
          child: const Icon(
            Icons.arrow_back,
            color: Colors.pink,
          ),
        ),
      );

  Widget buildBackWidget() => Container(
        color: Colors.blue,
        width: context.screenWidth,
        height: context.screenHeight,
      );

  @override
  bool get wantKeepAlive => true;
}

void resultFunction(List<FlipCardController> allControllers) {
  if (selectedCards["first"]!['value'] == selectedCards["second"]!['value']) {
    log("It matches");

    FlipCardController firstCardController =
        selectedCards["first"]!['controller'];
    FlipCardController secondCardController =
        selectedCards["second"]!['controller'];

    correctCards.add(firstCardController);
    correctCards.add(secondCardController);
    if (correctCards.length == card.length) {}
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
