
class notifClass {
  late String Photoid;
  late String userName;
  late String type;
  late String userMail;
  late String senderMail;
  late String postID;
  late String pid;
  late String sendername;


  notifClass({required this.sendername, required this.Photoid, required this.userName, required this.type, required this.userMail, required this.senderMail, this.postID = "", required this.pid});

  Map<String, dynamic> toJson() {
    return {

      'pid' : pid,
    'Photoid': Photoid,
    'userName': userName,
    'type': type,
    'userMail': userMail,
    'senderMail': senderMail,
    'postID': postID,
      'sendername': sendername,
    };
  }

}
