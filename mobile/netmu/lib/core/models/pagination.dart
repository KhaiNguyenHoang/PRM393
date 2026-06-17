class PaginationMetadata {
  final bool hasNextPage;
  final bool hasPreviousPage;
  final int totalItemCount;
  final int pageCount;
  final int currentPage;
  final int pageSize;

  const PaginationMetadata({
    required this.hasNextPage,
    required this.hasPreviousPage,
    required this.currentPage,
    required this.pageCount,
    required this.pageSize,
    required this.totalItemCount,
  });

  factory PaginationMetadata.fromJson(Map<String, dynamic> json) {
    return PaginationMetadata(
      hasNextPage: json["hasNextPage"],
      hasPreviousPage: json["hasPreviousPage"],
      currentPage: json["currentPage"],
      pageCount: json["pageCount"],
      pageSize: json["pageSize"],
      totalItemCount: json["totalItemCount"],
    );
  }
}

class Pagination<T> {
  final PaginationMetadata metadata;
  final List<T> items;

  const Pagination({required this.metadata, required this.items});
}
