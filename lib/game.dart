import 'dart:io';
import 'dart:math';

import 'package:monster_battle_console/model/character.dart';
import 'package:monster_battle_console/model/monster.dart';
import 'package:monster_battle_console/util/file_manager.dart';

class Game {
  late FileManager fileManager;

  static const String attackAct = "1";
  static const String defenseAct = "2";

  late Character character;
  List<Monster> monsters = [];
  int killedMonster = 0;

  Game() {
    // 게임 시작 전에 파일을 불러와서 사용자와 몬스터 데이터를 가져옵니다.
    fileManager = FileManager();
    character = fileManager.loadCharacter();
    monsters = fileManager.loadMonsterData(character);
  }

  void startGame() {
    print('게임을 시작합니다!');
    // ℹ️ 캐릭터의 현재 정보 표시
    character.showStatus();

    while (true) {
      // 불러온 몬스터중에서 랜덤으로 한마리의 몬스터를 선택
      Monster? currentMonster = getRandomMonster();

      if (currentMonster == null) {
        print('더 이상 몬스터가 없습니다. 게임을 종료합니다.');
        return;
      }
      // 선택된 몬스터의 정보를 출력
      print('\n새로운 몬스터가 나타났습니다!');
      // ℹ️ 몬스터의 현재 정보 표시
      currentMonster.showStatus();

      // ⚠️ 전투 시작 ⚠️
      // 캐릭터 공격 or 방어
      // 몬스터 공격
      battle(currentMonster);

      // 싸움 이후의 캐릭터 혹은 몬스터의 체력을 확인하고 게임 종료 여부 판단
      if (character.health <= 0) {
        print('게임 오버! ${character.name}이(가) 쓰러졌습니다.');
        fileManager.saveResult(false, character);
        return;
      }

      if (killedMonster == 2) {
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

  Monster? getRandomMonster() {
    if (monsters.isEmpty) {
      return null;
    }
    // monsters 리스트의 길이가 3이고 Random().nextInt(3) 으로 사용하면 값이 0~2 사이의 값을 반환합니다.
    return monsters[Random().nextInt(monsters.length)];
  }

  void battle(Monster monster) {
    while (monster.health > 0 && character.health > 0) {
      print('\n${character.name}의 턴');
      stdout.write('행동을 선택하세요 (1: 공격, 2: 방어): ');
      String? action = stdin.readLineSync();

      switch (action) {
        case attackAct:
          character.attack(monster);
          break;
        case defenseAct:
          character.defend(monster.attackPower);
          break;
        default:
          print('잘못된 입력입니다. 다시 선택해주세요.');
          continue;
      }

      if (monster.isDead()) {
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
