/////////////////////////////////////////////////////////////////
/*
  AWS IoT | Flutter MQTT Client App [Full Version]
  Video Tutorial: https://youtu.be/aY7i0xnQW54
  Created by Eric N. (ThatProject)
*/
/////////////////////////////////////////////////////////////////
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MQTT ESP32CAM VIEWER',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      home: MQTTClient(),
    );
  }
}

class MQTTClient extends StatefulWidget {
  const MQTTClient({Key? key}) : super(key: key);

  @override
  _MQTTClientState createState() => _MQTTClientState();
}

class _MQTTClientState extends State<MQTTClient> {
  String statusText = "Status Text";
  bool isConnected = false;
  TextEditingController idTextController = TextEditingController();

  final MqttServerClient client =
      MqttServerClient('a1q54soguztrms-ats.iot.us-west-2.amazonaws.com', '');

  @override
  void dispose() {
    idTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    final bool hasShortWidth = width < 600;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [body(hasShortWidth)],
        ),
      ),
    );
  }

  Widget body(bool hasShortWidth) {
    return Expanded(
      child: Container(
        child: hasShortWidth
            ? Column(
                children: [bodyMenu(), Expanded(child: bodySteam())],
              )
            : Row(
                children: [
                  Expanded(
                    child: bodyMenu(),
                    flex: 2,
                  ),
                  Expanded(
                    child: bodySteam(),
                    flex: 8,
                  )
                ],
              ),
      ),
      flex: 20,
    );
  }

  Widget bodyMenu() {
    return Container(
      color: Colors.black26,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextFormField(
                enabled: !isConnected,
                controller: idTextController,
                decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'MQTT Client Id',
                    labelStyle: TextStyle(fontSize: 10),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.subdirectory_arrow_left),
                      onPressed: _connect,
                    ))),
          ),
          isConnected
              ? TextButton(onPressed: _disconnect, child: Text('Disconnect'))
              : Container()
        ],
      ),
    );
  }

  Widget bodySteam() {
    return Container(
      color: Colors.black,
      child: StreamBuilder(
        stream: client.updates,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            );
          else {
            final mqttReceivedMessages =
                snapshot.data as List<MqttReceivedMessage<MqttMessage?>>?;

            final recMess =
                mqttReceivedMessages![0].payload as MqttPublishMessage;

            return Container();
          }
        },
      ),
    );
  }

  _connect() async {
    if (idTextController.text.trim().isNotEmpty) {
      isConnected = await mqttConnect(idTextController.text.trim());
    }
  }

  _disconnect() {
    client.disconnect();
  }

  Future<bool> mqttConnect(String uniqueId) async {
    setStatus("Connecting MQTT Broker");

    // After adding your certificates to the pubspec.yaml, you can use Security Context.
    //
    // ByteData rootCA = await rootBundle.load('assets/certs/RootCA.pem');
    // ByteData deviceCert =
    //     await rootBundle.load('assets/certs/DeviceCertificate.crt');
    // ByteData privateKey = await rootBundle.load('assets/certs/Private.key');
    //
    // SecurityContext context = SecurityContext.defaultContext;
    // context.setClientAuthoritiesBytes(rootCA.buffer.asUint8List());
    // context.useCertificateChainBytes(deviceCert.buffer.asUint8List());
    // context.usePrivateKeyBytes(privateKey.buffer.asUint8List());
    //
    // client.securityContext = context;

    client.logging(on: true);
    client.keepAlivePeriod = 20;
    client.port = 8883;
    client.secure = true;
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.pongCallback = pong;

    final MqttConnectMessage connMess =
        MqttConnectMessage().withClientIdentifier(uniqueId).startClean();
    client.connectionMessage = connMess;

    await client.connect();
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print("Connected to AWS Successfully!");
    } else {
      return false;
    }

    const topic = 'esp32/cam_0';
    client.subscribe(topic, MqttQos.atMostOnce);

    return true;
  }

  void setStatus(String content) {
    setState(() {
      statusText = content;
    });
  }

  void onConnected() {
    setStatus("Client connection was successful");
  }

  void onDisconnected() {
    setStatus("Client Disconnected");
    isConnected = false;
  }

  void pong() {
    print('Ping response client callback invoked');
  }
}
