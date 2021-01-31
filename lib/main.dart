import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windmill_assignment/blocs/crypto/crypto_bloc.dart';
import 'package:windmill_assignment/repositories/crypto_repository.dart';
import 'package:windmill_assignment/screens/bottom_bar.dart';
import 'package:windmill_assignment/screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CryptoBloc>(
      create: (_) => CryptoBloc(
        cryptoRepository: CryptoRepository(),
      )..add(AppStarted()),
      child: MaterialApp(
        title: 'Windmill Assignment',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.black,
          accentColor: Colors.tealAccent,
        ),
        home: BottomBarPage(),
      ),
    );
  }
}
