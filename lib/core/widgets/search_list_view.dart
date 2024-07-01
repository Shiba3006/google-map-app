import 'package:flutter/material.dart';
import 'package:google_map_app/core/utils/google_maps_places_service.dart';
import 'package:google_map_app/feutures/route/data/models/places_model/places_auto_complete_model.dart';

class SearchListView extends StatelessWidget {
  const SearchListView({
    super.key,
    required this.places,
    required this.placesService,
  });

  final List<PlaceModel> places;
  final GoogleMapsPlacesService placesService;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(0.5),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: places.length,
        separatorBuilder: (context, index) {
          return const Divider(
            height: 0,
          );
        },
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              places[index].description!,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () async {
              var placeDetails = await placesService.getPlaceDetails(
                  placeId: places[index].placeId!);
              print('======================> $placeDetails');
            },
            leading: const Icon(Icons.location_on),
            trailing: const Icon(Icons.chevron_right),
          );
        },
      ),
    );
  }
}
