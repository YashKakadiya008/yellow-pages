import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:yellowpages/data/services/SharedPreferencesService.dart';
import 'package:yellowpages/utils/app_constants.dart';

class SocketService {
  late IO.Socket socket;
  bool isConnected = false;
  Function(dynamic)? onMessageCallback;
  Function(dynamic)? onTypingCallback;
  Function(dynamic)? onErrorCallback;

  // Initialize socket connection
  void initializeSocket() {
    try {
      socket = IO.io(
          AppConstants.baseNgrokUrl,
          IO.OptionBuilder()
              .setTransports(['websocket'])
              .disableAutoConnect()
              .enableForceNew()
              .enableReconnection()
              .setReconnectionAttempts(5)
              .setReconnectionDelay(5000)
              .build());

      _setupSocketListeners();
      socket.connect();
    } catch (e) {
      print('Socket initialization error: $e');
    }
  }

  // Set up all socket listeners
  void _setupSocketListeners() {
    print("Setting up socket listeners");

    socket.onConnect((_) {
      print('Socket connected: ${socket.id}');
      isConnected = true;
    });

    socket.onConnectError((data) {
      print('Connect Error: $data');
      isConnected = false;
    });

    socket.onDisconnect((_) {
      print('Socket disconnected');
      isConnected = false;
    });

    // Listen for new messages
    socket.on('newMessage', (data) {
      print("Received data: $data"); // Check what data is being emitted
      onMessageCallback!(data);
    });

    // Listen for errors
    socket.on('error', (data) {
      print('Error received: $data');
      if (onErrorCallback != null) {
        onErrorCallback!(data);
      }
    });

    // Listen for typing events
    socket.on('userTyping', (data) {
      print('Typing status: $data');
      if (onTypingCallback != null) {
        onTypingCallback!(data);
      }
    });

    socket.on('joinedChat', (data) {
      print('Joined chat room: $data');
    });
  }

  // Join a specific chat room
  Future<void> joinChat(String chatId) async {
    if (!isConnected) {
      print('Socket not connected. Attempting to reconnect...');
      socket.connect();
    }

    String? userId = await SharedPreferencesService.getUserID();
    if (userId != null) {
      print("Joining chat room: $chatId with userId: $userId");
      socket.emit('joinChat', {
        'chatId': chatId,
        'userId': userId,
      });
    } else {
      print("Failed to retrieve user ID");
    }
  }

  // Leave a chat room
  void leaveChat(String chatId) {
    socket.emit('leaveChat', chatId);
  }

  void initialize() {
    socket.on('userTyping', (data) {
      print('Typing status: $data');
      if (onTypingCallback != null) {
        onTypingCallback!(data);
      }
    });
  }

  // Send a message
  Future<void> sendMessage({
    required String chatId,
    required String text,
  }) async {
    if (!isConnected) {
      print('Socket not connected. Attempting to reconnect...');
      socket.connect();
      return;
    }
    String? userId = await SharedPreferencesService.getUserID();

    socket.emit('sendMessage', {
      'chatId': chatId,
      'text': text,
      'userId': userId,
    });
  }

  // Send typing indicator
  Future<void> sendTypingStatus(String chatId, bool isTyping) async {
    print("Sending typing status: $isTyping");
    String? userId = await SharedPreferencesService.getUserID();

    socket.emit('typing', {
      'chatId': chatId,
      'isTyping': isTyping,
      'userId': userId,
    });
  }

  // Listen for incoming messages
  void onNewMessage(Function(dynamic) callback) {
    onMessageCallback = callback;
  }

  // Listen for typing status
  void onTypingStatus(Function(dynamic) callback) {
    onTypingCallback = callback;
  }

  // Listen for errors
  void onError(Function(dynamic) callback) {
    onErrorCallback = callback;
  }

  // Disconnect socket
  void disconnect() {
    socket.disconnect();
    isConnected = false;
    onMessageCallback = null;
    onTypingCallback = null;
    onErrorCallback = null;
  }

  // Reconnect socket
  void reconnect() {
    if (!isConnected) {
      socket.connect();
    }
  }
}
