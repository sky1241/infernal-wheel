/// Systeme de spacing base sur 4px
/// Conforme aux standards WCAG et UX modernes
class Spacing {
  // Base unit = 4px
  static const double unit = 4;

  // Spacing scale
  static const double xxs = 4;   // unit * 1
  static const double xs = 8;    // unit * 2
  static const double sm = 12;   // unit * 3
  static const double md = 16;   // unit * 4
  static const double lg = 20;   // unit * 5
  static const double xl = 24;   // unit * 6
  static const double xxl = 32;  // unit * 8
  static const double xxxl = 48; // unit * 12

  // Touch targets (WCAG 2.5.8)
  // iOS: 44pt minimum
  // Android: 48dp minimum
  static const double touchTarget = 48;
  static const double touchTargetMin = 44;

  // Border radius
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;
  static const double radiusFull = 999;

  // Icon sizes
  static const double iconSm = 16;
  static const double iconMd = 24;
  static const double iconLg = 32;
  static const double iconXl = 48;

  // Common paddings
  static const double screenPadding = md;
  static const double cardPadding = md;
  static const double listItemPadding = sm;

  // Common gaps
  static const double listGap = sm;
  static const double sectionGap = xl;
}
