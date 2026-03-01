import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/errors/failures.dart';

class SupabaseStorageService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final ImagePicker _picker = ImagePicker();
  final _uuid = const Uuid();

  Future<Either<Failure, String>> pickAndUploadImage({
    required ImageSource source,
    String folder = 'products',
  }) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
      );

      if (pickedFile == null) {
        return const Left(CancellationFailure('Selección cancelada'));
      }

      final bytes = await pickedFile.readAsBytes();
      
      // Compress image
      final compressedBytes = await FlutterImageCompress.compressWithList(
        bytes,
        minWidth: 1200,
        minHeight: 1200,
        quality: 85,
      );

      return uploadImage(
        imageBytes: compressedBytes,
        fileName: '${_uuid.v4()}.jpg',
        folder: folder,
      );
    } catch (e) {
      return Left(ServerFailure('Error al procesar imagen: $e'));
    }
  }

  Future<Either<Failure, String>> uploadImage({
    required Uint8List imageBytes,
    required String fileName,
    String folder = 'products',
  }) async {
    try {
      final path = '$folder/$fileName';
      
      await _supabase.storage.from('images').uploadBinary(
        path,
        imageBytes,
        fileOptions: const FileOptions(
          contentType: 'image/jpeg',
          upsert: true,
        ),
      );

      final publicUrl = _supabase.storage.from('images').getPublicUrl(path);
      return Right(publicUrl);
    } catch (e) {
      return Left(ServerFailure('Error al subir imagen: $e'));
    }
  }
}

class CancellationFailure extends Failure {
  const CancellationFailure(super.message);
}
