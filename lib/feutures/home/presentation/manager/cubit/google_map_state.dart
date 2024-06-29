part of 'google_map_cubit.dart';

@immutable
sealed class GoogleMapState {}

final class GoogleMapInitial extends GoogleMapState {}

final class InitCameraPositionLoadingState extends GoogleMapState {}

final class InitCameraPositionSuccessState extends GoogleMapState {}

final class InitCameraPositionFailureState extends GoogleMapState {}

final class InitMapStyleLoadingState extends GoogleMapState {}

final class InitMapStyleSuccessState extends GoogleMapState {}

final class InitMapStyleFailureState extends GoogleMapState {}

final class InitGoogleMapLoadingState extends GoogleMapState {}

final class InitGoogleMapSuccessState extends GoogleMapState {}

final class InitGoogleMapFailureState extends GoogleMapState {}