import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

part 'photo_event.dart';
part 'photo_state.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  File? _selectedPhoto;
  String imageUrl = "";

  // String? get imageUrl => imageUrl;

  PhotoBloc() : super(PhotoInitial()) {
    on<OnTakePhotoEvent>(_takePhoto);
    // on<OnPhotoUploadEvent>(_saveData);
    on<OnNewFormWithPhotoEvent>(_initVariables);
  }

  Future<void> _takePhoto(OnTakePhotoEvent event, Emitter emit) async {
    emit(TakePhotoLoadingState());
    await _getImage();
    imageUrl = await _uploadPhotoStorage();
    emit(_selectedPhoto != null
        ? TakePhotoSuccessState()
        : TakePhotoErrorState());
  }

  Future<void> _getImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 720,
      maxWidth: 720,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      _selectedPhoto = File(pickedFile.path);
    } else {
      _selectedPhoto != null ? _selectedPhoto : null;
    }
  }

  // Future<void> _saveData(OnPhotoUploadEvent event, Emitter emit) async {
  //   emit(PhotoUploadLoadingState());
  //   imageUrl = await _uploadPhotoStorage();
  //   emit(imageUrl != "" ? PhotoUploadSuccessState() : PhotoUploadErrorState());
  // }

  Future<String> _uploadPhotoStorage() async {
    try {
      if (_selectedPhoto == null) return "";
      var _stamp = DateTime.now();
      UploadTask _task = FirebaseStorage.instance
          .ref("/iteso_parking/photo_${_stamp}.png")
          .putFile(_selectedPhoto!);
      await _task;
      return await _task.storage
          .ref("/iteso_parking/photo_${_stamp}.png")
          .getDownloadURL();
    } catch (e) {
      print("No se pudo subir la imagen");
      return "";
    }
  }

  Future<void> _initVariables(
      OnNewFormWithPhotoEvent event, Emitter emit) async {
    _selectedPhoto = null;
    imageUrl = "";

    emit(InitPhotoState());
  }
/*Future<bool> _uploadData(Map<String, dynamic> dataToSave) async {
    try {
      String imageUrl = await _uploadPhotoStorage();
      if (imageUrl != "") {
        dataToSave["imageUrl"] = imageUrl;
        dataToSave["publishedAt"] = Timestamp.fromDate(DateTime.now());
        dataToSave["type"] = 'Car';
        dataToSave["user"] = FirebaseAuth.instance.currentUser!.uid;
      } else {
        return false;
      }
      var docsRef =
          await FirebaseFirestore.instance.collection("photo").add(dataToSave);
      await _updateUserDocumentReference(docsRef.id);
      return true;
    } catch (e) {
      print("Error al crear photo");
      return false;
    }
  }

  Future<bool> _updateUserDocumentReference(String photoId) async {
    try {
      var user = FirebaseFirestore.instance
          .collection('user')
          .doc('${FirebaseAuth.instance.currentUser!.uid}');

      var docsRef = await user.get();
      List<dynamic> listdIds = docsRef.data()?["fotosListId"];
      listdIds.add(photoId);

      await user.update({
        "fotosListId": listdIds,
      });
      return true;
    } catch (e) {
      return false;
    }
  }*/
}
