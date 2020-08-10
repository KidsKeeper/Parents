class ParentsKids {
  int id;
  int kidsId;

  String key;
  String name;

  ParentsKids({ this.id, this.kidsId, this.key, this.name });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'kidsId': kidsId,
      'key': key,
      'name': name
    };
  }
}