import 'dart:async';
import 'package:google_places_fetcher/google_places_fetcher.dart';

main(List<String> arguments) async {
  var citiesWithCoordinates = await getCoordinatesFromCityNames(cities);
  Future.forEach(citiesWithCoordinates, (city) async {
    var places = await getPlacesIn(city.latitude, city.longitude, 9000);
    storeInDatabase(places);
  });
}
