part of google_places_fetcher;

final googleBaseUrl = 'https://maps.googleapis.com/maps/api';
final type = 'cafe';

Future getPlacesIn(num latitude, num longitude, int radius) async {
  var places = [];
  var image;

  var connection = await connect(postgresUri);

  var response = await http.get(
      '$googleBaseUrl/place/nearbysearch/json?location=$latitude,$longitude&radius=$radius&types=$type&key=$googleApiKey');

  response = JSON.decode(response.body);

  print(response);

  await Future.forEach(response['results'], (place) async {
    if (place.containsKey('photos')) {
      await Future.forEach(place['photos'], (photo) async {
        image = await getPhotoByPhotoId(photo['photo_reference']);
      });
    }
    places.add(new CoffeePlace()
      ..name = place['name']
      ..address = place['vicinity']
      ..description = 'test'
      ..image = image
      ..latitude = place['geometry']['location']['lat']
      ..longitude = place['geometry']['location']['lng']
      ..created_at = new DateTime.now()
      ..updated_at = new DateTime.now());
  });

  await Future.forEach(places, (place) async {
    await connection.execute(
        "insert into positioningservice_coffee (name, created_at, updated_at, "
        "address, description, image, latitude, longitude) values (@name, @created_at, @updated_at, "
        "@address, @description, @image, @latitude, @longitude);", {
      'name': place.name,
      'created_at': place.created_at,
      'updated_at': place.updated_at,
      'address': place.address,
      'description': place.description,
      'image': place.image != null ? place.image : '',
      'latitude': place.latitude,
      'longitude': place.longitude,
    });
  });
  connection.close();
}

Future getCoordinatesFromCityNames(List<String> cities) async {
  var citiesWithCoordinates = [];

  await Future.forEach(cities, (city) async {
    var response = await http
        .get('$googleBaseUrl/geocode/json?address=$city&key=$googleApiKey');

    response = JSON.decode(response.body);

    print(response);

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

  return new StringBuffer('data:image/png;base64,$base64').toString();
}
