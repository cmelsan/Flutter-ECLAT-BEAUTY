import 'dart:convert';
import 'dart:typed_data';
import 'package:dartz/dartz.dart' hide Order;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../../core/errors/failures.dart';

/// Service for uploading images to Cloudinary
class CloudinaryService {
  static const String _cloudName = 'eclat-beauty';
  static const String _uploadPreset = 'eclat_unsigned';
  static const String _apiUrl =
      'https://api.cloudinary.com/v1_1/$_cloudName/image/upload';

  final ImagePicker _picker = ImagePicker();

  /// Pick image from gallery and upload to Cloudinary
  Future<Either<Failure, String>> pickAndUploadImage({
    String folder = 'products',
  }) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (pickedFile == null) {
        return const Left(CancellationFailure('Selección cancelada'));
      }

      return uploadImage(
        imageBytes: await pickedFile.readAsBytes(),
        fileName: pickedFile.name,
        folder: folder,
      );
    } catch (e) {
      return Left(ServerFailure('Error al seleccionar imagen: $e'));
    }
  }

  /// Upload raw bytes to Cloudinary
  Future<Either<Failure, String>> uploadImage({
    required Uint8List imageBytes,
    required String fileName,
    String folder = 'products',
  }) async {
    try {
      final uri = Uri.parse(_apiUrl);
      final request = http.MultipartRequest('POST', uri)
        ..fields['upload_preset'] = _uploadPreset
        ..fields['folder'] = folder
        ..files.add(http.MultipartFile.fromBytes(
          'file',
          imageBytes,
          filename: fileName,
        ));

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode != 200) {
        return Left(ServerFailure(
          'Error al subir imagen (${response.statusCode})',
        ));
      }

      final jsonData = json.decode(responseBody);
      final secureUrl = jsonData['secure_url'] as String;
      return Right(secureUrl);
    } catch (e) {
      return Left(ServerFailure('Error al subir imagen: $e'));
    }
  }
}

/// Cancellation failure (user cancelled an action)
class CancellationFailure extends Failure {
  const CancellationFailure(super.message);
}
