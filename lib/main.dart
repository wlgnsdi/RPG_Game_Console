// ignore_for_file: avoid_print
import 'dart:io';
import 'dart:math';

import 'package:monster_battle_console/character.dart';
import 'package:monster_battle_console/file_manager.dart';
import 'package:monster_battle_console/monster.dart';

class Game {
  late FileManager fileManager;
  
  final String attackAction = "1";
  final String defenseAction = "2";

  late Character character;
  List<Monster> monsters = [];
  int killedMonster = 0;

  Game() {
    fileManager = FileManager();
    character = fileManager.loadCharacter();
    monsters = fileManager.loadMonsterData(character);
  }

  Monster getRandomMonster() {
    if (monsters.isEmpty) {
      throw StateError('몬스터 리스트가 비어있습니다.');
    }

    return monsters[Random().nextInt(monsters.length)];
  }

  void startGame() {
    print('게임을 시작합니다!');
    character.showStatus();

    while (true) {
      Monster currentMonster = getRandomMonster();
      print('\n새로운 몬스터가 나타났습니다!');
      currentMonster.showStatus();

      battle(currentMonster);

      if (character.health <= 0) {
        print('게임 오버! ${character.name}이(가) 쓰러졌습니다.');
        fileManager.saveResult(false, character);
        return;
      }

      if (killedMonster == monsters.length) {
        print('\n축하합니다! 모든 몬스터를 물리쳤습니다.');
        fileManager.saveResult(true, character);
        return;
      }

      print('\n다음 몬스터와 싸우시겠습니까? (y/n): ');
      String? response = stdin.readLineSync();

      if (response?.toLowerCase() != 'y') {
        print('게임을 종료합니다.');
        fileManager.saveResult(true, character);
        return;
      }
    }
  }

  void battle(Monster monster) {
    while (monster.health > 0 && character.health > 0) {
      print('\n${character.name}의 턴');
      stdout.write('행동을 선택하세요 (1: 공격, 2: 방어): ');
      String? action = stdin.readLineSync();
      
      if (action == attackAction) {
        character.attack(monster);
      } else if (action == defenseAction) {
        character.defend(monster.attackPower);
      } else {
        print('잘못된 입력입니다. 다시 선택해주세요.');
        continue;
      }

      if (monster.health <= 0) {
        print('${monster.name}을(를) 물리쳤습니다!');
        monsters.remove(monster);
        killedMonster++;
        break;
      }

      print('\n${monster.name}의 턴');

      monster.attack(character);

      character.showStatus();
      monster.showStatus();
    }
  }
}

void main() {
  var game = Game();
  game.startGame();
}
