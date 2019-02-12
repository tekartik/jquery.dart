part of tekartik_jquery;

// ignore_for_file: non_constant_identifier_names
class _FadeDurationStringEnum extends Object with FadeDuration {
  final String name;
  _FadeDurationStringEnum(this.name);
  @override
  dynamic get value => name;
}

class _FadeDurationNumber extends Object with FadeDuration {
  final int duration;
  _FadeDurationNumber(this.duration);

  @override
  dynamic get value => duration;
}

abstract class FadeDuration {
  factory FadeDuration.withName(String name) {
    return _FadeDurationStringEnum(name);
  }
  factory FadeDuration.withDuration(int ms) {
    return _FadeDurationNumber(ms);
  }
  dynamic get value;
  @deprecated
  static final FadeDuration SLOW = FadeDuration.withName("slow");
  @deprecated
  static final FadeDuration FAST = FadeDuration.withName("fast");
  static final FadeDuration slow = FadeDuration.withName("slow");
  static final FadeDuration fast = FadeDuration.withName("fast");
}
