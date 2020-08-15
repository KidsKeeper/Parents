class KidsPolygon {
  int id;
  int kidsId;

  String source;
  String destination;
  String polygon;
  String start;
  String end;
  String date;

  KidsPolygon({ this.id, this.kidsId, this.source, this.destination, this.start, this.end, this.polygon, this.date });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'kidsId': kidsId,
      'source': source,
      'destination': destination,
      'start': start,
      'end': end,
      'polygon': polygon,
      'date': date
    };
  }
}