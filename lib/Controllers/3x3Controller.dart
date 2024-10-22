import 'dart:async';

import 'package:get/get.dart';

class GameController extends GetxController {
  final RxBool oTurn = true.obs;
  final RxList<String> displayXO = List.filled(9, '').obs;
  final RxList<int> matchedIndexes = <int>[].obs;
  final RxInt attempts = 0.obs;
  final RxInt oScore = 0.obs;
  final RxInt xScore = 0.obs;
  final RxInt filledBoxes = 0.obs;
  final RxString resultDeclaration = ''.obs;
  final RxString level = 'Easy'.obs;
  final RxBool ispng = true.obs;
  static const int maxSeconds = 30;
  final RxInt seconds = maxSeconds.obs;
  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    resetTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (seconds.value > 0) {
        seconds.value--;
      } else {
        stopTimer();
        clearBoard();
        resultDeclaration.value = 'Times Up!';
      }
    });
  }

  void stopTimer() {
    resetTimer();
     clearBoard();
    timer?.cancel();
  }

  void resetTimer() => seconds.value = maxSeconds;

  void clearBoard() {
    displayXO.clear();
    displayXO.addAll(List.filled(9, ''));
    resultDeclaration.value = '';
    matchedIndexes.clear();
    filledBoxes.value = 0;
  }

  void _updateScore(String winner) {
    if (winner == 'O') {
      oScore.value++;
    } else if (winner == 'X') {
      xScore.value++;
    }
  }

  void _checkWinner() {
    final List<List<int>> winningPatterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8], // Rows
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8], // Columns
      [0, 4, 8],
      [2, 4, 6], // Diagonals
    ];

    for (final List<int> pattern in winningPatterns) {
      if (displayXO[pattern[0]] != '' &&
          displayXO[pattern[0]] == displayXO[pattern[1]] &&
          displayXO[pattern[0]] == displayXO[pattern[2]]) {
        resultDeclaration.value = 'Player ${displayXO[pattern[0]]} Wins!';
        matchedIndexes.addAll(pattern);
        stopTimer();
        _updateScore(displayXO[pattern[0]]);
        return;
      }
    }

    if (filledBoxes.value == 9) {
      resultDeclaration.value = 'Nobody Wins!';
      stopTimer();
    }
  }

  void tapBox(int index) {
    final bool isRunning = timer == null ? false : timer!.isActive;

    if (isRunning) {
      if (displayXO[index].isEmpty) {
        displayXO[index] = oTurn.value ? 'O' : 'X';
        filledBoxes.value++;
        oTurn.toggle();
        _checkWinner();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    stopTimer();
  }
}
