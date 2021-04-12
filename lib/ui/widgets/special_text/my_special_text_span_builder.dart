import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:neighbours/ui/widgets/special_text/at_text.dart';
import 'package:neighbours/ui/widgets/special_text/dollar_text.dart';
import 'package:neighbours/ui/widgets/special_text/emoji_text.dart';

class MySpecialTextSpanBuilder extends SpecialTextSpanBuilder {
  @override
  SpecialText createSpecialText(String flag,
      {TextStyle textStyle, SpecialTextGestureTapCallback onTap, int index}) {
    if (flag == null || flag == "") return null;

    if (isStart(flag, AtText.flag)) {
      return AtText(textStyle, onTap);
    } else if (isStart(flag, EmojiText.flag)) {
      return EmojiText(textStyle);
    } else if (isStart(flag, DollarText.flag)) {
      return DollarText(textStyle, onTap);
    }
    return null;
  }
}
