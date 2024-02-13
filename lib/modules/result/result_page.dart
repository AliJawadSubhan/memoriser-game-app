import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memorizer/extensions/buildcontext.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key, required this.didPass});
  final bool didPass;

  @override
  Widget build(BuildContext context) {
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                  didPass ? "asset/gif/happy.gif" : "asset/gif/sad.gif"),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  didPass
                      ? "Congrats on winning!"
                      : "There's no need to pout, you can try again!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                      fontSize: 31,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      color: Colors.white),
                ),
              ),
            ),
            AnimatedButton(
              onPress: () {
                context.popFromScreen();
              },
              height: 50,
              width: 180,
              text: 'play again!',
              isReverse: true,
              selectedTextColor: Colors.white,
              transitionType: TransitionType.LEFT_TO_RIGHT,
              backgroundColor: Colors.deepPurple[700]!,
              borderColor: Colors.white,
              borderRadius: 32,
              borderWidth: 1,
            ),
          ],
        ),
      ),
    );
  }
}
