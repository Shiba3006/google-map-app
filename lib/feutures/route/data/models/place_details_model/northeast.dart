class Northeast {
  int? lat;
  int? lng;

  Northeast({this.lat, this.lng});

  factory Northeast.fromJson(Map<String, dynamic> json) => Northeast(
        lat: json['lat'] as int?,
        lng: json['lng'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
      };
}
