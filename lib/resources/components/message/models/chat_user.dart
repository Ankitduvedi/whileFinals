class ChatUser {
  ChatUser(
      {required this.image,
      required this.about,
      required this.name,
      required this.createdAt,
      required this.isOnline,
      required this.id,
      required this.lastActive,
      required this.email,
      required this.pushToken,
      required this.dateOfBirth,
      required this.gender,
      required this.phoneNumber,
      required this.place,
      required this.profession,
      required this.designation,
      required this.follower,
      required this.following});
  late String image;
  late String about;
  late String name;
  late String createdAt;
  late bool isOnline;
  late String id;
  late String lastActive;
  late String email;
  late String pushToken;
  late String phoneNumber;
  late String dateOfBirth;
  late String gender;
  late String profession;
  late String place;
  late String designation;
  late int following;
  late int follower;

  ChatUser.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    about = json['about'] ?? '';
    name = json['name'] ?? '';
    createdAt = json['created_at'] ?? '';
    isOnline = json['is_online'] ?? false;
    id = json['id'] ?? '';
    lastActive = json['last_active'] ?? '';
    email = json['email'] ?? '';
    pushToken = json['push_token'] ?? '';
    phoneNumber = json['phoneNumber'] ?? '';
    dateOfBirth = json['dateOfBirth'] ?? '';
    gender = json['gender'] ?? '';
    profession = json['profession'] ?? '';
    place = json['place'] ?? '';
    designation = json['designation'] ?? '';
    following = json['following'] ?? 0;
    follower = json['follower'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['about'] = about;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['is_online'] = isOnline;
    data['id'] = id;
    data['last_active'] = lastActive;
    data['email'] = email;
    data['push_token'] = pushToken;
    data['phoneNumber'] = phoneNumber;
    data['dateOfBirth'] = dateOfBirth;
    data['gender'] = gender;
    data['profession'] = profession;
    data['place'] = place;
    data['designation'] = designation;
    data['following'] = following;
    data['follower'] = follower;

    return data;
  }
  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'about': about,
      'name': name,
      'createdAt': createdAt,
      'isOnline': isOnline,
      'id': id,
      'lastActive': lastActive,
      'email': email,
      'pushToken': pushToken,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'phoneNumber': phoneNumber,
      'place': place,
      'profession': profession,
      'designation': designation,
      'follower': follower,
      'following': following,
    };
  }
  factory ChatUser.empty() {
    return ChatUser(
        image: '',
        about: '',
        name: '',
        createdAt: '',
        isOnline: false,
        id: '',
        lastActive: '',
        email: '',
        pushToken: '',
        dateOfBirth: '',
        gender: '',
        phoneNumber: '',
        place: '',
        profession: '',
        designation: '',
        follower: 0,
        following: 0);
  }
}
