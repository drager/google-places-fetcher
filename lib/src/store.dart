part of google_places_fetcher;

Future storeInDatabase(places) async {
  var connection = await connect(postgresUri);

  await Future.forEach(places, (place) async {
    await connection.execute(
        "insert into positioningservice_coffee (name, created_at, updated_at, "
        "address, description, image, formattedPhoneNumber, "
        "internationalPhoneNumber, website, priceLevel, latitude, longitude) "
        "values (@name, @created_at, @updated_at, @address, @description, "
        "@image, @formattedphonenumber, @internationalphoneNumber, @website, "
        "@pricelevel, @latitude, @longitude);", {
      'name': place.name,
      'created_at': place.created_at,
      'updated_at': place.updated_at,
      'address': place.address,
      'description': place.description,
      'image': place.image != null ? place.image : '',
      'latitude': place.latitude,
      'longitude': place.longitude,
      'formattedphonenumber': place.formattedPhoneNumber,
      'internationalphoneNumber': place.internationalPhoneNumber,
      'website': place.website,
      'pricelevel': place.priceLevel,
    });
  });
  connection.close();
}
