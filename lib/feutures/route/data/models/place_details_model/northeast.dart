class Northeast {
  double? lat;
  double? lng;

  Northeast({this.lat, this.lng});

  factory Northeast.fromJson(Map<String, dynamic> json) => Northeast(
        lat: json['lat'] as double?,
        lng: json['lng'] as double?,
      );

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
      };
}
