import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:windmill_assignment/models/coin_model.dart';
import 'package:windmill_assignment/screens/detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavouriteScreen extends StatefulWidget {
  FavouriteScreen({Key key}) : super(key: key);

  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  List<Coin> favouriteCoins = [];

  @override
  void initState() {
    super.initState();
    getFavourites();
  }

  getFavourites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var getFavs = prefs.getString("favourites");

    if (getFavs != null) {
      var items = json.decode(getFavs);
      items.forEach((item) {
        setState(() {
          var parsedItem = Coin.fromJson(item);
          favouriteCoins.add(parsedItem);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
      child: Scaffold(
        backgroundColor: Colors.transparent.withOpacity(0),
        appBar: AppBar(
          title: Text('Favourites'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Visibility(
                visible: favouriteCoins.isNotEmpty,
                child: ListView.builder(
                  itemCount: favouriteCoins.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return cryptoTile(favouriteCoins[index], index);
                  },
                ),
              ),
              Visibility(
                visible: favouriteCoins.isEmpty,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 3),
                  child: Center(
                    child: Text('No Favourites found',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  cryptoTile(Coin coin, int index) {
    return GestureDetector(
      onTap: () {
        final result = Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailScreen(
                      coin: coin,
                    )));
        print("result is");
        print(result);

        if (result != null) {
          getFavourites();
        }
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
      ),
    );
  }
}
