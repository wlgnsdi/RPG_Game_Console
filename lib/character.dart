// ignore_for_file: avoid_print

import 'dart:math';

import 'package:monster_battle_console/creature.dart';

class Character extends Creature {
  bool usedItem = false;
  Character(super.name, super.health, super.attackPower, super.defensePower);

  @override
  void attack(Creature monster) {
    int damage = max(0, attackPower - monster.defensePower);
    if (monster.health < damage) {
      monster.health = 0;
    } else {
      monster.health -= damage;
    }

    print('$name이(가) ${monster.name}에게 $damage의 데미지를 입혔습니다.');
  }

  @override
  void showStatus() {
    print('$name - 체력: $health, 공격력: $attackPower, 방어력: $defensePower');
  }

  void defend(int monsterAttack) {
    int damage = attackPower - monsterAttack;
    health += damage;

    print('$name이(가) 방어 태세를 취하여 $damage 만큼 체력을 얻었습니다.');
  }

  void useItem() {
    if (!usedItem) {
      print('특수 아이템을 사용하여 $name의 공격력이 두 배가 됩니다!');
      attackPower *= 2; // 한 턴 동안 공격력 2배 처리
      usedItem = true; // 아이템 사용 완료 처리
    } else {
      print('이미 특수 아이템을 사용하셨습니다.');
    }
  }
}
