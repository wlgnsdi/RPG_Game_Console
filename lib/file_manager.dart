import 'dart:io';
import 'dart:math';

import 'package:monster_battle_console/character.dart';
import 'package:monster_battle_console/monster.dart';

class FileManager {
  Character loadCharacter() {
    final file = File('assets/characters.txt');
    final contents = file.readAsStringSync();
    final stats = contents.split(',');
    if (stats.length != 3) throw FormatException('Invalid character data');

    int health = int.parse(stats[0]);
    int attack = int.parse(stats[1]);
    int defense = int.parse(stats[2]);

    String name = getCharacterName();
    return Character(name, health, attack, defense);
  }

  List<Monster> loadMonsterData(Character character) {
    List<Monster> monsters = [];
    try {
      final file = File('assets/monsters.txt');
      final lines = file.readAsLinesSync();
      for (var line in lines) {
        final stats = line.split(',');
        if (stats.length != 3) throw FormatException('Invalid monster data');

        String name = stats[0];
        int health = int.parse(stats[1]);
        int attack = max(
          character.defensePower,
          Random().nextInt(int.parse(stats[2])),
        );

        monsters.add(Monster(name, health, attack));
      }
    } catch (e) {
      print('몬스터 데이터를 불러오는 데 실패했습니다: $e');
      exit(1);
    }

    return monsters;
  }

  void saveResult(bool victory, Character character) {
    stdout.write('결과를 저장하시겠습니까? (y/n): ');
    String? response = stdin.readLineSync();
    if (response?.toLowerCase() == 'y') {
      try {
        final file = File('result.txt');
        final result = victory ? '승리' : '패배';
        file.writeAsStringSync(
          '캐릭터: ${character.name}, 남은 체력: ${character.health}, 결과: $result',
        );
        print('결과가 저장되었습니다.');
      } catch (e) {
        print('결과 저장에 실패했습니다: $e');
      }
    }
  }

  String getCharacterName() {
    while (true) {
      stdout.write('캐릭터의 이름을 입력하세요: ');
      String? input = stdin.readLineSync();
      if (input != null &&
          input.isNotEmpty &&
          RegExp(r'^[a-zA-Z가-힣]+$').hasMatch(input)) {
        return input;
      }
      print('올바르지 않은 이름입니다. 한글 또는 영문 대소문자만 사용해주세요.');
    }
  }
}
