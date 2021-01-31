import 'dart:convert';

import 'package:windmill_assignment/models/coin_model.dart';
import 'package:windmill_assignment/repositories/base_crypto_repository.dart';
import 'package:http/http.dart' as http;

class CryptoRepository extends BaseCryptoRepository {
  static const String _baseUrl = 'https://pro-api.coinmarketcap.com';
  static const int perPage = 12;

  final http.Client _httpClient;

  CryptoRepository({http.Client httpClient})
      : _httpClient = httpClient ?? http.Client();

  @override
  Future<List<Coin>> getTopCoins({int page}) async {
    List<Coin> coins = [];
    String requestUrl =
        '$_baseUrl/v1/cryptocurrency/map?limit=$perPage&start=$page';
    print(requestUrl);
    try {
      final response = await _httpClient.get(requestUrl, headers: {
        'X-CMC_PRO_API_KEY': '365f4005-7776-49b6-8474-9dfdd023e0fd'
      });
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        print(data['data']);
        List<dynamic> coinList = data['data'];
        coinList.forEach(
          (json) => coins.add(Coin.fromJson(json)),
        );
      }
      return coins;
    } catch (err) {
      // throw err;
      print(err);
    }
  }

  @override
  void dispose() {
    _httpClient.close();
  }
}
