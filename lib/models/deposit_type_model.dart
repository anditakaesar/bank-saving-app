class DepositTypeList {
  final List<DepositType> deposittypes;

  DepositTypeList({required this.deposittypes});

  factory DepositTypeList.fromJson(Map<String, dynamic> json) {
    var list = json['body']['list'] as List;
    List<DepositType> deposittypes = list
        .map((i) => DepositType.fromJson(i))
        .toList();
    return DepositTypeList(deposittypes: deposittypes);
  }

  Map<String, dynamic> toJson() {
    return {'list': deposittypes.map((item) => item.toJson()).toList()};
  }
}

class DepositType {
  final int id;
  final String name;
  final String annualInterestRate;

  DepositType({
    required this.id,
    required this.name,
    required this.annualInterestRate,
  });

  factory DepositType.fromJson(Map<String, dynamic> json) {
    return DepositType(
      id: json['id'],
      name: json['name'],
      annualInterestRate: json['annualInterestRate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'annualInterestRate': annualInterestRate};
  }
}
