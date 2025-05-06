import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music/presentation/componnent/tag.dart';
import 'package:music/presentation/playlistScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(child: Column(children: [Tag(label: "Nghe tiếp")],)),
      appBar: AppBar(
        title: ListTile(
          title: Text("Hi!"),
          subtitle: Text("khoadonguyen1312@gmail.com"),
        ),

        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PLayListScreen()),
              );
            },
            icon: Icon(CupertinoIcons.chart_bar),
          ),
        ],
      ),
    );
  }
}
