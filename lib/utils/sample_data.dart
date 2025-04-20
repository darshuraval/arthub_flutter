import 'package:arthub_flutter/models/user_model.dart';
import 'package:arthub_flutter/models/product_model.dart';
import 'package:arthub_flutter/models/order_model.dart';

class SampleData {
  // Sample Users
  static final List<UserModel> users = [
    UserModel(
      id: 'user1',
      name: 'Darshan Raval',
      email: 'darshan.raval@example.com',
      profileImage: 'https://example.com/profile1.jpg',
      bio: 'Professional artist specializing in watercolor paintings',
      role: UserRole.both,
      phoneNumber: '+1234567890',
      address: '123 Artist Lane, Creative City, AC 12345',
      joinedDate: DateTime(2023, 1, 15),
      isVerified: true,
      studioName: 'Raval Art Studio',
      artistBio: 'Award-winning watercolor artist with 10+ years of experience',
      specializations: ['Watercolor', 'Landscape', 'Portrait'],
      isVerifiedSeller: true,
      rating: 4.8,
      totalSales: 156,
    ),
    UserModel(
      id: 'user2',
      name: 'Sarah Johnson',
      email: 'sarah.j@example.com',
      profileImage: 'https://example.com/profile2.jpg',
      bio: 'Art enthusiast and collector',
      role: UserRole.buyer,
      joinedDate: DateTime(2023, 3, 20),
      isVerified: true,
    ),
    UserModel(
      id: 'user3',
      name: 'Michael Chen',
      email: 'michael.chen@example.com',
      profileImage: 'https://example.com/profile3.jpg',
      bio: 'Contemporary artist focusing on digital and traditional media',
      role: UserRole.seller,
      phoneNumber: '+1987654321',
      address: '456 Gallery Road, Art District, AD 67890',
      joinedDate: DateTime(2023, 2, 1),
      isVerified: true,
      studioName: 'Chen Art Gallery',
      artistBio: 'Blending traditional techniques with modern digital art',
      specializations: ['Digital Art', 'Mixed Media', 'Contemporary'],
      isVerifiedSeller: true,
      rating: 4.9,
      totalSales: 89,
    ),
  ];

  // Sample Categories
  static final List<Map<String, String>> categories = [
    {
      'title': 'Culture',
      'image': 'https://example.com/culture.jpg',
    },
    {
      'title': 'Mughal',
      'image': 'https://example.com/mughal.jpg',
    },
    {
      'title': 'Still Life',
      'image': 'https://example.com/still_life.jpg',
    },
    {
      'title': 'Wildlife',
      'image': 'https://example.com/wildlife.jpg',
    },
    {
      'title': 'Persian',
      'image': 'https://example.com/persian.jpg',
    },
    {
      'title': 'Landscape',
      'image': 'https://example.com/landscape.jpg',
    },
    {
      'title': 'Folk',
      'image': 'https://example.com/folk.jpg',
    },
    {
      'title': 'Hindu',
      'image': 'https://example.com/hindu.jpg',
    },
    {
      'title': 'Modern Art',
      'image': 'https://example.com/modern.jpg',
    },
    {
      'title': 'Abstract',
      'image': 'https://example.com/abstract.jpg',
    },
    {
      'title': 'Portrait',
      'image': 'https://example.com/portrait.jpg',
    },
    {
      'title': 'Religious',
      'image': 'https://example.com/religious.jpg',
    },
    {
      'title': 'Contemporary',
      'image': 'https://example.com/contemporary.jpg',
    },
    {
      'title': 'Traditional',
      'image': 'https://example.com/traditional.jpg',
    },
    {
      'title': 'Digital',
      'image': 'https://example.com/digital.jpg',
    },
  ];

