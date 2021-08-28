class PlaceSearch {
  final String description;
  final String placeId;
  PlaceSearch({required this.description, required this.placeId});
  factory PlaceSearch.fromJson(Map<String, dynamic> json) {
    return PlaceSearch(
        description: json['discription'], placeId: json['place_Id']);
  }
}
