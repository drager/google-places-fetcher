part of google_places_fetcher;

final googleBaseUrl = 'https://maps.googleapis.com/maps/api/place';
final type = 'cafe';

Future getPlacesIn(num latitude, num longitude, int radius) async {
  var places = [];

  var response = await http.get(
      '$googleBaseUrl/radarsearch/json?location=$latitude,$longitude&radius=$radius&types=$type&key=$googleApiKey');
  print(
      '$googleBaseUrl/radarsearch/json?location=$latitude,$longitude&radius=$radius&types=$type&key=$googleApiKey');

  response = JSON.decode(response.body);

  response['results'].forEach((place) {
    places.add(new Position()
      ..latitude = place['geometry']['location']['lat']
      ..longitude = place['geometry']['location']['lng']
      ..created_at = new DateTime.now()
      ..updated_at = new DateTime.now()
    );
  });
  print(places);
}
