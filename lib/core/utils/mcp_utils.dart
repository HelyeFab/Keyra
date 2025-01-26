import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String?> useMcpTool(String serverName, String toolName, Map<String, dynamic> arguments) async {
  try {
    final response = await http.post(
      Uri.parse('http://localhost:3000/mcp/tool'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'server': serverName,
        'tool': toolName,
        'arguments': arguments,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['content'] != null && data['content'].isNotEmpty) {
        return data['content'][0]['text'];
      }
    }
    return null;
  } catch (e) {
    print('MCP tool error: $e');
    return null;
  }
}
