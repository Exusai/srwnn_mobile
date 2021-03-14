import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:srwnn_mobile/Controllers/databaseService.dart';

import 'Controllers/app_localizations.dart';
import 'Models/subscriptionData.dart';
import 'Models/user.dart';

final String cr5 = '5_cr';
final String cr15 = '15_cr';
final String cr50 = '50_cr';

class BuyCR extends StatefulWidget {
  final userUID;
  BuyCR({this.userUID});
  @override
  _BuyCRState createState() => _BuyCRState();
}

class _BuyCRState extends State<BuyCR> {
  InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;
  bool _available = true;
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  StreamSubscription _subscription;

  int _credits = 5;
  String itemSelected = cr5;

  //bool addCR =  false;

  @override
  void initState() { 
    _initialize();
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _initialize() async {
    _available = await _iap.isAvailable();
    if(_available){
      await _getProducts();
      await _getPastPurchases();
      _verifyPurchase(widget.userUID);

      _subscription = _iap.purchaseUpdatedStream.listen((data) async {
        setState(() {
          print('New purchase intent');
          _purchases.addAll(data);
          _verifyPurchase(widget.userUID);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Usuario>(context) ?? Usuario(uid: '', isAnon: true);

    return Scaffold(
      appBar: AppBar(
        title: Text(_available ? AppLocalizations.of(context).translate('purchase_cr') : AppLocalizations.of(context).translate('not_available')),
      ),

      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.asset('assets/launcher/icon.png', height: 300,),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomLeft:  Radius.circular(20), bottomRight:  Radius.circular(20)),
                        color: Colors.black87
                      ),
                      height: 50,
                      //color: Colors.black.withAlpha(50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(AppLocalizations.of(context).translate('you_have'), style: TextStyle(fontSize: 18)),
                          StreamBuilder<UserCredits>(
                            stream: CheckOutService(uid: user.uid).userCR,
                            initialData: UserCredits(credits: 0),
                            builder: (context, snapshot) {
                              UserCredits userCredits = snapshot.data ?? UserCredits(credits: 0);
                              return Text(userCredits.credits.toString() , style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18));
                            }
                          ),
                          Text(' CR', style: TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Divider(),
              for (var prod in _products)
                /* if(_hasPurchased(prod.id) != null)
                  ...[
                    Text('You have CR')
                  ] */
                ...[
                  Text(prod.title.split('(ExusAI Super Resolution').first, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25)),
                  Text(prod.description, textAlign: TextAlign.center,),
                  //Text(prod.price, style: TextStyle(color: Colors.blueAccent, /* fontSize: 60 */)),
                  ElevatedButton(
                    child: Text(prod.price),
                    //color: Colors.blue,
                    onPressed: () {
                      setState(() {
                        itemSelected = prod.id;
                      });
                      _buyProduct(prod);
                    },
                  ),
                  Divider(),
                ]
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getProducts() async {
    Set<String> ids = Set.from([cr5, cr15]);
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);
    setState(() {
      _products = response.productDetails;
      //print(_products);      
    });
  }

  Future<void> _getPastPurchases() async {
    QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases();
    // TODO: query your database for state of consumable products

    setState(() {
      _purchases = response.pastPurchases;
    });
  }

  PurchaseDetails _hasPurchased(String productID) {
    return _purchases.firstWhere((purchase) => purchase.productID == productID, orElse: () => null);
  }

  void _verifyPurchase(String uid) {
    PurchaseDetails purchase = _hasPurchased(itemSelected); 
    //server side verification & record consumable to database
    if (purchase != null && purchase.status == PurchaseStatus.purchased){
      _credits = 5;
      if (itemSelected == cr5){
        _credits = 5;
      } else if (itemSelected == cr15) {
        _credits = 15;
      } else _credits = 5;

      //print('CR COMPRADO: ' + _credits.toString(),);
      //await DatabaseService(uid: uid).addCR(_credits);
      showDialog(context: context, builder: (_) => successDialog(context));

      
    }
  }

  _buyProduct(ProductDetails prod) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
    _iap.buyConsumable(purchaseParam: purchaseParam);
  }

  AlertDialog successDialog(context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).translate('success')),
      content: FutureBuilder(
        future: DatabaseService(uid: widget.userUID).addCR(_credits),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && !snapshot.hasError){
            return Text(AppLocalizations.of(context).translate('cr_added'));
          } if (snapshot.connectionState == ConnectionState.done && snapshot.hasError){
            return Text('Error');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            //await DatabaseService(uid: widget.userUID).addCR(_credits);
            //print('CR pressed');
            Navigator.pop(context);
          },
          child: Text('Ok'),
        ),
      ],
    );
}

}