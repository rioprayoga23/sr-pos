import 'package:flutter/material.dart';
import 'package:sr_pos/core/design_system/theme/sr_semantic_colors.dart';
import 'package:sr_pos/core/design_system/theme/sr_status_colors.dart';

/// Typed access to SR-POS theme extensions.
extension SrThemeContext on BuildContext {
  SrSemanticColors get srColors {
    final colors = Theme.of(this).extension<SrSemanticColors>();
    assert(colors != null, 'SrSemanticColors must be registered in ThemeData.');
    return colors!;
  }

  SrStatusColors get srStatusColors {
    final colors = Theme.of(this).extension<SrStatusColors>();
    assert(colors != null, 'SrStatusColors must be registered in ThemeData.');
    return colors!;
  }
}
