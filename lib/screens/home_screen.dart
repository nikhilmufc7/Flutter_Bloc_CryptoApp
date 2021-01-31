import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windmill_assignment/blocs/crypto/crypto_bloc.dart';
import 'package:windmill_assignment/models/coin_model.dart';
import 'package:windmill_assignment/screens/detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Coins'),
      ),
      body: BlocBuilder<CryptoBloc, CryptoState>(
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).primaryColor,
                  Colors.grey[900],
                ],
              ),
            ),
            child: _buildBody(state),
          );
        },
      ),
    );
  }

  _buildBody(CryptoState state) {
    if (state is CryptoLoading) {
      return loadingWidget();
    } else if (state is CryptoLoaded) {
      return RefreshIndicator(
        color: Theme.of(context).accentColor,
        onRefresh: () async {
          context.bloc<CryptoBloc>().add(RefreshCoins());
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) =>
              _onScrollNotification(notification, state),
          child: ListView.builder(
            controller: _scrollController,
            itemCount: state.coins.length,
            itemBuilder: (BuildContext context, int index) {
              final coin = state.coins[index];
              return cryptoTile(coin, index);
            },
          ),
        ),
      );
    } else if (state is CryptoError) {
      return errorWidget();
    }
  }

  bool _onScrollNotification(ScrollNotification notif, CryptoLoaded state) {
    if (notif is ScrollEndNotification &&
        _scrollController.position.extentAfter == 0) {
      context.bloc<CryptoBloc>().add(LoadMoreCoins(coins: state.coins));
    }
    return false;
  }

  cryptoTile(Coin coin, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailScreen(
                      coin: coin,
                    )));
      },
      child: ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '${++index}',
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        title: Text(
          coin.name,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          coin.name,
          style: TextStyle(color: Colors.white70),
        ),
        // trailing: Text(
        //   '\$${coin.quote.uSD.price.toStringAsFixed(2)}',
        //   style: TextStyle(
        //     color: Theme.of(context).accentColor,
        //     fontWeight: FontWeight.w600,
        //   ),
        // ),
      ),
    );
  }

  errorWidget() {
    return Center(
      child: Text(
        'Error loading coins!\nPlease check your connection',
        style: TextStyle(
          color: Theme.of(context).accentColor,
          fontSize: 18.0,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  loadingWidget() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Theme.of(context).accentColor),
      ),
    );
  }
}
