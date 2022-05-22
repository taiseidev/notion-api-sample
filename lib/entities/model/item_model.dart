class Item {
  final String name;
  final String category;
  final String categoryColor;
  final double price;
  final DateTime date;

  const Item({
    required this.name,
    required this.category,
    required this.categoryColor,
    required this.price,
    required this.date,
  });

  factory Item.fromMap(Map<String, dynamic> map) {
    final properties = map['properties'] as Map<String, dynamic>;
    final nameList = (properties['name']?['title'] ?? []) as List;
    final dateStr = properties['date']?['date']?['start'];
    return Item(
      name: nameList.isNotEmpty ? nameList[0]['plain_text'] : 'データなし',
      category: properties['category']?['select']?['name'] ?? 'その他',
      categoryColor: properties['category']?['select']?['color'] ?? 'orange',
      price: (properties['price']?['number'] ?? 0).toDouble(),
      date: dateStr != null ? DateTime.parse(dateStr) : DateTime.now(),
    );
  }
}
