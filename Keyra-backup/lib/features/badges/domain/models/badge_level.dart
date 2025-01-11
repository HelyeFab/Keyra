import 'badge_requirements.dart';

enum BadgeLevel {
  beginner,
  intermediate,
  advanced,
  master,
  explorer,
  voyager,
  weaver,
  navigator,
  pioneer,
  royalty,
  baron,
  legend,
  wizard,
  epic,
  titan,
  sovereign,
  virtuoso,
  luminary,
  beacon,
  radiant,
  lighthouse,
  infinite,
  renaissance,
  ultimate;

  String get displayName => BadgeRequirements.getRequirementsForLevel(this).displayName;
  String get assetPath => BadgeRequirements.getRequirementsForLevel(this).assetPath;

  static BadgeLevel fromDisplayName(String name) {
    return BadgeLevel.values.firstWhere(
      (level) => level.displayName == name,
      orElse: () => BadgeLevel.beginner,
    );
  }
}
