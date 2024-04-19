import 'package:flutter/material.dart';
import 'package:multi_bar/data/app_bar.dart';
import 'package:multi_bar/widgets/tap_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: ConstrainedBox(
        constraints: const BoxConstraints.expand(), // Set height to infinite
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var data in dummyData['headers']!)
                Flexible(
                  child: SizedBox(
                    height: 450,
                    child: CustomTabBar(
                      dummyData: data,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
