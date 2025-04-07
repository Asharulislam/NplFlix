class AddListModel {
  int? actionID;
  int? userId;
  int? profileId;
  int? contentId;
  int? contentSeasonEpisodeId;
  int? contentVideoId;
  int? watchedTime;
  bool? isLiked;
  int? rating;
  bool? isDownloaded;
  bool? isInMyList;
  bool? isHide;
  bool? isActive;
  DateTime? createdAt;
  int? createdBy;
  DateTime? updatedAt;
  int? updatedBy;

  AddListModel({
    this.actionID,
    this.userId,
    this.profileId,
    this.contentId,
    this.contentSeasonEpisodeId,
    this.contentVideoId,
    this.watchedTime,
    this.isLiked,
    this.rating,
    this.isDownloaded,
    this.isInMyList,
    this.isHide,
    this.isActive,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
  });

  // Factory method to create an instance from JSON
  factory AddListModel.fromJson(Map<String, dynamic> json) {
    return AddListModel(
      actionID: json['actionID'] as int?,
      userId: json['userId'] as int?,
      profileId: json['profileId'] as int?,
      contentId: json['contentId'] as int?,
      contentSeasonEpisodeId: json['contentSeasonEpisodeId'] as int?,
      contentVideoId: json['contentVideoId'] as int?,
      watchedTime: json['watchedTime'] as int?,
      isLiked: json['isLiked'] as bool?,
      rating: json['rating'] as int?,
      isDownloaded: json['isDownloaded'] as bool?,
      isInMyList: json['isInMyList'] as bool?,
      isHide: json['isHide'] as bool?,
      isActive: json['isActive'] as bool?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      createdBy: json['createdBy'] as int?,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      updatedBy: json['updatedBy'] as int?,
    );
  }

  // Method to convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'actionID': actionID,
      'userId': userId,
      'profileId': profileId,
      'contentId': contentId,
      'contentSeasonEpisodeId': contentSeasonEpisodeId,
      'contentVideoId': contentVideoId,
      'watchedTime': watchedTime,
      'isLiked': isLiked,
      'rating': rating,
      'isDownloaded': isDownloaded,
      'isInMyList': isInMyList,
      'isHide': isHide,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'createdBy': createdBy,
      'updatedAt': updatedAt?.toIso8601String(),
      'updatedBy': updatedBy,
    };
  }
}
