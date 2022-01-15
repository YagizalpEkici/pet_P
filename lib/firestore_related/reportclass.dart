class reportclass {
  late String reportedMail;
  late String pid;


  reportclass({required this.reportedMail, required this.pid});

  Map<String, dynamic> toJson() {
    return {

      'pid' : pid,
      'reportedMail': reportedMail,

    };
  }

}