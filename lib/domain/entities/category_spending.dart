class CategorySpendingEntity {
  final int categoryId;
  final String categoryName;
  final int totalAmount;
  final double percentage;

  CategorySpendingEntity({
    required this.categoryId,
    required this.categoryName,
    required this.totalAmount,
    required this.percentage,
  });
}
