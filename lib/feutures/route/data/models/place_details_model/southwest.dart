class Southwest {
  int? lat;
  int? lng;

  Southwest({this.lat, this.lng});

  factory Southwest.fromJson(Map<String, dynamic> json) => Southwest(
        lat: json['lat'] as int?,
        lng: json['lng'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
      };
}
