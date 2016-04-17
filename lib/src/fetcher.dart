part of google_places_fetcher;

final googleBaseUrl = 'https://maps.googleapis.com/maps/api';
final type = 'cafe';

Future getPlacesIn(num latitude, num longitude, int radius) async {
  var places = [];
  var image;
  var formattedPhoneNumber;
  var internationalPhoneNumber;
  var website;
  var priceLevel;

  var response = await http.get(
      '$googleBaseUrl/place/nearbysearch/json?location=$latitude,$longitude&radius=$radius&types=$type&key=$googleApiKey');

  response = JSON.decode(response.body);

  print('$googleBaseUrl/place/nearbysearch/json?location=$latitude,$longitude&radius=$radius&types=$type&key=$googleApiKey');

  await Future.forEach(response['results'], (place) async {
    if (place.containsKey('photos')) {
      await Future.forEach(place['photos'], (photo) async {
        image = await getPhotoByPhotoId(photo['photo_reference']);
      });
    }

    var details = await getPlaceDetails(place['reference']);
    formattedPhoneNumber = details['formatted_phone_number'];
    internationalPhoneNumber = details['international_phone_number'];
    priceLevel = details['price_level'];
    website = details['website'];

    places.add(new CoffeePlace()
      ..name = place['name']
      ..address = place['vicinity']
      ..description = 'test'
      ..image = image
      ..formattedPhoneNumber = formattedPhoneNumber
      ..internationalPhoneNumber = internationalPhoneNumber
      ..website = website
      ..latitude = place['geometry']['location']['lat']
      ..longitude = place['geometry']['location']['lng']
      ..priceLevel = priceLevel
      ..created_at = new DateTime.now()
      ..updated_at = new DateTime.now());
  });

  return places;
}

Future getCoordinatesFromCityNames(List<String> cities) async {
  var citiesWithCoordinates = [];

  await Future.forEach(cities, (city) async {
    var response = await http
        .get('$googleBaseUrl/geocode/json?address=$city&key=$googleApiKey');

    response = JSON.decode(response.body);

    var result = response['results'].first;

    citiesWithCoordinates.add(new City()
      ..name = result['formatted_address']
      ..latitude = result['geometry']['location']['lat']
      ..longitude = result['geometry']['location']['lng']);
  });

  return citiesWithCoordinates;
}

Future getPhotoByPhotoId(String photoId, [int maxWidth = 400]) async {
  var response = await http.get(
      '$googleBaseUrl/place/photo?maxwidth=$maxWidth&photoreference=$photoId&key=$googleApiKey');

  List<int> bytes = response.bodyBytes;
  String base64 = CryptoUtils.bytesToBase64(bytes);

  return new StringBuffer('data:image/png;base64,' + base64).toString();
}

Future getPlaceDetails(String referenceId) async {
  var response = await http.get(
      '$googleBaseUrl/place/details/json?reference=$referenceId&key=$googleApiKey');

  response = JSON.decode(response.body);

  return response['result'];
}
