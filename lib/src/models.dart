part of google_places_fetcher;

class CoffeePlace {
  String name;
  String address;
  String description;
  String image;
  String formattedPhoneNumber;
  String internationalPhoneNumber;
  String website;
  double latitude;
  double longitude;
  /*
   * 0 — Free
   * 1 — Inexpensive
   * 2 — Moderate
   * 3 — Expensive
   * 4 — Very Expensive
   */
  num priceLevel;
  DateTime created_at;
  DateTime updated_at;
  List openingHours;

  toString() {
    return '$name, $address, $description, $formattedPhoneNumber,'
    '$internationalPhoneNumber, $website, $latitude, $longitude, $created_at,'
    '$updated_at, $openingHours';
  }
}

class City {
  String name;
  double latitude;
  double longitude;
}
