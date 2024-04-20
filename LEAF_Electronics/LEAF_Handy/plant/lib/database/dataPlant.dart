// ignore_for_file: camel_case_types, file_names

class dataPlant {
  String? title;
  String? content;
  int? actvie;
  int? id;
  dataPlant({this.title, this.content, this.actvie, this.id});

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'content': content, 'actvie': actvie};
  }
}
