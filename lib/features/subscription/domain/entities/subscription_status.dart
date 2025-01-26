enum SubscriptionStatus {
  active,
  inactive,
  expired,
  cancelled,
  pending;

  @override
  String toString() => name;

  bool get isActive => this == SubscriptionStatus.active;
}
