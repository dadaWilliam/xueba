class UserInfo {
  int? id;
  String? url;
  String? password;
  String? lastLogin;
  bool? isSuperuser;
  bool? vip;
  String? username;
  String? firstName;
  String? lastName;
  String? email;
  bool? isStaff;
  bool? isActive;
  String? dateJoined;
  String? nickname;
  String? avatar;
  String? mobile;
  String? gender;
  bool? subscribe;
  String? expire;

  UserInfo({
    this.id,
    this.url,
    this.password,
    this.lastLogin,
    this.isSuperuser,
    this.vip,
    this.username,
    this.firstName,
    this.lastName,
    this.email,
    this.isStaff,
    this.isActive,
    this.dateJoined,
    this.nickname,
    this.avatar,
    this.mobile,
    this.gender,
    this.subscribe,
    this.expire,
    required apiClient,
  });

  UserInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    password = json['password'];
    lastLogin = json['last_login'];
    isSuperuser = json['is_superuser'];
    vip = json['vip'];
    username = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    isStaff = json['is_staff'];
    isActive = json['is_active'];
    dateJoined = json['date_joined'];
    nickname = json['nickname'];
    avatar = json['avatar'];
    mobile = json['mobile'];
    gender = json['gender'];
    subscribe = json['subscribe'];
    expire = json['expire'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['url'] = url;
    data['password'] = password;
    data['last_login'] = lastLogin;
    data['is_superuser'] = isSuperuser;
    data['username'] = username;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['is_staff'] = isStaff;
    data['vip'] = vip;
    data['is_active'] = isActive;
    data['date_joined'] = dateJoined;
    data['nickname'] = nickname;
    data['avatar'] = avatar;
    data['mobile'] = mobile;
    data['gender'] = gender;
    data['subscribe'] = subscribe;
    data['expire'] = expire;

    return data;
  }
}
