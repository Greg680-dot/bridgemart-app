class FabricProduct {
  final String id;
  final String title;
  final String category;
  final String description;
  final double priceNgn;
  final String unit; // 'Pièce de 6 yards (5.5m)', 'Pièce de 5 yards', 'Mètre'
  final int stock;
  final String vendorId;
  final String vendorName;
  final String vendorCity;
  final bool vendorVerified;
  final double vendorRating;
  final int vendorSalesCount;
  final String imageUrl;
  final List<String> additionalImages;
  final String pattern; // 'Floral', 'Géométrique', 'Classique', 'Traditionnel'
  final String origin; // 'Lagos Island, Balogun', 'Aba Textile Center', 'Kano'

  FabricProduct({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.priceNgn,
    required this.unit,
    required this.stock,
    required this.vendorId,
    required this.vendorName,
    required this.vendorCity,
    required this.vendorVerified,
    required this.vendorRating,
    required this.vendorSalesCount,
    required this.imageUrl,
    required this.additionalImages,
    required this.pattern,
    required this.origin,
  });

  // Calcul du prix en XOF selon un taux donné
  double getPriceXof(double ngnToXofRate) {
    return (priceNgn * ngnToXofRate).roundToDouble();
  }

  static List<FabricProduct> getDemoProducts() {
    return [
      FabricProduct(
        id: 'fab_01',
        title: 'Dentelle Suisse Voile Brodé Perlé — Or Impérial',
        category: 'Dentelle Suisse & Guipure',
        description: 'Dentelle suisse de haute qualité brodée avec pierreries et fils métalliques dorés. Idéale pour les mariages traditionnels, dots et grandes cérémonies au Bénin.',
        priceNgn: 85000,
        unit: 'Pièce de 5 yards (4.6m)',
        stock: 14,
        vendorId: 'ven_lagos_01',
        vendorName: 'Mama Folake Fabrics (Balogun)',
        vendorCity: 'Lagos Island, Nigeria',
        vendorVerified: true,
        vendorRating: 4.9,
        vendorSalesCount: 142,
        imageUrl: 'https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?w=800&auto=format&fit=crop&q=80',
        additionalImages: [
          'https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?w=800&auto=format&fit=crop&q=80',
          'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=800&auto=format&fit=crop&q=80',
        ],
        pattern: 'Floral & Pierres de Swarovski',
        origin: 'Lagos (Balogun Market)',
      ),
      FabricProduct(
        id: 'fab_02',
        title: 'Super Ankara Wax Prestige 100% Coton — Motif Rosace',
        category: 'Pagne Wax & Ankara',
        description: 'Pagne Ankara nigérian véritable 100% coton peigné double face. Teinture grand teint résistant aux lavages fréquents.',
        priceNgn: 32000,
        unit: 'Pièce de 6 yards (5.5m)',
        stock: 45,
        vendorId: 'ven_aba_02',
        vendorName: 'Chinedu Textiles Hub',
        vendorCity: 'Aba Market, Nigeria',
        vendorVerified: true,
        vendorRating: 4.8,
        vendorSalesCount: 310,
        imageUrl: 'https://images.unsplash.com/photo-1528459801416-a9e53bbf4e17?w=800&auto=format&fit=crop&q=80',
        additionalImages: [
          'https://images.unsplash.com/photo-1528459801416-a9e53bbf4e17?w=800&auto=format&fit=crop&q=80',
        ],
        pattern: 'Rosace Traditionnelle Africaine',
        origin: 'Aba Textile Complex',
      ),
      FabricProduct(
        id: 'fab_03',
        title: 'Aso Oke Tissé Main — Ensemble Cérémonie Vert Émeraude',
        category: 'Tissus de Cérémonie (Aso Oke)',
        description: 'Tissu royal Aso Oke traditionnel tissé main par les maîtres artisans Yoruba. Ensemble complet comprenant Gélé, Ipele et métrage pour Agbada ou robe.',
        priceNgn: 120000,
        unit: 'Ensemble complet Cérémonie',
        stock: 6,
        vendorId: 'ven_ibadan_03',
        vendorName: 'Alhaja Kudirat Royal Attires',
        vendorCity: 'Ibadan / Lagos, Nigeria',
        vendorVerified: true,
        vendorRating: 5.0,
        vendorSalesCount: 88,
        imageUrl: 'https://images.unsplash.com/photo-1579783902614-a3fb3927b675?w=800&auto=format&fit=crop&q=80',
        additionalImages: [
          'https://images.unsplash.com/photo-1579783902614-a3fb3927b675?w=800&auto=format&fit=crop&q=80',
        ],
        pattern: 'Tissage Lin & Fils Dorés',
        origin: 'Iseyin / Lagos',
      ),
      FabricProduct(
        id: 'fab_04',
        title: 'Dentelle Guipure Cordonnetée Bleu Nuit & Argent',
        category: 'Dentelle Suisse & Guipure',
        description: 'Dentelle française guipure avec cordonnet en relief et finitions festonnées. Tissu épais très apprécié par les couturiers de Cotonou.',
        priceNgn: 95000,
        unit: 'Pièce de 5 yards (4.6m)',
        stock: 19,
        vendorId: 'ven_lagos_01',
        vendorName: 'Mama Folake Fabrics (Balogun)',
        vendorCity: 'Lagos Island, Nigeria',
        vendorVerified: true,
        vendorRating: 4.9,
        vendorSalesCount: 142,
        imageUrl: 'https://images.unsplash.com/photo-1549465220-1a8b9238cd48?w=800&auto=format&fit=crop&q=80',
        additionalImages: [
          'https://images.unsplash.com/photo-1549465220-1a8b9238cd48?w=800&auto=format&fit=crop&q=80',
        ],
        pattern: 'Guipure Cordonnet Découpée',
        origin: 'Lagos Island',
      ),
      FabricProduct(
        id: 'fab_05',
        title: 'Super-Wax Hollandais Vlisco Original — Les Hirondelles',
        category: 'Super-Wax & Brodé',
        description: 'Véritable Super-Wax hollandais avec ses deux étoiles distinctives. Motif iconique de réussite et d\'élégance.',
        priceNgn: 140000,
        unit: 'Pièce de 6 yards (5.5m)',
        stock: 11,
        vendorId: 'ven_marina_04',
        vendorName: 'Dele Exclusive Luxury',
        vendorCity: 'Marina, Lagos, Nigeria',
        vendorVerified: true,
        vendorRating: 4.95,
        vendorSalesCount: 220,
        imageUrl: 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=800&auto=format&fit=crop&q=80',
        additionalImages: [
          'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=800&auto=format&fit=crop&q=80',
        ],
        pattern: 'Hirondelles & Feuilles',
        origin: 'Lagos Marina Import',
      ),
      FabricProduct(
        id: 'fab_06',
        title: 'Bazin Riche Brodé Teint à la Main — Violet Royal & Jaune',
        category: 'Bazin Riche & Guinée',
        description: 'Bazin 100% coton de qualité supérieure, batteur traditionnel au bois pour une brillance éclatante et senteur typique.',
        priceNgn: 75000,
        unit: 'Coupon de 5 mètres',
        stock: 22,
        vendorId: 'ven_kano_05',
        vendorName: 'Hausa & Yoruba Fabrics Trading',
        vendorCity: 'Kano / Lagos, Nigeria',
        vendorVerified: true,
        vendorRating: 4.7,
        vendorSalesCount: 95,
        imageUrl: 'https://images.unsplash.com/photo-1520006403909-838d6b92c22e?w=800&auto=format&fit=crop&q=80',
        additionalImages: [
          'https://images.unsplash.com/photo-1520006403909-838d6b92c22e?w=800&auto=format&fit=crop&q=80',
        ],
        pattern: 'Teinture Artisanale & Pliage',
        origin: 'Kano Dyes / Lagos Outlet',
      ),
    ];
  }
}

class CartItem {
  final FabricProduct product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double getTotalPriceNgn() => product.priceNgn * quantity;
  double getTotalPriceXof(double rate) => product.getPriceXof(rate) * quantity;
}
