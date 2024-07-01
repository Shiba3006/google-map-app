class Southwest {
  double? lat;
  double? lng;

  Southwest({this.lat, this.lng});

  factory Southwest.fromJson(Map<String, dynamic> json) => Southwest(
        lat: json['lat'] as double?,
        lng: json['lng'] as double?,
      );

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
      };
}
