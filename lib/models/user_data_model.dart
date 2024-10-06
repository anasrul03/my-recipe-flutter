class UserDataModel {
  UserDataModel({required this.displayName});

  final String displayName;

  // Convert a UserDataModel into a JSON object
  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
    };
  }

  // Create a UserDataModel from a JSON object
  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      displayName: json['displayName'],
    );
  }
}
