// ignore_for_file: file_names, prefer_const_constructors

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:plant/MQTTClinetManager.dart';
import 'package:plant/appbasepage/01Data/dataNGraph.dart';

class Sensor {
  final String name;
  final String unit;
  final List graph;
  final double minYdata;
  final double maxYdata;
  final IconData icon;
  final Color color;
  final double size;

  Sensor(
      {required this.name,
      required this.unit,
      required this.graph,
      required this.minYdata,
      required this.maxYdata,
      required this.icon,
      required this.color,
      required this.size});
}

final List<Sensor> sensors = [
  Sensor(
      name: '온도',
      unit: 'C',
      graph: [],
      minYdata: 0,
      maxYdata: 35,
      icon: Icons.thermostat,
      color: Colors.red,
      size: 80),
  Sensor(
    name: '습도',
    unit: '%',
    graph: [],
    minYdata: 40,
    maxYdata: 80,
    icon: Icons.water_drop,
    color: Colors.blue,
    size: 80,
  ),
  Sensor(
    name: '이산화탄소',
    unit: 'ppm',
    graph: [],
    minYdata: 10000,
    maxYdata: 15000,
    icon: Icons.gas_meter,
    color: Colors.black,
    size: 80,
  ),
  Sensor(
    name: 'EC',
    unit: '?',
    graph: [],
    minYdata: 0,
    maxYdata: 2.5,
    icon: Icons.electric_bolt,
    color: Colors.yellow,
    size: 80,
  ),
  Sensor(
    name: 'pH',
    unit: '',
    graph: [],
    minYdata: 5,
    maxYdata: 8,
    icon: Icons.rectangle,
    color: Colors.black,
    size: 80,
  ),
];

class DetailPage extends StatefulWidget {
  final List<String>? devices;
  final int? index;

  DetailPage({
    Key? key,
    this.devices,
    this.index,
  }) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String pt = '';
  MQTTClientManager mqttClientManager = MQTTClientManager();
  final String pubTopic = "outTopic";
  final String subTopic = "sensors";
  List<String> receivedData = [];
  List<double> values = [];
  int messageIndex = 0;

  @override
  void initState() {
    setupMqttClient(subTopic);
    super.initState();
  }

  Widget _messageStream(int messageIndex) {
    return Container(
      child: StreamBuilder<List<MqttReceivedMessage<MqttMessage>>>(
        stream: mqttClientManager.getMessagesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final recMess = snapshot.data![0].payload as MqttPublishMessage;
            final String pt = MqttPublishPayload.bytesToStringAsString(
                recMess.payload.message);
            final List<double> values =
                pt.split(',').map((e) => double.parse(e)).toList();
            sensors[messageIndex].graph.add(values[messageIndex]);
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Colors.grey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                sensors[messageIndex].icon,
                                color: sensors[messageIndex].color,
                                size: sensors[messageIndex].size,
                              ),
                              Text(
                                "${sensors[messageIndex].name}",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                              Text(
                                "${values[messageIndex]}"
                                " ${sensors[messageIndex].unit}",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        color: Colors.amber,
                        height: 130,
                        width: 200,
                        child: LineChart(
                          LineChartData(
                            lineBarsData: [
                              LineChartBarData(
                                spots: [
                                  for (int i = 0;
                                      i < sensors[messageIndex].graph.length;
                                      i++)
                                    FlSpot(
                                        i.toDouble() * 0.5,
                                        sensors[messageIndex]
                                            .graph[i]
                                            .toDouble()),
                                ],
                                isCurved: true,
                                color: Colors.red,
                                barWidth: 2,
                                dotData: FlDotData(
                                  show: false,
                                ),
                              ),
                            ],
                            minY: sensors[messageIndex].minYdata,
                            maxY: sensors[messageIndex].maxYdata,
                            gridData: FlGridData(
                              show: false,
                            ),
                            titlesData: FlTitlesData(
                              show: true,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Future<void> setupMqttClient(subTopic) async {
    await mqttClientManager.connect();
    mqttClientManager.subscribe(subTopic);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.devices![widget.index ?? 0]}"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              _messageStream(0),
              _messageStream(1),
              _messageStream(2),
              _messageStream(3),
              _messageStream(4),
              Text(
                'pubTopic: $pubTopic\nsubTopic: $subTopic',
                style: TextStyle(fontSize: 20),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    mqttClientManager.disconnect();
    super.dispose();
  }
}
