import 'package:flutter/material.dart';
import 'package:music/presentation/componnent/BottomSheet.dart';
import 'package:music/service/audio_player/impl/dynamicAudioPlayerImpl.dart';
import 'package:music/service/playlist/playlist.dart';
import 'package:provider/provider.dart';
import 'service/youtube/impl/yotube_service_impl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DynamicAudioPlayerImpl()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xff4ED7F1),
            brightness: Brightness.dark,
          ),
        ).copyWith(
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: <TargetPlatform, PageTransitionsBuilder>{
              TargetPlatform.android: ZoomPageTransitionsBuilder(),
            },
          ),
        ),
        home: const App(),
      ),
    );
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return DynamicBottomSheet();
  }
}

class TestScreen extends StatelessWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () async {
              debugPrint('Fetching audio link...');
              // final audioUrl = await YotubeServiceImpl().extractAudio(
              //   '"Qsk6bMvGj_o"',
              // );
              // debugPrint(audioUrl);
              // List<String> items=   await YotubeServiceImpl().extractAudios(["EYaP4h6njtI","PbkI4PFmvpo"]);
              //  for(var i in items){
              //    print(i);
              //  }

              // final searchs =await YotubeServiceImpl().search("nơi này có anh");
              // for(var recomand_id in searchs){
              //   debugPrint(recomand_id);
              // }
              await DynamicAudioPlayerImpl().start("EYaP4h6njtI", []);
            },
            child: const Text('Play Audio'),
          ),
        ),
      ),
    );
  }
}
