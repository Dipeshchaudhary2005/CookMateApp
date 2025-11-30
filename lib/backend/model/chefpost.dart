import 'user.dart';

class ChefPost {
  String? id;
  UserModel? chef;
  String? title;
  String? description;
  String? urlToImage;
  String? createdAt;
  String? updatedAt;
  int? likeCount;
  int? commentCount;
  bool? liked;
  bool? favorite;

  List<Comment>? comments;

  ChefPost({this.id, this.chef, this.title, this.description, this.urlToImage, this.createdAt, this.updatedAt, this.likeCount, this.commentCount, this.liked, this.favorite, this.comments});

  factory ChefPost.fromJSON(dynamic data){
    var commentsList = List<Comment>.empty();
    if (data['comments'] != null){
      final comments = data['comments'] as List;
      commentsList = comments.map((e) =>
        Comment(
          commentId: e['_id'],
          body: e['body'],
          createdAt: e['createdAt'],
          updatedAt: e['updatedAt'],
          userId: e['user']['_id'],
          userName: e['user']['fullName'],
          userPic: e['user']['urlToImage']
        )
      ).toList();
    }
    return ChefPost(
      id: data['_id'],
      chef : UserModel(
        uid : data['chef']['_id'],
        fullName: data['chef']['fullName'],
        urlToImage: data['chef']['urlToImage'],
        speciality: data['chef']['chef']['speciality'],
        experience: data['chef']['chef']['experience'],
        rating: data['chef']['chef']['rating'],
        ratingCount: data['chef']['chef']['ratingCount']
      ),
      title: data['title'],
      description: data['description'],
      urlToImage: data['urlToImage'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
      likeCount: data['likeCount'] as int,
      commentCount: data['commentCount'] as int,
      liked: data['liked'] as bool,
      favorite: data['favorite'] as bool,
      comments: commentsList,
    );
  }
}

class Comment{
  String? body;
  String? userName;
  String? userId;
  String? userPic;
  String? commentId;
  String? createdAt;
  String? updatedAt;

  Comment({this.body, this.userId, this.userName, this.commentId, this.createdAt, this.updatedAt, this.userPic});
}