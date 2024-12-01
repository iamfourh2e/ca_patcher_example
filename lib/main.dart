import 'package:cosmos_ca_patcher/cosmos_ca_patcher.dart';
import 'package:example/proto/echo.pbgrpc.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

MyChannelCredentials? creds;

class _MyAppState extends State<MyApp> {
  final String url = "http://192.168.1.2:3000";
  final String sha =
      "e589d16508eff8f84592706f3f4cf8e14327adf8396699bb1861ad03a02029de";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: DownloadCAPage(
          url: url,
          sha: sha,
          child: creds == null ? Container() : Home(),
          onChannelCreated: (c) {
            setState(() {
              creds = c;
            });
          },
        ));
  }
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String txt = "";
  late EchoClient echoClient;

  final downloadCA = DownloadCA();
  initChannel(ClientChannel? channel) async {
    // channel = cmPatcher.grpcController!.getChannel("192.168.1.2", 6969);
    echoClient = EchoClient(channel!);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 200), () {
      var channel = downloadCA.getChannel(creds!, "192.168.1.2", 6969);
      initChannel(channel);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              echoClient
                  .echo(EchoRequest()..message = "Hello World")
                  .then((value) {
                setState(() {
                  txt = value.message;
                });
              });
            },
            child: Icon(Icons.download)),
        appBar: AppBar(
          title: Text('Home'),
        ),
        body: Center(
          child: Text(txt),
        ));
  }
}
