import 'package:tekartik_jquery/jquery.dart';

void main() {
  jQuerySelector('#to_fade_in')!
    ..hide()
    ..fadeIn();
  jQuerySelector('#to_fade_in_slow')!
    ..hide()
    ..fadeIn(FadeDuration.slow);
  jQuerySelector('#to_fade_out')!.fadeOut();
  jQuerySelector('#to_fade_out_slow')!.fadeOut(FadeDuration.withDuration(2000));
}
