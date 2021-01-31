import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:windmill_assignment/blocs/crypto/crypto_bloc.dart';
import 'package:windmill_assignment/models/coin_model.dart';
import 'package:windmill_assignment/repositories/crypto_repository.dart';

class MockApiTest extends Mock implements http.Client {}

main() {
  CryptoRepository cryptoRepository;
  CryptoBloc cryptoBloc;

  setUp(() {
    cryptoRepository = CryptoRepository();
    cryptoBloc = CryptoBloc(cryptoRepository: cryptoRepository);
  });
  group('CryptoBloc', () {
    test('throws AssertionError if CryptoRepository is null', () {
      expect(
        () => CryptoBloc(cryptoRepository: null),
        throwsA(isAssertionError),
      );
    });
  });

  group('fetchCoin', () {
    test('returns a Coin if the http call completes successfully', () async {
      final client = MockApiTest();
      when(client.get(
          'https://pro-api.coinmarketcap.com/v1/cryptocurrency/map?limit=12&start=1',
          headers: {
            'X-CMC_PRO_API_KEY': '365f4005-7776-49b6-8474-9dfdd023e0fd'
          })).thenAnswer((_) async => http.Response('{ "status": {} }', 200));

      expect(await fetchCoin(client), isA<Map>());
    });

    test('throws an exception if the http call completes with an error', () {
      final client = MockApiTest();
      when(client.get(
              'https://pro-api.coinmarketcap.com/v1/cryptocurrency/map?limit=12&start=1'))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(fetchCoin(client), throwsException);
    });
  });
}

Future<Coin> fetchCoin(http.Client client) async {
  final response =
      await client.get('https://jsonplaceholder.typicode.com/posts/1');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    return Coin.fromJson(jsonDecode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}
