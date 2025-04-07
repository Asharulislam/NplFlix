import '../enums/index.dart';

class APIPathHelper {
  static String getValue(APIPath path) {
    switch (path) {
      case APIPath.login:
        return "Auth/login";
      case APIPath.signUp:
        return "User/register";
      case APIPath.getPlans:
        return "Plan";
      case APIPath.createProfile:
        return "UserProfile";
      case APIPath.getContentList:
        return "Content/GetContent";
      case APIPath.searchContent:
        return "Content/SearchContent";
      case APIPath.addMyList:
        return "Content/AddMyList";
      case APIPath.getList:
        return "Content/MyList";
      case APIPath.getContentById:
        return "Content/GetContentById";
      case APIPath.addWatchTime:
        return "Content/AddWatchTime";
      case APIPath.likeContent:
        return "Content/LikeContent";
      case APIPath.getVideo:
        return "Content/GetVideoURL";
      case APIPath.getPaymentDetail:
        return "Payment/GetPaymentDetail";
      case APIPath.payPlanPayment:
        return "Payment/PayPlanPayment";
      case APIPath.payRentalPayment:
        return "Payment/SaveRentalDetail";
      case APIPath.payRentalSeasonPayment:
        return "Payment/PayRentalSeasonPayment";
      case APIPath.validateOTP:
        return "User/ValidateOTP";
      case APIPath.savePlan:
        return "User/SavePlan";
      case APIPath.removeContinueWatching:
        return "Content/RemoveFromContinueWatching";
      case APIPath.createRoom:
        return "Room/CreateRoom";
      case APIPath.getRoom:
        return "Room/GetRoom";
      case APIPath.getRoomByUser:
        return "Room/GetRoomsByUser";
      case APIPath.cancelRoom:
        return "Room/CancelRoom";
      case APIPath.deleteRoom:
        return "Room/DeleteRoom";
      case APIPath.endRoom:
        return "Room/EndRoom";
      case APIPath.getParticipants:
        return "Room/GetParticipants/";
      case APIPath.addParticipants:
        return "Room/AddParticipant";
      case APIPath.leftRoom:
        return "Room/LeftTheRoom";
      case APIPath.approveParticipate:
        return "Room/ApproveParticipant";
      case APIPath.blockParticipate:
        return "Room/BlockParticipant";
      case APIPath.updateRoom:
        return "";



      default:
        return "";
    }
  }
}
