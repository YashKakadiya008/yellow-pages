class User {
  final String firstname;
  final String lastname;
  final String postalcode;
  final String birthdate;
  final String zender;
  final String language;
  final String profile;
  final String id;
  final String username;
  final String email;
  final String role;
  final String createdAt;
  final String updatedAt;

  User({
    required this.firstname,
    required this.lastname,
    required this.postalcode,
    required this.birthdate,
    required this.zender,
    required this.language,
    required this.profile,
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      postalcode: json['postalcode'] ?? '',
      birthdate: json['birthdate'] ?? '',
      zender: json['zender'] ?? '',
      language: json['language'] ?? '',
      profile: json['profile'] ?? '',
      id: json['_id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstname': firstname,
      'lastname': lastname,
      'postalcode': postalcode,
      'birthdate': birthdate,
      'zender': zender,
      'language': language,
      'profile': profile,
      '_id': id,
      'username': username,
      'email': email,
      'role': role,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class SocialMedia {
  final String instagram;
  final String facebook;

  SocialMedia({
    required this.instagram,
    required this.facebook,
  });

  factory SocialMedia.fromJson(Map<String, dynamic> json) {
    return SocialMedia(
      instagram: json['instagram'] ?? '',
      facebook: json['facebook'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'instagram': instagram,
      'facebook': facebook,
    };
  }
}

class CategoryType {
  final String id;
  final String name;

  CategoryType({
    required this.id,
    required this.name,
  });

  factory CategoryType.fromJson(Map<String, dynamic> json) {
    return CategoryType(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
    };
  }
}

class SubcategoryType {
  final String id;
  final String name;
  final String category;

  SubcategoryType({
    required this.id,
    required this.name,
    required this.category,
  });

  factory SubcategoryType.fromJson(Map<String, dynamic> json) {
    return SubcategoryType(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'category': category,
    };
  }
}

class Business {
  final SocialMedia socialMedia;
  final String id;
  final String name;
  final CategoryType categoryType;
  final SubcategoryType subcategoryType;
  final User userId;
  final String mobilenumber;
  final String whatsappnumber;
  final double latitude;
  final double longitude;
  final String description;
  final List<String> tags;
  final String logo;
  final String website;
  final String language;
  final String methodOfPayment;
  final bool status;
  final String createdAt;
  final String updatedAt;
  final String locationName;
  final String city;
  final Map<String, Map<String, String>> businessHours;

  Business({
    required this.socialMedia,
    required this.id,
    required this.name,
    required this.categoryType,
    required this.subcategoryType,
    required this.userId,
    required this.mobilenumber,
    required this.whatsappnumber,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.tags,
    required this.logo,
    required this.website,
    required this.language,
    required this.methodOfPayment,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.locationName,
    required this.city,
    required this.businessHours,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    Map<String, Map<String, String>> businessHours = {};
    if (json['businessHours'] != null) {
      json['businessHours'].forEach((day, hours) {
        if (hours is Map<String, dynamic>) {
          businessHours[day] = Map<String, String>.from(hours);
        }
      });
    }
    return Business(
      socialMedia: SocialMedia.fromJson(json['socialMedia']),
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      categoryType: CategoryType.fromJson(json['categoryType']),
      subcategoryType: SubcategoryType.fromJson(json['subcategoryType']),
      userId: User.fromJson(json['userId']),
      mobilenumber: json['mobilenumber'] ?? '',
      whatsappnumber: json['whatsappnumber'] ?? '',
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      description: json['description'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      logo: json['logo'] ?? '',
      website: json['website'] ?? '',
      language: json['language'] ?? '',
      methodOfPayment: json['methodOfPayment'] ?? '',
      status: json['status'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      city: json['city'] ?? '',
      locationName: json['locationName'] ?? '',
      businessHours: businessHours,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'socialMedia': socialMedia.toJson(),
      '_id': id,
      'name': name,
      'categoryType': categoryType.toJson(),
      'subcategoryType': subcategoryType.toJson(),
      'userId': userId.toJson(),
      'mobilenumber': mobilenumber,
      'whatsappnumber': whatsappnumber,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'tags': tags,
      'logo': logo,
      'website': website,
      'language': language,
      'methodOfPayment': methodOfPayment,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'city' : city,
      'locationName': locationName,
      'businessHours': businessHours,
    };
  }
}

class Chat {
  final String id;
  final String businessName;
  final String businessOwnerUsername;
  final String businessOwnerId;
  final String visitorUsername;
  final String visitorId;
  final String businessOwnerProfile;
  final String visitorProfile;
  final String lastMessageTimestamp;
  final String lastMessage;
  final Map<String, int> unreadCount;

  Chat({
    required this.id,
    required this.businessName,
    required this.businessOwnerUsername,
    required this.businessOwnerId,
    required this.visitorUsername,
    required this.visitorId,
    required this.businessOwnerProfile,
    required this.visitorProfile,
    required this.lastMessageTimestamp,
    required this.lastMessage,
    required this.unreadCount,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['_id'],
      businessName: json['businessId']['name'],
      businessOwnerUsername: json['businessOwnerId']['username'],
      businessOwnerId: json['businessOwnerId']['_id'],
      visitorUsername: json['visitorId']['username'],
      visitorId: json['visitorId']['_id'],
      businessOwnerProfile: json['businessOwnerId']['profile'] ?? '',
      visitorProfile: json['visitorId']['profile'] ?? '',
      lastMessageTimestamp: json['lastMessage'] == null ? '' : json['lastMessage']['timestamp'],
      lastMessage: json['lastMessage'] == null ? '' : json['lastMessage']['text'],
      unreadCount: {
        'business': json['unreadCount']['business'],
        'visitor': json['unreadCount']['visitor'],
      },
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'businessId': {'name': businessName},
      'businessOwnerId': {'username': businessOwnerUsername, '_id': businessOwnerId, 'profile': businessOwnerProfile},
      'visitorId': {'username': visitorUsername, '_id': visitorId, 'profile': visitorProfile},
      'lastMessage': {
        'timestamp': lastMessageTimestamp,
        'text': lastMessage,
      },
      'unreadCount': unreadCount,
    };
  }
}