  // Sample Products
  static final List<ProductModel> products = [
    ProductModel(
      id: 'prod1',
      title: 'Old Mans',
      description: 'In a sunlit corner of a cluttered attic, an old man sits with delicate brushes and a palette of memories. His trembling hands, weathered by time, dance gracefully over the canvas, bringing to life a tapestry of bygone days.',
      sellerId: 'user1',
      sellerName: 'Darshan Raval',
      images: [
        'https://example.com/old_mans1.jpg',
        'https://example.com/old_mans2.jpg',
      ],
      originalPrice: 50,
      discountedPrice: 25,
      category: 'Portrait',
      tags: ['Watercolor', 'Portrait', 'Traditional'],
      createdAt: DateTime(2024, 1, 15),
      details: {
        'Price Type': 'Fixed',
        'Category': 'Water Color',
        'Artist': 'Darshan Raval',
        'Extra': 'Black Wood Frame',
      },
      additionalDetails: {
        'Delivery Details': 'Home Delivery Available, Advance Deposit 30%',
      },
      dimensions: {
        'width': 24,
        'height': 36,
        'unit': 'inches',
      },
      medium: 'Watercolor',
      yearCreated: 2024,
      isOriginal: true,
      hasFrame: true,
      frameDetails: 'Black Wood Frame with UV Protection Glass',
      hasCertificate: true,
      certificateDetails: 'Certificate of Authenticity signed by the artist',
      shippingCountries: ['USA', 'Canada', 'UK', 'Australia'],
      shippingFees: {
        'USA': 15.0,
        'Canada': 20.0,
        'UK': 25.0,
        'Australia': 30.0,
      },
    ),
    ProductModel(
      id: 'prod2',
      title: 'Mystic Garden',
      description: 'A vibrant explosion of colors brings to life an enchanted garden where reality meets fantasy. Each brushstroke reveals hidden creatures and magical flora, creating a mesmerizing journey through the artist\'s imagination.',
      sellerId: 'user3',
      sellerName: 'Michael Chen',
      images: [
        'https://example.com/mystic_garden1.jpg',
        'https://example.com/mystic_garden2.jpg',
        'https://example.com/mystic_garden3.jpg',
      ],
      originalPrice: 75,
      discountedPrice: 60,
      category: 'Contemporary',
      tags: ['Digital', 'Fantasy', 'Contemporary'],
      createdAt: DateTime(2024, 2, 1),
      details: {
        'Price Type': 'Fixed',
        'Category': 'Digital Art',
        'Artist': 'Michael Chen',
        'Extra': 'Limited Edition Print',
      },
      additionalDetails: {
        'Delivery Details': 'Worldwide Shipping Available',
        'Print Details': 'Archival Quality, Numbered Edition',
      },
      dimensions: {
        'width': 30,
        'height': 40,
        'unit': 'inches',
      },
      medium: 'Digital Print',
      yearCreated: 2024,
      isOriginal: false,
      editionNumber: 5,
      totalEditions: 25,
      hasFrame: false,
      hasCertificate: true,
      certificateDetails: 'Includes numbered certificate of authenticity',
      isCustomizable: true,
      customizationOptions: [
        {
          'type': 'size',
          'options': ['20x30', '30x40', '40x60'],
        },
        {
          'type': 'frame',
          'options': ['None', 'Black', 'White', 'Gold'],
        },
      ],
    ),
    ProductModel(
      id: 'prod2',
      title: 'Mystic Garden',
      description: 'A vibrant explosion of colors brings to life an enchanted garden where reality meets fantasy. Each brushstroke reveals hidden creatures and magical flora, creating a mesmerizing journey through the artist\'s imagination.',
      sellerId: 'user3',
      sellerName: 'Michael Chen',
      images: [
        'https://example.com/mystic_garden1.jpg',
        'https://example.com/mystic_garden2.jpg',
        'https://example.com/mystic_garden3.jpg',
      ],
      originalPrice: 75,
      discountedPrice: 60,
      category: 'Contemporary',
      tags: ['Digital', 'Fantasy', 'Contemporary'],
      createdAt: DateTime(2024, 2, 1),
      details: {
        'Price Type': 'Fixed',
        'Category': 'Digital Art',
        'Artist': 'Michael Chen',
        'Extra': 'Limited Edition Print',
      },
      additionalDetails: {
        'Delivery Details': 'Worldwide Shipping Available',
        'Print Details': 'Archival Quality, Numbered Edition',
      },
      dimensions: {
        'width': 30,
        'height': 40,
        'unit': 'inches',
      },
      medium: 'Digital Print',
      yearCreated: 2024,
      isOriginal: false,
      editionNumber: 5,
      totalEditions: 25,
      hasFrame: false,
      hasCertificate: true,
      certificateDetails: 'Includes numbered certificate of authenticity',
      isCustomizable: true,
      customizationOptions: [
        {
          'type': 'size',
          'options': ['20x30', '30x40', '40x60'],
        },
        {
          'type': 'frame',
          'options': ['None', 'Black', 'White', 'Gold'],
        },
      ],
    ),
    ProductModel(
      id: 'prod3',
      title: 'Cultural Heritage',
      description: 'A masterful blend of traditional motifs and contemporary expression, this piece celebrates our rich cultural heritage. The intricate patterns and warm earth tones tell stories passed down through generations.',
      sellerId: 'user1',
      sellerName: 'Darshan Raval',
      images: [
        'https://example.com/heritage1.jpg',
        'https://example.com/heritage2.jpg',
      ],
      originalPrice: 120,
      category: 'Culture',
      tags: ['Traditional', 'Cultural', 'Folk'],
      createdAt: DateTime(2024, 1, 20),
      details: {
        'Price Type': 'Fixed',
        'Category': 'Mixed Media',
        'Artist': 'Darshan Raval',
        'Extra': 'Museum Quality Frame',
      },
      additionalDetails: {
        'Delivery Details': 'White Glove Delivery Service',
        'Care Instructions': 'Keep away from direct sunlight',
      },
      dimensions: {
        'width': 48,
        'height': 36,
        'unit': 'inches',
      },
      medium: 'Mixed Media',
      yearCreated: 2024,
      isOriginal: true,
      hasFrame: true,
      frameDetails: 'Handcrafted wooden frame with gold leaf details',
      hasCertificate: true,
      certificateDetails: 'Full documentation of authenticity and provenance',
    ),
    ProductModel(
      id: 'prod4',
      title: 'Urban Rhythms',
      description: 'A dynamic exploration of city life through abstract forms and bold colors. The piece captures the energy and movement of urban landscapes, creating a visual symphony of modern life.',
      sellerId: 'user3',
      sellerName: 'Michael Chen',
      images: [
        'https://example.com/urban1.jpg',
        'https://example.com/urban2.jpg',
        'https://example.com/urban3.jpg',
      ],
      originalPrice: 90,
      discountedPrice: 72,
      category: 'Abstract',
      tags: ['Abstract', 'Modern', 'Urban'],
      createdAt: DateTime(2024, 2, 10),
      details: {
        'Price Type': 'Fixed',
        'Category': 'Acrylic',
        'Artist': 'Michael Chen',
        'Extra': 'Floating Frame',
      },
      additionalDetails: {
        'Delivery Details': 'Free shipping within US',
        'Installation': 'Installation service available',
      },
      dimensions: {
        'width': 40,
        'height': 30,
        'unit': 'inches',
      },
      medium: 'Acrylic on Canvas',
      yearCreated: 2024,
      isOriginal: true,
      hasFrame: true,
      frameDetails: 'Modern floating frame in matte black',
      hasCertificate: true,
      certificateDetails: 'Includes certificate of authenticity',
      isCustomizable: true,
      customizationOptions: [
        {
          'type': 'color scheme',
          'options': ['Cool', 'Warm', 'Neutral'],
        },
      ],
    ),
  ];

