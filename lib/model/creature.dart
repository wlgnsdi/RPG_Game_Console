// ignore_for_file: avoid_print

abstract class Creature {
  final String name;
  int health;
  final int attackPower;
  final int defensePower;

  Creature(this.name, this.health, this.attackPower, this.defensePower);

  void attack(Creature target);

  void showStatus();
}
