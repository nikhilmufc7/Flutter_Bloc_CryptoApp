import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:windmill_assignment/models/coin_model.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {
  final Coin coin;
  DetailScreen({@required this.coin});
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  List<Coin> favouriteCoins = [];

  @override
  void initState() {
    super.initState();
    getFavourites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: appBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Also known as : ${widget.coin.symbol}",
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.yellowAccent,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 20,
            ),
            infoWidget(
              'First Historical Data : ',
              formatDateTimeFromUtc(widget.coin.firstHistoricalData),
            ),
            infoWidget(
              'Last Historical Data : ',
              formatDateTimeFromUtc(widget.coin.lastHistoricalData),
            ),
            infoWidget(
              'Platform : ',
              widget.coin.platform != null
                  ? widget.coin.platform
                  : 'Not Available',
            ),
            addToFavouritesButton()
          ],
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.pop(context, 'pop'),
      ),
      title: Text(
        widget.coin.name,
        style: TextStyle(
            fontSize: 22, color: Colors.white, fontWeight: FontWeight.w700),
      ),
    );
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
    } else {
      favouriteCoins = [];
    }
  }

  infoWidget(String title, String subtitle) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
            fontSize: 20, color: Colors.white, fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
      ),
    );
  }

  addToFavouritesButton() {
    return Center(
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(favouriteCoins.contains(widget.coin)
                ? Icons.delete
                : Icons.add),
            Text(
              favouriteCoins.contains(widget.coin)
                  ? "Remove from favourites"
                  : "Add to favourites",
            ),
          ],
        ),
        onPressed: () async {
          if (favouriteCoins.contains(widget.coin)) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            setState(() {
              favouriteCoins.remove(widget.coin);
            });

            var encoder = json.encode(favouriteCoins.toList());
            prefs.setString('favourites', encoder);
          } else {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            setState(() {
              favouriteCoins.add(widget.coin);
            });

            var encoder = json.encode(favouriteCoins.toList());
            prefs.setString('favourites', encoder);
          }
        },
      ),
    );
  }

  // Date formatter
  String formatDateTimeFromUtc(dynamic time) {
    try {
      return DateFormat("dd-MM-yyyy hh:mm:ss")
          .format(DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(time));
    } catch (e) {
      return DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());
    }
  }
}
