class Post {
  String authorName;
  String authorImageUrl;
  String timeAgo;
  String imageUrl;
  String postId;

  Post(
      {required this.authorName,
      required this.authorImageUrl,
      required this.timeAgo,
      required this.imageUrl,
      required this.postId});
}

//{"_id":"615ba175b3d4ff1e1c4c2a7d","title":"test","description":"","picture-uri":"","likes":0,"__v":0}

final List<Post> posts = [
  Post(
      authorName: 'Sam Martin',
      authorImageUrl: 'assets/images/user0.png',
      timeAgo: '5 min',
      imageUrl: 'assets/images/post0.jpg',
      postId: '1234'),
  Post(
      authorName: 'Sam Martin',
      authorImageUrl: 'assets/images/user0.png',
      timeAgo: '10 min',
      imageUrl: 'assets/images/post1.jpg',
      postId: '2345'),
];

final List<String> stories = [
  'assets/images/user1.png',
  'assets/images/user2.png',
  'assets/images/user3.png',
  'assets/images/user4.png',
  'assets/images/user0.png',
  'assets/images/user1.png',
  'assets/images/user2.png',
  'assets/images/user3.png',
];
