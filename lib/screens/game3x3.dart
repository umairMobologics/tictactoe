import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';

class GameScreen3x3 extends StatefulWidget {
  const GameScreen3x3({super.key});

  @override
  State<GameScreen3x3> createState() => _GameScreen3x3State();
}

class _GameScreen3x3State extends State<GameScreen3x3> {
  bool oTurn = true;
  List<String> displayXO = List.filled(9, '');
  List<int> matchedIndexes = [];
  int attempts = 0;
  int oScore = 0;
  int xScore = 0;
  int filledBoxes = 0;
  String resultDeclaration = '';
  String level = 'Easy';
  bool winnerFound = false;
  bool ispng =true;
  static int maxSeconds = 30;
  int seconds = maxSeconds;
  Timer? timer;

  static final customFontWhite = GoogleFonts.coiny(
    textStyle: const TextStyle(
      color: Colors.white,
      letterSpacing: 3,
      fontSize: 28,
    ),
  );
    static final customFontRed = GoogleFonts.coiny(
    textStyle: const TextStyle(
      color: Colors.red,
      letterSpacing: 3,
      fontSize: 28,
    ),
  );
  static final customFontO = GoogleFonts.coiny(
    textStyle: const TextStyle(
      color: Colors.green,
      letterSpacing: 3,
      fontSize: 28,
    ),
  );
  static final customFontX = GoogleFonts.coiny(
    textStyle: const TextStyle(
      color: Colors.blue,
      letterSpacing: 3,
      fontSize: 28,
    ),
  );

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          stopTimer();
          _clearBoard();
          _clearBoard();
          resultDeclaration = 'Times Up!';
        }
      });
    });
  }

  void stopTimer() {
    resetTimer();
    timer?.cancel();
  }

