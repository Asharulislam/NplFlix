import 'package:npflix/models/room_model.dart';

class Content {
  var releaseDate;
  var publishDate;
  var duration;
  var isDownloadable;
  var statusId;
  var title;
  var synopsis;
  var countryId;
  var country;
  var contentTypeId;
  var contentType;
  var languageId;
  var language;
  var pgId;
  var pg;
  var iconUrl;
  var  maturityTags;
  var contentRentalPrice;
  var contentRentalPeriodInDays;
  var isContentFree;
  var casts;
  var writer;
  var director;
  var genre;
  var isSmallHorizontalThumbnail;
  var isSmallVerticalThumbnail;
  var isMediumHorizontalThumbnail;
  var isHomeBanner;
  var isModalBanner;
  var isLargeMovieTitleHorizontal;
  var uuid;
  var contentId;
  var isLiked;
  var trailer1;
  var isInMyList;
  var rentalTransaction;
  var pricePerDay;
  var discountPerDay;
  var watchedTime;
  RoomModel? room;





  Content({
    this.releaseDate,
    this.publishDate,
    this.duration,
    this.isDownloadable,
    this.statusId,
    this.title,
    this.synopsis,
    this.countryId,
    this.country,
    this.contentTypeId,
    this.contentType,
    this.languageId,
    this.language,
    this.pgId,
    this.pg,
    this.iconUrl,
    this.maturityTags,
    this.contentRentalPrice,
    this.contentRentalPeriodInDays,
    this.isContentFree = true,
    this.casts,
    this.writer,
    this.director,
    this.genre,
    this.isSmallHorizontalThumbnail,
    this.isSmallVerticalThumbnail,
    this.isMediumHorizontalThumbnail,
    this.isHomeBanner,
    this.isModalBanner,
    this.isLargeMovieTitleHorizontal,
    this.uuid,
    this.contentId,
    this.isLiked,
    this.trailer1,
    this.isInMyList,
    this.rentalTransaction,
    this.pricePerDay,
    this.discountPerDay,
    this.watchedTime,
    this.room
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      releaseDate: json['releaseDate'],
      publishDate: json['publishDate'],
      duration: json['duration'],
      isDownloadable: json['isDownloadable'],
      statusId: json['statusId'],
      title: json['title'],
      synopsis: json['synopsis'],
      countryId: json['countryId'],
      country: json['country'],
      contentTypeId: json['contentTypeId'],
      contentType: json['contentType'],
      languageId: json['languageId'],
      language: json['language'],
      pgId: json['pgId'],
      pg: json['pg'],
      iconUrl: json['iconUrl'],
      maturityTags: json['maturityTags'],
      contentRentalPrice: json['contentRentalPrice'] ,
      contentRentalPeriodInDays: json['contentRentalPeriodInDays'],
      isContentFree: json['isContentFree'],
      casts: json['casts'],
      writer: json['writer'],
      director: json['director'],
      genre: json['genre'],
      isSmallHorizontalThumbnail: json['isSmallHorizontalThumbnail'],
      isSmallVerticalThumbnail: json['isSmallVerticalThumbnail'],
      isMediumHorizontalThumbnail: json['isMediumHorizontalThumbnail'],
      isHomeBanner: json['isHomeBanner'],
      isModalBanner: json['isModalBanner'],
      isLargeMovieTitleHorizontal: json['isLargeMovieTitleHorizontal'],
      uuid: json['uuid'],
      room: json['room'] != null ? RoomModel.fromJson(json['room']) : null,
      contentId: json['contentId'],
        isLiked: json['isLiked'],
        trailer1 : json['trailer1'],
        isInMyList : json['isInMyList'],
        pricePerDay : json['pricePerDay'],
        discountPerDay : json['discountPerDay'],
        rentalTransaction : json['rentalTransaction'] != null ? RentalTransaction.fromJson(json['rentalTransaction']) : null,
        watchedTime : json["watchedTime"],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'releaseDate': releaseDate,
      'publishDate': publishDate,
      'duration': duration,
      'isDownloadable': isDownloadable,
      'statusId': statusId,
      'title': title,
      'synopsis': synopsis,
      'countryId': countryId,
      'country': country,
      'contentTypeId': contentTypeId,
      'contentType': contentType,
      'languageId': languageId,
      'language': language,
      'pgId': pgId,
      'pg': pg,
      'iconUrl': iconUrl,
      'maturityTags': maturityTags,
      'contentRentalPrice': contentRentalPrice,
      'contentRentalPeriodInDays': contentRentalPeriodInDays,
      'isContentFree': isContentFree,
      'casts': casts,
      'writer': writer,
      'director': director,
      'genre': genre,
      'isSmallHorizontalThumbnail': isSmallHorizontalThumbnail,
      'isSmallVerticalThumbnail': isSmallVerticalThumbnail,
      'isMediumHorizontalThumbnail': isMediumHorizontalThumbnail,
      'isHomeBanner': isHomeBanner,
      'isModalBanner': isModalBanner,
      'isLargeMovieTitleHorizontal': isLargeMovieTitleHorizontal,
      'uuid': uuid,
      'contentId': contentId,
      'isLiked' : isLiked,
      'trailer1' : trailer1,
      'isInMyList' : isInMyList,
      'rentalTransaction' : rentalTransaction,
      'pricePerDay' : pricePerDay,
      'discountPerDay' : discountPerDay,
      'watchedTime' :watchedTime
    };
  }

}

class RentalTransaction {
  var rentalStartDate;
  var rentalEndDate;
  var rentalDuration;
  var rentalPrice;
  var discount;
  var totalAmount;


  RentalTransaction({
    required this.rentalStartDate,
    required this.rentalEndDate,
    required this.rentalDuration,
    required this.discount,
    required this.totalAmount
  });

  // Factory method to create an instance from a JSON map
  factory RentalTransaction.fromJson(Map<String, dynamic> json) {
    return RentalTransaction(
      rentalStartDate: json['rentalStartDate'],
      rentalEndDate: json['rentalEndDate'],
      rentalDuration: json['rentalDuration'],
      discount : json['discount'],
        totalAmount : json['totalAmount']
    );
  }
  //Method to convert an instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'rentalStartDate': rentalStartDate,
      'rentalEndDate': rentalEndDate,
      'rentalDuration' : rentalDuration,
      'discount' : discount,
      'totalAmount' :totalAmount

    };
  }


}