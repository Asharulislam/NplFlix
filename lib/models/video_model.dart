class VideoModel {
  final String? uuid;
  final int? contentId;
  final int? contentSeasonEpisodeId;
  final int? contentVideoId;
  final String? videoUrl;
  final int? watchedTime;
  final bool? isDownloaded;
  final String? keyPairId;
  final String? policy;
  final String? signature;
  final List<Captions>? captions;
  final List<Ads>? ads;


  VideoModel({
    this.uuid,
    this.contentId,
    this.contentSeasonEpisodeId,
    this.contentVideoId,
    this.videoUrl,
    this.watchedTime,
    this.isDownloaded,
    this.keyPairId,
    this.policy,
    this.signature,
    this.captions,
    this.ads
  });

  // Factory method to create an instance from JSON
  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      uuid: json['uuid'] as String?,
      contentId: json['contentId'] as int?,
      contentSeasonEpisodeId: json['contentSeasonEpisodeId'] as int?,
      contentVideoId: json['contentVideoId'] as int?,
      videoUrl: json['videoUrl'] as String?,
      watchedTime: json['watchedTime'] as int?,
      isDownloaded: json['isDownloaded'] as bool?,
        keyPairId: json['keyPairId'] as String?,
        policy : json['policy'] as String?,
        signature : json['signature'] as String?,
        captions: (json['captions'] as List?)?.map((e) => Captions.fromJson(e)).toList(),
      ads: (json['ads'] as List?)?.map((e) => Ads.fromJson(e)).toList(),
    );
  }

  // Method to convert an instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'contentId': contentId,
      'contentSeasonEpisodeId': contentSeasonEpisodeId,
      'contentVideoId': contentVideoId,
      'videoUrl': videoUrl,
      'watchedTime': watchedTime,
      'isDownloaded': isDownloaded,
      'keyPairId' : keyPairId,
      'policy' : policy,
      'signature' : signature,
      'captions': captions?.map((e) => e.toJson()).toList(),
    };
  }
}

class Captions {
  final bool? isTrailler;
  final String? captionFileName;
  final String? captionFilePath;
  final int? languageId;

  Captions({
    this.captionFileName,
    this.captionFilePath,
    this.isTrailler,
    this.languageId
  });

  // Factory method to create an instance from JSON
  factory Captions.fromJson(Map<String, dynamic> json) {
    return Captions(
      captionFileName: json['captionFileName'] as String?,
      captionFilePath: json['captionFilePath'] as String?,
        isTrailler : json['isTrailler'] as bool?,
        languageId : json['languageId'] as int?

    );
  }

  // Method to convert an instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'captionFileName': captionFileName,
      'captionFilePath': captionFilePath,
      'isTrailler' : isTrailler,
      'languageId' : languageId

    };
  }
}

class Ads {
  final int? startAt;
  final String? adUrl;

  Ads({
    this.startAt,
    this.adUrl,
  });

  // Factory method to create an instance from JSON
  factory Ads.fromJson(Map<String, dynamic> json) {
    return Ads(
      startAt: json['startAt'] as int?,
      adUrl: json['adUrl'] as String?,
    );
  }

  // Method to convert an instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'startAt': startAt,
      'adUrl': adUrl,

    };
  }
}

