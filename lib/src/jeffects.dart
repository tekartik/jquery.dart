part of tekartik_jquery;

class _FadeDurationStringEnum extends StringEnum with FadeDuration {}

class _FadeDurationNumber extends Object with FadeDuration {
  final int duration;
  _FadeDurationNumber(this.duration);

  int get value => duration;
}

abstract class FadeDuration {

  factory FadeDuration.withName(String name) {
    return new _FadeDurationStringEnum()..name = name;
  }
  factory FadeDuration.withDuration(int ms) {
    return new _FadeDurationNumber(ms);
  }
  dynamic get value;
  static final FadeDuration SLOW = new FadeDuration.withName("slow");
  static final FadeDuration FAST = new FadeDuration.withName("fast");
}
