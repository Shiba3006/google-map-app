import 'package:flutter/material.dart';
import 'package:google_map_app/feutures/route/feuters/views/widgets/route_view_body.dart';

class RouteView extends StatefulWidget {
  const RouteView({super.key});

  @override
  State<RouteView> createState() => _RouteViewState();
}

class _RouteViewState extends State<RouteView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      
      resizeToAvoidBottomInset: false,
      body: RouteViewBody(),
    );
  }
}
