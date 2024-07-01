
import 'package:flutter/material.dart';
import 'package:google_map_app/feutures/route/data/models/places_auto_complete_model/places_auto_complete_model.dart';

class SearchListView extends StatelessWidget {
  const SearchListView({
    super.key,
    required this.places,
  });

  final List<PlacesAutoCompleteModel> places;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: places.length,
      separatorBuilder: (context, index) {
        return const Divider();
      },
      itemBuilder: (context, index) {
        return Text(places[index].description!);
      },
    );
  }
}
