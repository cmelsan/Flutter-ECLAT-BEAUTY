/// Helper para obtener las imágenes de las categorías
/// sin necesidad de modificar la base de datos
class CategoryImages {
  // Mapeo de slug de categoría a URL de imagen en Cloudinary
  static const Map<String, String> _imageUrls = {
    'maquillaje': 'https://res.cloudinary.com/dmu6ttz2o/image/upload/v1770488171/eclat-beauty/collection-maquillaje.webp',
    'cabello': 'https://res.cloudinary.com/dmu6ttz2o/image/upload/v1770488172/eclat-beauty/collection-cabello.jpg',
    'cuerpo': 'https://res.cloudinary.com/dmu6ttz2o/image/upload/v1770488172/eclat-beauty/collection-cuerpo.jpg',
    'perfumes': 'https://res.cloudinary.com/dmu6ttz2o/image/upload/v1770488174/eclat-beauty/collection-perfumes.jpg',
  };

  /// Obtiene la URL de la imagen para una categoría según su slug
  /// Retorna null si no hay imagen para ese slug
  static String? getImageUrl(String slug) {
    return _imageUrls[slug.toLowerCase()];
  }

  /// Verifica si una categoría tiene imagen asignada
  static bool hasImage(String slug) {
    return _imageUrls.containsKey(slug.toLowerCase());
  }
}
