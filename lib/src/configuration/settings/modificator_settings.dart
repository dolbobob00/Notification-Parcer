abstract class IModificator {
  int get modificatorLevel;
  set modificatorLevel(int level);
  void upgradeModLevelBy({int byHowManyLevels = 1});
  void decreaseModLevelBy({int byHowManyLevels = 1});
}

class ModificatorSettings implements IModificator {
  // ignore: unused_field
  late int _modificatorLvl;

  @override
  void upgradeModLevelBy({int byHowManyLevels = 1}) {
    modificatorLevel = modificatorLevel + byHowManyLevels;
  }

  @override
  void decreaseModLevelBy({int byHowManyLevels = 1}) {
    if (modificatorLevel > 1) {
      modificatorLevel = modificatorLevel - byHowManyLevels;
    }
  }

  @override
  int get modificatorLevel => throw UnimplementedError();

  @override
  set modificatorLevel(int level) {
    _modificatorLvl = level;
  }
}
