class Loan {
  final String id;
  final String bookId;
  final String studentId;
  final DateTime borrowDate;
  final DateTime dueDate;
  DateTime? returnDate;

  Loan({
    required this.id,
    required this.bookId,
    required this.studentId,
    required this.borrowDate,
    required this.dueDate,
    this.returnDate,
  });

  bool get isReturned => returnDate != null;

  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      id: json['id'],
      bookId: json['bookId'],
      studentId: json['studentId'],
      borrowDate: DateTime.parse(json['borrowDate']),
      dueDate: DateTime.parse(json['dueDate']),
      returnDate: json['returnDate'] != null
          ? DateTime.parse(json['returnDate'])
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookId': bookId,
      'studentId': studentId,
      'borrowDate': borrowDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'returnDate': returnDate?.toIso8601String(),
    };
  }
}