  // Sample Orders
  static final List<OrderModel> orders = [
    OrderModel(
      id: 'order1',
      buyerId: 'user2',
      sellerId: 'user1',
      productId: 'prod1',
      productTitle: 'Old Mans',
      productImage: 'https://example.com/old_mans1.jpg',
      amount: 25.0,
      status: OrderStatus.delivered,
      orderDate: DateTime(2024, 2, 1),
      payment: PaymentModel(
        id: 'pay1',
        orderId: 'order1',
        userId: 'user2',
        amount: 25.0,
        status: PaymentStatus.completed,
        paymentMethod: 'Credit Card',
        timestamp: DateTime(2024, 2, 1),
        transactionId: 'tx_123456',
        paymentDetails: {
          'cardType': 'Visa',
          'last4': '4242',
        },
      ),
      shippingAddress: {
        'name': 'Sarah Johnson',
        'street': '789 Art Collector Ave',
        'city': 'Creative City',
        'state': 'AC',
        'zipCode': '12345',
        'country': 'USA',
      },
      trackingNumber: 'TRK123456789',
      estimatedDeliveryDate: DateTime(2024, 2, 7),
      deliveredDate: DateTime(2024, 2, 6),
      shippingFee: 15.0,
      taxAmount: 2.5,
    ),
    // Add more sample orders...
  ];

  // Helper methods
  static String getRandomArtImage() {
    const images = [
      'https://example.com/art1.jpg',
      'https://example.com/art2.jpg',
      'https://example.com/art3.jpg',
      'https://example.com/art4.jpg',
      'https://example.com/art5.jpg',
    ];
    return images[DateTime.now().millisecond % images.length];
  }

  static String getRandomCategoryImage() {
    const images = [
      'https://example.com/category1.jpg',
      'https://example.com/category2.jpg',
      'https://example.com/category3.jpg',
      'https://example.com/category4.jpg',
      'https://example.com/category5.jpg',
    ];
    return images[DateTime.now().millisecond % images.length];
  }

  static String getRandomUserAvatar() {
    const avatars = [
      'https://example.com/avatar1.jpg',
      'https://example.com/avatar2.jpg',
      'https://example.com/avatar3.jpg',
      'https://example.com/avatar4.jpg',
      'https://example.com/avatar5.jpg',
    ];
    return avatars[DateTime.now().millisecond % avatars.length];
  }
} 