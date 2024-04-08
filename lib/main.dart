import 'dart:convert' as convert;

import 'package:arz/model/arz_model.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fa'), // farsi
      ],
      theme: ThemeData(
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: "Vazir",
          ),
          bodyMedium: TextStyle(
            fontSize: 13,
            fontFamily: "Vazir",
          ),
          displayMedium: TextStyle(
            fontSize: 14,
            fontFamily: "Vazir",
            fontWeight: FontWeight.w700,
          ),
          displaySmall: TextStyle(
            fontFamily: "Vazir",
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        scaffoldBackgroundColor: const Color(0xffF3F3F3),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        fontFamily: "Vazir",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ArzModel> currency = [];

  getData() {
    var url =
        'https://sasansafari.com/flutter/api.php?access_key=flutter123456';
    http.get(Uri.parse(url)).then((value) {
      if (currency.isEmpty) {
        if (value.statusCode == 200) {
          List jsonList = convert.jsonDecode(value.body);

          if (jsonList.isNotEmpty) {
            for (var i = 0; i < jsonList.length; i++) {
              setState(
                () {
                  currency.add(
                    ArzModel(
                      id: jsonList[i]['id'],
                      title: jsonList[i]['title'],
                      price: jsonList[i]['price'],
                      changes: jsonList[i]['changes'],
                      status: jsonList[i]['status'],
                    ),
                  );
                },
              );
            }
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    getData();
    final themData = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/img/logo.png'),
        title: Text(
          'قیمت به‌روز ارز',
          style: themData.displayLarge,
        ),
        actions: const [
          Icon(Icons.menu),
          SizedBox(
            width: 8,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset('assets/img/q.png'),
                const SizedBox(
                  width: 6,
                ),
                Text(
                  'نرخ ارز آزاد چیست؟ ',
                  style: themData.displayLarge,
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              ' نرخ ارزها در معاملات نقدی و رایج روزانه است معاملات نقدی معاملاتی هستند که خریدار و فروشنده به محض انجام معامله، ارز و ریال را با هم تبادل می نمایند.',
              textAlign: TextAlign.right,
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              height: 34,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'نام آزاد ارز',
                    style: themData.displaySmall,
                  ),
                  Text(
                    'قیمت ',
                    style: themData.displaySmall,
                  ),
                  Text(
                    'تغییر',
                    style: themData.displaySmall,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 250,
              child: ListView.builder(
                itemCount: currency.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return CartItem(
                    currency: currency[index],
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              height: 54,
              decoration: BoxDecoration(
                color: const Color(0xffE8E8E8),
                borderRadius: BorderRadius.circular(1000),
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffCAC1FF),
                      borderRadius: BorderRadius.circular(1000),
                    ),
                    child: TextButton.icon(
                      onPressed: () {
                        _showToast('به روز رسانی با موفقیت انجام شد')
                            .show(context);
                      },
                      icon: const Icon(
                        CupertinoIcons.refresh,
                        color: Colors.black,
                      ),
                      label: Text(
                        'به روز رسانی',
                        style: themData.displayMedium,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(left: 14),
                    child: Text('اخرین به روزرسانی ${_getTime()}'),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  /// this method for show Toast
  CherryToast _showToast(String message) {
    return CherryToast.success(
        animationType: AnimationType.fromRight,
        title: Text(
          message,
          style: const TextStyle(color: Colors.black),
        ));
  }

  /// this method for get time
  String _getTime() {
    return '20:45';
  }
}

/// this is  for Cart item ListView Price
class CartItem extends StatelessWidget {
  final ArzModel currency;
  const CartItem({
    super.key,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 54,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(currency.title),
          Text(currency.price),
          Text(
            currency.changes,
            style: currency.status == 'n'
                ? ThemeData().textTheme.displaySmall!.apply(
                      color: Colors.red,
                    )
                : ThemeData()
                    .textTheme
                    .displaySmall!
                    .apply(color: Colors.green),
          ),
        ],
      ),
    );
  }
}
