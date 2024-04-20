// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, sort_child_properties_last, file_names

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:plant/MQTTClinetManager.dart';

class Robot extends StatefulWidget {
  const Robot({super.key});

  @override
  State<Robot> createState() => _RobotState();
}

class _RobotState extends State<Robot> {
  int _counter = 0;
  String pt = '';
  MQTTClientManager mqttClientManager = MQTTClientManager();
  final String pubTopic = "outTopic";
  final String subTopic = "sensors";

  List<String> receivedData = [];

  @override
  void initState() {
    setupMqttClient(subTopic);
    super.initState();
  }

  void _messagePublish() {
    setState(() {
      _counter++;
      mqttClientManager.publishMessage(
          pubTopic, "Increment button pushed ${_counter.toString()} times.");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(
              'Temp: Hum: C02',
            ),
            _messageStream(),
          ],
        ),
      ),
    );
  }

  Future<void> setupMqttClient(subTopic) async {
    await mqttClientManager.connect();
    mqttClientManager.subscribe(subTopic);
  }

  Widget _messageStream() {
    return Container(
      child: StreamBuilder<List<MqttReceivedMessage<MqttMessage>>>(
        stream: mqttClientManager.getMessagesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final recMess = snapshot.data![0].payload as MqttPublishMessage;
            final pt = MqttPublishPayload.bytesToStringAsString(
                recMess.payload.message);
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(pt, style: TextStyle(fontSize: 30)),
              ],
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    mqttClientManager.disconnect();
    super.dispose();
  }
}
