import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:memorizer/extensions/buildcontext.dart';
import 'package:memorizer/modules/game_/game_screen.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: context.screenHeight,
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 52),
                Center(
                  child: Image.asset(
                    "asset/gif/brain.gif",
                    width: 200,
                    height: 200,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "Welcome to Memoriser!",
                    style: GoogleFonts.montserrat(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black.withOpacity(0.5),
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  "A game where you have to match Icons",
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  "\"Boost your memory, one icon at a time!\"",
                  style: GoogleFonts.montserrat(
                    fontStyle: FontStyle.italic,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 40),
                AnimatedButton(
                  onPress: () {
                    context.pushScreenTo(const GamePage());
                  },
                  height: 50,
                  width: 180,
                  text: 'Let\'s play',
                  isReverse: true,
                  selectedTextColor: Colors.white,
                  transitionType: TransitionType.LEFT_TO_RIGHT,
                  backgroundColor: Colors.deepPurple[700]!,
                  borderColor: Colors.white,
                  borderRadius: 50,
                  borderWidth: 1,
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    "Developed with ♥ in Flutter",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
