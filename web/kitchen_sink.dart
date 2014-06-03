import 'package:tekartik_jquery/jquery.dart';

main() {
  jQuerySelector("#to_fade_in")..hide()..fadeIn();
  jQuerySelector("#to_fade_in_slow")..hide()..fadeIn(FadeDuration.SLOW);
  jQuerySelector("#to_fade_out").fadeOut();
  jQuerySelector("#to_fade_out_slow").fadeOut(new FadeDuration.withDuration(2000));
}