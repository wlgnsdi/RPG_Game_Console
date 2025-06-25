// ignore_for_file: avoid_print
import 'dart:math';

import 'package:monster_battle_console/creature.dart';

class Monster extends Creature {
  int increaseDefenceCount = 0;
  Monster(name, health, attackPower) : super(name, health, attackPower, 0);

  @override
  void attack(Creature target) {
    int damage = max(0, attackPower - target.defensePower);
    target.health -= damage;
    print('$name이(가) ${target.name}에게 $damage의 데미지를 입혔습니다.');
  }

  @override
  void showStatus() {
    print('$name - 체력: $health, 공격력: $attackPower, 방어력 : $defensePower');
  }

  void increaseDefence() {
    defensePower += 2;
    increaseDefenceCount = 0;
  }
}
