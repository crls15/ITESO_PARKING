part of 'photo_bloc.dart';

abstract class PhotoEvent extends Equatable {
  const PhotoEvent();

  @override
  List<Object> get props => [];
}

class OnTakePhotoEvent extends PhotoEvent {}

// class OnPhotoUploadEvent extends PhotoEvent {}

class OnNewFormWithPhotoEvent extends PhotoEvent {}