@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    stopTimer();
  }
  void resetTimer() => seconds = maxSeconds;

  void _showLevelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Level"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: const Text("Easy"),
                onTap: () {
                  setState(() {
                    maxSeconds = 30;
                    seconds = maxSeconds;
                    level = 'Easy';
                    stopTimer();
                    _clearBoard();
                  });
                  Navigator.of(context).pop("Easy");
                },
              ),
              ListTile(
                title: const Text("Medium"),
                onTap: () {
                  setState(() {
                    maxSeconds = 20;
                    seconds = maxSeconds;
                    level = 'Medium';
                    stopTimer();
                    _clearBoard();
                  });
                  Navigator.of(context).pop("Medium");
                },
              ),
              ListTile(
                title: const Text("Hard"),
                onTap: () {
                  setState(() {
                    maxSeconds = 10;
                    seconds = maxSeconds;
                    level = 'Hard';
                    stopTimer();
                    _clearBoard();
                  });
                  Navigator.of(context).pop("Hard");
                },
              ),
            ],
          ),
        );
      },
    ).then((selectedLevel) {
      if (selectedLevel != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Set Timer to: $maxSeconds sec")),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        backgroundColor: MainColor.primaryColor,
        centerTitle: true,
        title: const Text(
          "3 X 3",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: MainColor.primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
           Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    InkWell(
      onTap: () => _showLevelDialog(context),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: MainColor.secondaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            "Level: $level",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ),
    Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: MainColor.secondaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: PopupMenuButton<String>(
        onSelected: (String value) {
          setState(() {
            if (value == 'BlackShadow') {
              ispng = true;
            } else if (value == 'GradientX') {
              ispng = false;
            }
          });
        },
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem<String>(
              value: 'BlackShadow',
              child: Row(
                children: [
                  Image.asset(
                    'assets/blackX.png', // Replace with your image asset path
                    width: 25,
                    height: 25,
                  ),
                  const SizedBox(width: 10),
                  const Text('BlackShadow'),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'GradientX',
              child: Row(
                children: [
                  Image.asset(
                    'assets/redX.png', // Replace with your image asset path
                    width: 25,
                    height: 25,
                  ),
                  const SizedBox(width: 10),
                  const Text('GradientX'),
                ],
              ),
            ),
          ];
        },
        child: const Row(
          children: [
            Text(
              "Select Template",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    ),
  ],
),


            const SizedBox(height: 10),
            buildScoreBoard(),
            const SizedBox(height: 30),
            buildGrid(),
            buildResultAndTimer(),
              const SizedBox(height: 30),
          ],
        ),
      ),
      
    );
  }

  Widget buildScoreBoard() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildPlayerScore('Player O', oScore, customFontO),
        const SizedBox(width: 40),
        buildPlayerScore('Player X', xScore, customFontX),
      ],
    );
  }

  Widget buildPlayerScore(String player, int score, TextStyle style) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(player, style: style),
        Text(score.toString(), style: style),
      ],
    );
  }

  Widget buildGrid() {
  return Expanded(
    
    child: Container(
      
      child: GridView.builder(
        itemCount: 9, // Adjust for 3x3 grid
        
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          
          crossAxisCount: 3, // 3x3 grid
        ),
        
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              if (displayXO[index].isEmpty) {
                _tapped(index);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 5, color: MainColor.primaryColor),
                color: matchedIndexes.contains(index)
                    ? const Color.fromARGB(255, 9, 255, 0)
                    : MainColor.secondaryColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: displayXO[index] == ''
                      ? const SizedBox.shrink()
                      :  displayXO[index] == 'O'
                               ? ispng
                              ? Image.asset("assets/blackO.png")
                              : Image.asset("assets/greenO.png")
                          : ispng
                              ? Image.asset("assets/blackX.png")
                              : Image.asset("assets/redX.png"),
                     
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}


  Widget buildResultAndTimer() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(resultDeclaration, style: resultDeclaration =='Times Up!' ? customFontRed :  resultDeclaration =='Player O Wins!' ? customFontO :customFontX),
          
          const SizedBox(height: 20),
          buildTimer(),
          
        ],
      ),
    );
  }

  // Widget buildFloatingActionButton() {
  //   return Stack(
  //     children: [
  //       Positioned(
  //         bottom: 20,
  //         right: 10,
  //         child: FloatingActionButton.extended(
            
  //         ),
  //       ),
  //     ],
  //   );
  // }

  void _tapped(int index) {
    final isRunning = timer == null ? false : timer!.isActive;

    if (isRunning) {
      setState(() {
        if (displayXO[index] == '') {
          displayXO[index] = oTurn ? 'O' : 'X';
          filledBoxes++;
          oTurn = !oTurn;
          _checkWinner();
        }
      });
    }
  }

  void _checkWinner() {
    final winningPatterns = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
      [0, 4, 8], [2, 4, 6], // Diagonals
    ];

    for (var pattern in winningPatterns) {
      if (displayXO[pattern[0]] != '' &&
          displayXO[pattern[0]] == displayXO[pattern[1]] &&
          displayXO[pattern[0]] == displayXO[pattern[2]]) {
        setState(() {
          resultDeclaration = 'Player ${displayXO[pattern[0]]} Wins!';
          matchedIndexes.addAll(pattern);
          stopTimer();
          _updateScore(displayXO[pattern[0]]);
        });
        return;
      }
    }

    if (filledBoxes == 9) {
      setState(() {
        resultDeclaration = 'Nobody Wins!';
        stopTimer();
      });
    }
  }

  void _updateScore(String winner) {
    if (winner == 'O') {
      oScore++;
    } else if (winner == 'X') {
      xScore++;
    }
    winnerFound = true;
  }

  void _clearBoard() {
    setState(() {
      displayXO.fillRange(0, displayXO.length, '');
      resultDeclaration = '';
      matchedIndexes.clear();
      filledBoxes = 0;
      winnerFound = false;
    });
  }

  Widget buildTimer() {
    final isRunning = timer == null ? false : timer!.isActive;

    return isRunning
        ? Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,


          children: [
            Expanded(
              child: Row(
mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 100,
                      height: 100,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CircularProgressIndicator(
                            value: 1 - seconds / maxSeconds,
                            valueColor:  const AlwaysStoppedAnimation(Colors.red),
                            strokeWidth: 8,
                            backgroundColor:Colors.black,
                          ),
                          Center(
                            child: Text(
                              '$seconds',
                              style:  const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 50,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
             
                InkWell(
              onTap: () {
    if (timer != null) {
                stopTimer();
                _clearBoard();
              } else {
             
              }
  },
             child: Container(
                           
                              padding: const EdgeInsets.all(10),
                              decoration:  BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(12)),
                           
                              child: const Center(
                                child:Icon(Icons.restart_alt_outlined, color: Colors.black,size: 30,),
                            ),
              ),
           ),
          ],
        )
        : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                   startTimer();
                      _clearBoard();
                      attempts++;
                },
                child: Container(
                    
                    padding: const EdgeInsets.all(10),
                    decoration:  BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(12)),
                 
                    child: Center(
                      child: Text(
                        attempts == 0 ? 'Start' : 'Play Again!',
                        style: const TextStyle(fontSize: 30, color: Colors.black,fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ),
            ),
            const SizedBox(width: 10,),
           InkWell(
              onTap: () {
    if (timer != null) {
                stopTimer();
                _clearBoard();
              } else {
             
              }
  },
             child: Container(
                           
                              padding: const EdgeInsets.all(10),
                              decoration:  BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(12)),
                           
                              child: const Center(
                                child:Icon(Icons.restart_alt_outlined, color: Colors.black,size: 30,),
                            ),
              ),
           ),
          ],
        );
  }
}
