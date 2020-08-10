class Parents {
  int id;
  int parentsId;

  Parents({ this.id, this.parentsId });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'parentsId': parentsId,
    };
  }
}