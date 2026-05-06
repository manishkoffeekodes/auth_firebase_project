class MarketModel {
  final String id;
  final String name;
  final String openTime;
  final String closeTime;
  final bool isLive;
  final String status; // 'OPEN' or 'CLOSED'

  MarketModel({
    required this.id,
    required this.name,
    required this.openTime,
    required this.closeTime,
    this.isLive = false,
    required this.status,
  });
}
