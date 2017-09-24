# spyAngelXE8
A Delphi/pascal based trojan RAT(2014) which uses [reverse connection](https://en.wikipedia.org/wiki/Reverse_connection), CPanel server and Application server.
**Undetectable at the time by AVs.

(***Deprecated/Outdated*)

# Features:
- Reverse connection
- Cpanel WEB (PHP)
- Keylogger
- Cryptography (encrypt text and files)
- USB Autoinfection
- File and Process Manager
- Upload & Download
- Webcam / Remote Desktop

# How does the remote screen work?
The Client connects to the server.
When connecting the first socket, it then connects the other 2 sockets.
The first Socket transfers messages, position and the mouse click.
The server requests the first image.

Client capture first screen (This is done in Bitmap, 8bit to reduce size)
The first image is sent, always compressed by zLib and Lh5.
The image is stored in the client memory.
When sending the next images to the server, the client compares with the pixels of the previous image, sending only what has changed.

## *Libs*:
- sndkey32.pas > Used to simulate keyboard keys.
- StreamManager.pas > Used to capture the screen, and do the pixel comparison.
- iconchanger > To change applications icon.
- KeyHook > Used to build "DLL" to get typed keys (method 2) without using the timer

# Some functions have been removed to prevent misuse of this application.
# University Work for Information Security Discipline (2014-2015)
# For educational purposes only, use at your own responsibility.

# Screenshots

![Server](https://github.com/GlaucioAlmeida/spyAngelXE8/blob/master/server.jpg)

![Server](https://github.com/GlaucioAlmeida/spyAngelXE8/blob/master/server2.jpg)
