// ignore_for_file: avoid_print

import 'dart:math';

import 'package:monster_battle_console/model/creature.dart';

class Character extends Creature {
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
}
