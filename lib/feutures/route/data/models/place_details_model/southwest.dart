import 'dart:ffi';

class Southwest {
  Double? lat;
  Double? lng;

  Southwest({this.lat, this.lng});

  factory Southwest.fromJson(Map<String, dynamic> json) => Southwest(
        lat: json['lat'] as Double?,
        lng: json['lng'] as Double?,
      );

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
      };
}
