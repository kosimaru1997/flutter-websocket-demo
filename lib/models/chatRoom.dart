class ChatRoomDto {
  // コンストラクタ
  ChatRoomDto({
    required this.userId,
    required this.roomId,
    this.lastMessage,
    required this.uncheckedCount,
    required this.updatedAt,
  });

  // プロパティ
  final String userId;
  final String roomId;
  final String? lastMessage; // Optional
  final int uncheckedCount;
  final int updatedAt;

  // JSONからChatRoomを生成するファクトリコンストラクタ
  factory ChatRoomDto.fromJson(Map<String, dynamic> json) {
    return ChatRoomDto(
      userId: json['user_id'] as String,
      roomId: json['room_id'] as String,
      lastMessage: json['last_message'] as String?,
      uncheckedCount: json['unchecked_count'] as int,
      updatedAt: json['updated_at'] as int,
    );
  }
}

class GetChatRoomResponse {
  // コンストラクタ
  GetChatRoomResponse({
    required this.roomList,
  });

  // プロパティ
  final List<ChatRoomDto> roomList;

  // JSONからGetChatRoomResponseを生成するファクトリコンストラクタ
  factory GetChatRoomResponse.fromJson(Map<String, dynamic> json) {
    var roomListJson = json['room_list'] as List;
    List<ChatRoomDto> roomList = roomListJson.map((room) => ChatRoomDto.fromJson(room)).toList();

    return GetChatRoomResponse(
      roomList: roomList,
    );
  }
}