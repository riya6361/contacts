class Contact {
  static const tableName = "Contacts";
  static const colId = "ColId";
  static const colName = "ColName";
  static const colMobileNo = "ColMobileNo";

  Contact({
    this.id,
    this.name,
    this.mobileNumber,
  });

  int id;
  String name;
  String mobileNumber;

   Contact.formMap(Map<String, dynamic> map) {
    id = map[colId];
    name = map[colName];
    mobileNumber = map[colMobileNo];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      colName: name,
      colMobileNo: mobileNumber,
    };
    if (id != null) {
      map[colId] = id;
    }
    return map;
  }
}