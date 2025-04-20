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
      'image': 'https://images.unsplash.com/photo-1547826039-bfc35e0f1ea8?w=500&auto=format&fit=crop&q=60',
    },
    {
      'title': 'Mughal',
      'image': 'https://images.unsplash.com/photo-1577083552431-6e5fd01988d8?w=500&auto=format&fit=crop&q=60',
    },
    {
      'title': 'Still Life',
      'image': 'https://images.unsplash.com/photo-1577083552431-6e5fd01988d8?w=500&auto=format&fit=crop&q=60',
    },
    {
      'title': 'Wildlife',
      'image': 'https://images.unsplash.com/photo-1577083552431-6e5fd01988d8?w=500&auto=format&fit=crop&q=60',
    },
    {
      'title': 'Persian',
      'image': 'https://images.unsplash.com/photo-1577083552431-6e5fd01988d8?w=500&auto=format&fit=crop&q=60',
    },
    {
      'title': 'Landscape',
      'image': 'https://images.unsplash.com/photo-1577083552431-6e5fd01988d8?w=500&auto=format&fit=crop&q=60',
    },
    {
      'title': 'Folk',
      'image': 'https://images.unsplash.com/photo-1577083552431-6e5fd01988d8?w=500&auto=format&fit=crop&q=60',
    },
    {
      'title': 'Hindu',
      'image': 'https://images.unsplash.com/photo-1577083552431-6e5fd01988d8?w=500&auto=format&fit=crop&q=60',
    },
    {
      'title': 'Modern Art',
      'image': 'https://images.unsplash.com/photo-1577083552431-6e5fd01988d8?w=500&auto=format&fit=crop&q=60',
    },
    {
      'title': 'Abstract',
      'image': 'https://images.unsplash.com/photo-1577083552431-6e5fd01988d8?w=500&auto=format&fit=crop&q=60',
    },
    {
      'title': 'Portrait',
      'image': 'https://images.unsplash.com/photo-1577083552431-6e5fd01988d8?w=500&auto=format&fit=crop&q=60',
    },
    {
      'title': 'Religious',
      'image': 'https://images.unsplash.com/photo-1577083552431-6e5fd01988d8?w=500&auto=format&fit=crop&q=60',
    },
    {
      'title': 'Contemporary',
      'image': 'https://images.unsplash.com/photo-1577083552431-6e5fd01988d8?w=500&auto=format&fit=crop&q=60',
    },
    {
      'title': 'Traditional',
      'image': 'https://images.unsplash.com/photo-1577083552431-6e5fd01988d8?w=500&auto=format&fit=crop&q=60',
    },
    {
      'title': 'Digital',
      'image': 'https://images.unsplash.com/photo-1577083552431-6e5fd01988d8?w=500&auto=format&fit=crop&q=60',
    },
  ];

  // Sample Products
  static final List<ProductModel> products = [
    ProductModel(
      id: 'prod1',
      title: 'Old Mans Portrait',
      description: 'A beautiful watercolor portrait of an old man.',
      sellerId: users[0].id,
      sellerName: users[0].name,
      images: [
        'https://images.unsplash.com/photo-1577083552431-6e5fd01988d8?w=500&auto=format&fit=crop&q=60',
        'https://images.unsplash.com/photo-1577083552431-6e5fd01988d8?w=500&auto=format&fit=crop&q=60',
      ],
      originalPrice: 100.0,
      discountedPrice: 50.0,
      category: 'Portrait',
      tags: ['Portrait', 'Watercolor', 'Traditional'],
      createdAt: DateTime.now(),
      dimensions: {
        'width': 16,
        'height': 20,
        'unit': 'inches',
      },
      medium: 'Watercolor',
      yearCreated: 2024,
      isOriginal: true,
      details: {
        'Price Type': 'Fixed',
        'Category': 'Water Color',
        'Artist': users[0].name,
        'Extra': 'Black Wood Frame',
      },
      additionalDetails: {
        'Delivery Details': 'Home Delivery Available, Advance Deposit 30%',
      },
    ),
    ProductModel(
      id: 'prod2',
      title: 'Modern Garden Dreams',
      description: 'A vibrant digital print of a modern garden.',
      sellerId: users[1].id,
      sellerName: users[1].name,
      images: [
        'https://images.unsplash.com/photo-1577083552431-6e5fd01988d8?w=500&auto=format&fit=crop&q=60',
        'https://images.unsplash.com/photo-1577083552431-6e5fd01988d8?w=500&auto=format&fit=crop&q=60',
      ],
      originalPrice: 100.0,
      discountedPrice: 75.0,
      category: 'Modern Art',
      tags: ['Modern', 'Digital', 'Garden'],
      createdAt: DateTime.now(),
      dimensions: {
        'width': 24,
        'height': 36,
        'unit': 'inches',
      },
      medium: 'Digital Print',
      yearCreated: 2024,
      isOriginal: false,
      details: {
        'Price Type': 'Fixed',
        'Category': 'Digital Art',
        'Artist': users[1].name,
        'Extra': 'Limited Edition Print',
      },
      additionalDetails: {
        'Delivery Details': 'Worldwide Shipping Available',
        'Print Details': 'Archival Quality, Numbered Edition',
      },
    ),
    ProductModel(
      id: 'prod3',
      title: 'Cultural Heritage',
      description: 'A mixed media piece celebrating cultural heritage.',
      sellerId: users[0].id,
      sellerName: users[0].name,
      images: [
        'https://images.unsplash.com/photo-1577083552431-6e5fd01988d8?w=500&auto=format&fit=crop&q=60',
        'https://images.unsplash.com/photo-1577083552431-6e5fd01988d8?w=500&auto=format&fit=crop&q=60',
      ],
      originalPrice: 150.0,
      discountedPrice: 120.0,
      category: 'Culture',
      tags: ['Culture', 'Mixed Media', 'Heritage'],
      createdAt: DateTime.now(),
      dimensions: {
        'width': 30,
        'height': 40,
        'unit': 'inches',
      },
      medium: 'Mixed Media',
      yearCreated: 2024,
      isOriginal: true,
      details: {
        'Price Type': 'Fixed',
        'Category': 'Mixed Media',
        'Artist': users[0].name,
        'Extra': 'Museum Quality Frame',
      },
      additionalDetails: {
        'Delivery Details': 'White Glove Delivery Service',
        'Care Instructions': 'Keep away from direct sunlight',
      },
    ),
    ProductModel(
      id: 'prod4',
      title: 'Urban Rhythms',
      description: 'An acrylic artwork capturing urban life.',
      sellerId: users[1].id,
      sellerName: users[1].name,
      images: [
        'https://images.unsplash.com/photo-1577083552431-6e5fd01988d8?w=500&auto=format&fit=crop&q=60',
        'https://images.unsplash.com/photo-1577083552431-6e5fd01988d8?w=500&auto=format&fit=crop&q=60',
      ],
      originalPrice: 120.0,
      discountedPrice: 90.0,
      category: 'Contemporary',
      tags: ['Urban', 'Acrylic', 'Contemporary'],
      createdAt: DateTime.now(),
      dimensions: {
        'width': 36,
        'height': 48,
        'unit': 'inches',
      },
      medium: 'Acrylic',
      yearCreated: 2024,
      isOriginal: true,
      details: {
        'Price Type': 'Fixed',
        'Category': 'Acrylic',
        'Artist': users[1].name,
        'Extra': 'Floating Frame',
      },
      additionalDetails: {
        'Delivery Details': 'Free shipping within US',
        'Installation': 'Installation service available',
      },
    ),
    ProductModel(
      id: 'prod5',
      title: 'Mughal Court Scene',
      description: 'A historical piece with gold leaf details.',
      sellerId: users[0].id,
      sellerName: users[0].name,
      images: [
        'https://images.unsplash.com/photo-1577083552431-6e5fd01988d8?w=500&auto=format&fit=crop&q=60',
        'https://images.unsplash.com/photo-1577083552431-6e5fd01988d8?w=500&auto=format&fit=crop&q=60',
      ],
      originalPrice: 250.0,
      discountedPrice: 200.0,
      category: 'Mughal',
      tags: ['Mughal', 'Historical', 'Gold Leaf'],
      createdAt: DateTime.now(),
      dimensions: {
        'width': 24,
        'height': 36,
        'unit': 'inches',
      },
      medium: 'Mixed Media',
      yearCreated: 2024,
      isOriginal: true,
      details: {
        'Medium': 'Mixed Media with Gold Leaf',
        'Size': '24 x 36 inches',
        'Style': 'Miniature Painting',
      },
      additionalDetails: {
        'Care': 'Keep away from direct sunlight',
        'Framing': 'Includes museum-quality frame',
      },
    ),
    ProductModel(
      id: 'prod6',
      title: 'Persian Garden',
      description: 'A traditional representation of a Persian garden.',
      sellerId: users[1].id,
      sellerName: users[1].name,
      images: [
        'https://images.unsplash.com/photo-1577083552431-6e5fd01988d8?w=500&auto=format&fit=crop&q=60',
        'https://images.unsplash.com/photo-1577083552431-6e5fd01988d8?w=500&auto=format&fit=crop&q=60',
      ],
      originalPrice: 180.0,
      discountedPrice: 150.0,
      category: 'Persian',
      tags: ['Persian', 'Traditional', 'Garden'],
      createdAt: DateTime.now(),
      dimensions: {
        'width': 30,
        'height': 40,
        'unit': 'inches',
      },
      medium: 'Watercolor',
      yearCreated: 2024,
      isOriginal: true,
      details: {
        'Medium': 'Gouache on Paper',
        'Size': '30 x 40 inches',
        'Style': 'Traditional Persian',
      },
      additionalDetails: {
        'Inspiration': 'Inspired by 16th century Persian manuscripts',
        'Technique': 'Traditional Persian painting methods',
      },
    ),
    ProductModel(
      id: 'prod7',
      title: 'Wildlife Symphony',
      description: 'A realistic portrayal of African wildlife.',
      sellerId: users[0].id,
      sellerName: users[0].name,
      images: [
        'https://images.unsplash.com/photo-1577083552431-6e5fd01988d8?w=500&auto=format&fit=crop&q=60',
        'https://images.unsplash.com/photo-1577083552431-6e5fd01988d8?w=500&auto=format&fit=crop&q=60',
      ],
      originalPrice: 220.0,
      discountedPrice: 180.0,
      category: 'Wildlife',
      tags: ['Wildlife', 'Realistic', 'African'],
      createdAt: DateTime.now(),
      dimensions: {
        'width': 36,
        'height': 48,
        'unit': 'inches',
      },
      medium: 'Oil',
      yearCreated: 2024,
      isOriginal: true,
      details: {
        'Medium': 'Oil on Canvas',
        'Size': '36 x 48 inches',
        'Style': 'Realistic',
      },
      additionalDetails: {
        'Subject': 'African Wildlife',
        'Conservation': 'Portion of sales supports wildlife conservation',
      },
    ),
    ProductModel(
      id: 'prod8',
      title: 'Folk Tales',
      description: 'A celebration of Indian folk art.',
      sellerId: users[1].id,
      sellerName: users[1].name,
      images: [
        'https://images.unsplash.com/photo-1577083552431-6e5fd01988d8?w=500&auto=format&fit=crop&q=60',
        'https://images.unsplash.com/photo-1577083552431-6e5fd01988d8?w=500&auto=format&fit=crop&q=60',
      ],
      originalPrice: 120.0,
      discountedPrice: 95.0,
      category: 'Folk',
      tags: ['Folk', 'Indian', 'Traditional'],
      createdAt: DateTime.now(),
      dimensions: {
        'width': 20,
        'height': 30,
        'unit': 'inches',
      },
      medium: 'Acrylic',
      yearCreated: 2024,
      isOriginal: true,
      details: {
        'Medium': 'Natural pigments on handmade paper',
        'Size': '20 x 30 inches',
        'Style': 'Traditional Folk Art',
      },
      additionalDetails: {
        'Story': 'Based on traditional folk tales',
        'Materials': 'All natural materials and pigments',
      },
    ),
    ProductModel(
      id: 'prod9',
      title: 'Digital Dreams',
      description: 'A digital artwork exploring abstract concepts.',
      sellerId: users[0].id,
      sellerName: users[0].name,
      images: [
        'https://images.unsplash.com/photo-1577083552431-6e5fd01988d8?w=500&auto=format&fit=crop&q=60',
        'https://images.unsplash.com/photo-1577083552431-6e5fd01988d8?w=500&auto=format&fit=crop&q=60',
      ],
      originalPrice: 100.0,
      discountedPrice: 85.0,
      category: 'Digital',
      tags: ['Digital', 'Abstract', 'Modern'],
      createdAt: DateTime.now(),
      dimensions: {
        'width': 24,
        'height': 36,
        'unit': 'inches',
      },
      medium: 'Digital',
      yearCreated: 2024,
      isOriginal: false,
      details: {
        'Medium': 'Digital Art',
        'Size': '24 x 36 inches',
        'Style': 'Contemporary Digital',
      },
      additionalDetails: {
        'Format': 'Limited Edition Digital Print',
        'Printing': 'Archival quality pigment inks',
      },
    ),
    ProductModel(
      id: 'prod10',
      title: 'Sacred Temple',
      description: 'A portrayal of a Hindu temple.',
      sellerId: users[1].id,
      sellerName: users[1].name,
      images: [
        'https://images.unsplash.com/photo-1577083552431-6e5fd01988d8?w=500&auto=format&fit=crop&q=60',
        'https://images.unsplash.com/photo-1577083552431-6e5fd01988d8?w=500&auto=format&fit=crop&q=60',
      ],
      originalPrice: 160.0,
      discountedPrice: 130.0,
      category: 'Hindu',
      tags: ['Hindu', 'Temple', 'Religious'],
      createdAt: DateTime.now(),
      dimensions: {
        'width': 30,
        'height': 40,
        'unit': 'inches',
      },
      medium: 'Acrylic',
      yearCreated: 2024,
      isOriginal: true,
      details: {
        'Medium': 'Acrylic on Canvas',
        'Size': '30 x 40 inches',
        'Style': 'Traditional Hindu Art',
      },
      additionalDetails: {
        'Theme': 'Temple Architecture',
        'Technique': 'Traditional painting methods',
      },
    ),
    ProductModel(
      id: 'prod11',
      title: 'Mountain Sunset',
      description: 'A landscape capturing a mountain sunset.',
      sellerId: users[0].id,
      sellerName: users[0].name,
      images: [
        'https://images.unsplash.com/photo-1577083552431-6e5fd01988d8?w=500&auto=format&fit=crop&q=60',
        'https://images.unsplash.com/photo-1577083552431-6e5fd01988d8?w=500&auto=format&fit=crop&q=60',
      ],
      originalPrice: 140.0,
      discountedPrice: 110.0,
      category: 'Landscape',
      tags: ['Landscape', 'Sunset', 'Mountain'],
      createdAt: DateTime.now(),
      dimensions: {
        'width': 36,
        'height': 48,
        'unit': 'inches',
      },
      medium: 'Oil',
      yearCreated: 2024,
      isOriginal: true,
      details: {
        'Medium': 'Oil on Canvas',
        'Size': '36 x 48 inches',
        'Style': 'Realistic Landscape',
      },
      additionalDetails: {
        'Location': 'Inspired by Himalayan mountains',
        'Lighting': 'Natural sunset colors',
      },
    ),
    ProductModel(
      id: 'prod12',
      title: 'Still Life with Flowers',
      description: 'A still life featuring flowers.',
      sellerId: users[1].id,
      sellerName: users[1].name,
      images: [
        'https://images.unsplash.com/photo-1577083552431-6e5fd01988d8?w=500&auto=format&fit=crop&q=60',
        'https://images.unsplash.com/photo-1577083552431-6e5fd01988d8?w=500&auto=format&fit=crop&q=60',
      ],
      originalPrice: 120.0,
      discountedPrice: 95.0,
      category: 'Still Life',
      tags: ['Still Life', 'Flowers', 'Traditional'],
      createdAt: DateTime.now(),
      dimensions: {
        'width': 20,
        'height': 30,
        'unit': 'inches',
      },
      medium: 'Watercolor',
      yearCreated: 2024,
      isOriginal: true,
      details: {
        'Medium': 'Oil on Canvas',
        'Size': '20 x 30 inches',
        'Style': 'Classical Still Life',
      },
      additionalDetails: {
        'Subject': 'Spring Flower Arrangement',
        'Technique': 'Traditional oil painting methods',
      },
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
      productImage: 'https://images.unsplash.com/photo-1547826039-bfc35e0f1ea8?w=500&auto=format&fit=crop&q=60',
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
      'https://images.unsplash.com/photo-1547826039-bfc35e0f1ea8?w=500&auto=format&fit=crop&q=60',
      'https://images.unsplash.com/photo-1547826039-bfc35e0f1ea8?w=500&auto=format&fit=crop&q=60',
      'https://images.unsplash.com/photo-1547826039-bfc35e0f1ea8?w=500&auto=format&fit=crop&q=60',
      'https://images.unsplash.com/photo-1547826039-bfc35e0f1ea8?w=500&auto=format&fit=crop&q=60',
      'https://images.unsplash.com/photo-1547826039-bfc35e0f1ea8?w=500&auto=format&fit=crop&q=60',
    ];
    return images[DateTime.now().millisecond % images.length];
  }

  static String getRandomCategoryImage() {
    const images = [
      'https://images.unsplash.com/photo-1547826039-bfc35e0f1ea8?w=500&auto=format&fit=crop&q=60',
      'https://images.unsplash.com/photo-1547826039-bfc35e0f1ea8?w=500&auto=format&fit=crop&q=60',
      'https://images.unsplash.com/photo-1547826039-bfc35e0f1ea8?w=500&auto=format&fit=crop&q=60',
      'https://images.unsplash.com/photo-1547826039-bfc35e0f1ea8?w=500&auto=format&fit=crop&q=60',
      'https://images.unsplash.com/photo-1547826039-bfc35e0f1ea8?w=500&auto=format&fit=crop&q=60',
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