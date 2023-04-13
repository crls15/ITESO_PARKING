part of 'photo_bloc.dart';

abstract class PhotoState extends Equatable {
  const PhotoState();

  @override
  List<Object> get props => [];
}

class PhotoInitial extends PhotoState {}

class InitPhotoState extends PhotoState {}

class TakePhotoSuccessState extends PhotoState {}

class TakePhotoErrorState extends PhotoState {}

class TakePhotoLoadingState extends PhotoState {}

// class PhotoUploadSuccessState extends PhotoState {}

// class PhotoUploadErrorState extends PhotoState {}

// class PhotoUploadLoadingState extends PhotoState {}

// class PhotoUploadChangeState extends PhotoState {
//   final File picture;

//   PhotoUploadChangeState({required this.picture});
//   @override
//   List<Object> get props => [picture];
// }
