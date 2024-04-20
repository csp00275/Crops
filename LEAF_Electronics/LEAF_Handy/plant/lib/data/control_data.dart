class ItemName {
  List<int> counters;
  String nameOfTitle;
  List<String> restOfTitle;

  ItemName(
      {required this.counters,
      required this.nameOfTitle,
      required this.restOfTitle});
}

final List<ItemName> items = [
  ItemName(
      counters: [700, 500, 20, 3],
      nameOfTitle: 'CO2',
      restOfTitle: ['CO2', 'Limit Low', 'Interval', 'Duration']),
  ItemName(
      counters: [500, 2, 20, 3],
      nameOfTitle: 'Hum',
      restOfTitle: ['Hum', 'Limit Low', 'Interval', 'Duration']),
  ItemName(
      counters: [700, 500, 20],
      nameOfTitle: 'Temp',
      restOfTitle: ['Temp', 'Limit Low', 'Interval']),
  ItemName(
      counters: [700, 500, 20, 3],
      nameOfTitle: 'EC',
      restOfTitle: ['EC', 'Limit Low', 'Interval', 'Duration']),
];
