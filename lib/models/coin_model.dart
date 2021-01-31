import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Coin extends Equatable {
  var id;
  String name;
  String symbol;
  String slug;
  String firstHistoricalData;
  String lastHistoricalData;
  var platform;
  int isActive;

  Coin({
    @required this.id,
    @required this.name,
    @required this.symbol,
    @required this.slug,
    @required this.firstHistoricalData,
    @required this.lastHistoricalData,
    @required this.isActive,
    @required this.platform,
  });

  @override
  List<Object> get props => [
        name,
        id,
        symbol,
        slug,
        platform,
      ];

  @override
  String toString() => 'Coin { name: $name, }';

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      id: json['id'],
      symbol: json['symbol'],
      slug: json['slug'],
      platform: json['platform'],
      isActive: json['is_active'],
      firstHistoricalData: json['first_historical_data'],
      lastHistoricalData: json['last_historical_data'],
      name: json['name'],

      // price: (json['RAW']['USD']['PRICE'] as num).tovar(),
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['symbol'] = this.symbol;
    data['slug'] = this.slug;
    data['is_active'] = this.isActive;
    data['first_historical_data'] = this.firstHistoricalData;
    data['last_historical_data'] = this.lastHistoricalData;
    data['platform'] = this.platform;
    return data;
  }
}
