class AtecResult {
  String? area;
  String? pontuation;

  AtecResult({this.area, this.pontuation});

  AtecResult.fromJson(Map<String, dynamic> json) {
    area = json['area'];
    pontuation = json['pontuation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['area'] = area;
    data['pontuation'] = pontuation;
    return data;
  }
}
