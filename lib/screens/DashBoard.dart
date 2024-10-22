import 'package:flutter/material.dart';
import 'package:tic_tac_toe_game/constants/colors.dart';
import 'package:tic_tac_toe_game/screens/game3x3.dart';
import 'package:tic_tac_toe_game/screens/game4x4.dart';
import 'package:tic_tac_toe_game/screens/game5x5.dart';

class DashBoard extends StatelessWidget {
  const DashBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColor.primaryColor,
   appBar: AppBar(
    backgroundColor: MainColor.primaryColor,
    centerTitle: true,
    title: const Text("TIC TAC TOE GAME",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),),
     body:  SafeArea(
       child: Padding(
         padding: const EdgeInsets.all(12.0),
         child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
         
          Card(text: "3 X 3" , press:() {
             Navigator.push(context, MaterialPageRoute(builder: (context) =>  GameScreen3x3(),));
          }),
          const SizedBox(height: 20,),
     Card(text: "4 X 4" , press:() {
             Navigator.push(context, MaterialPageRoute(builder: (context) => const GameScreen4x4(),));
          }),
                  const SizedBox(height: 20,),
           Card(text: "5 X 5" , press:() {
             Navigator.push(context, MaterialPageRoute(builder: (context) => const GameScreen5x5(),));
          }),
                   const SizedBox(height: 20,),
         ],),
       ),
     ),
    
    );
  }
}

class Card extends StatelessWidget {
   Card({
    super.key, required this.text, required this.press,
  });
  final String text;
 VoidCallback? press;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: press,
        child: Material(
            elevation: 12,
            borderRadius: BorderRadius.circular(20),
            child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              Colors.cyan[200]!,
              const Color.fromARGB(255, 64, 98, 126),
              const Color.fromARGB(255, 124, 58, 136),
              const Color.fromARGB(255, 53, 35, 87),
                  Colors.cyan[200]!,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(3, 3), // changes position of shadow
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.black.withOpacity(0.5),
                  offset: const Offset(2, 2),
                ),
              ],
            ),
          ),
        ),
            ),
        ),
      ),
    );

  }
}