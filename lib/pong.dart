import 'package:flutter/material.dart';
import './bat.dart';
import './ball.dart';
import 'dart:math';

enum Direction { up, down, left, right }

class Pong extends StatefulWidget {
  @override
  _PongState createState() => _PongState();
}

class _PongState extends State<Pong> with SingleTickerProviderStateMixin {
  double width = 0;
  double height = 0;
  double posX = 0;
  double posY = 0;
  double batWidth = 0;
  double batHeight = 0;
  double batPosition = 0;
  Direction vDir = Direction.down;
  Direction hDir = Direction.right;
  double increment = 5;
  double randX = 1;
  double randY = 1;
  int score = 0;
  int randPos = 0;
  List<Color> color = [Colors.red,Colors.yellow,Colors.orange,Colors.pink,Colors.black];


  late AnimationController controller;
  late Animation<double> animation;

  void checkBorders() {
    int diameter = 50;
    if (posX <= 0 && hDir == Direction.left) {
      hDir = Direction.right;
      randX = random();
    }

    if (posX >= width - diameter && hDir == Direction.right) {
      hDir = Direction.left;
      randX = random();
    }
    if (posY <= 0 && vDir == Direction.up) {
      vDir = Direction.down;
    }
    if (posY >= height - 50 - batHeight && vDir == Direction.down) {
      //check if the bat is here, otherwise loose
      if (posX >= (batPosition - 50) && posX <= (batPosition + batWidth + 50)) {
        randY = random();
        vDir = Direction.up;
        randPos = randomIndex();
        safeSetState(() {
          score++;
        });
      } else {
        controller.stop();
        showMessage(context);
      }
    }
  }

  void moveBat(DragUpdateDetails update) {
    safeSetState(() {
      batPosition += update.delta.dx;
    });
  }

  void safeSetState(Function function) {
    if (mounted && controller.isAnimating) {
      setState(() {
        function();
      });
    }
  }

  double random() {
    Random rand = Random();
    int myNum = rand.nextInt(101);
    return (70 + myNum) / 100;
  }

  void showMessage(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Game Over'),
            content: Text('Would you like to play again?'),
            actions: <Widget>[
              TextButton(
                child: Text('YES'),
                onPressed: () {
                  setState(() {
                    posX = 0;
                    posY = 0;
                    score = 0;
                  });
                  controller.repeat();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('NO'),
                onPressed: () {
                  Navigator.of(context).pop();
                  dispose();
                },
              )
            ],
          );
        });
  }
  int randomIndex(){
    Random rand = Random();
    int myNum = rand.nextInt(5);
    return myNum;
  }

Color setColor(){
    if (score >= 10)
      return color[randPos];
    if (score >= 20)
      return color[randPos];
  return color[randPos];
}
  
  
  @override
  void initState() {

    posX = 0;
    posY = 0;
    controller =
        AnimationController(duration: Duration(minutes: 10000), vsync: this);
    animation = Tween<double>(begin: 0, end: 100).animate(controller);
    animation.addListener(() {
      safeSetState(() {
        (hDir == Direction.right)
            ? posX += ((increment * randX).round())
            : posX -= ((increment * randX).round());
        (vDir == Direction.down)
            ? posY += ((increment * randY).round())
            : posY -= ((increment * randY).round());
      });
      checkBorders();
    });
    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (BuildContext build, BoxConstraints constraints) {
        height = constraints.maxHeight;
        width = constraints.maxWidth;
        batWidth = width / 3;
        batHeight = height / 20;

        return Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              right: 20,
              child: Text('Score: ' + score.toString()),
            ),
            Positioned(
                top: 50,
                right: 30,
                child:
                    ElevatedButton(child: Text('Restart'), onPressed: () {controller.repeat();})),
            Positioned(
              child: Ball(setColor()),
              top: posY,
              left: posX,
            ),
            Positioned(
              bottom: 0,
              left: batPosition,
              child: GestureDetector(
                  onHorizontalDragUpdate: (DragUpdateDetails update) =>
                      moveBat(update),
                  child: Bat(batHeight, batWidth)),
            ),
          ],
        );
      },
    );
  }
}
