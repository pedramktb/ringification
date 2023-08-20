import socketio

sio = socketio.Client()

@sio.event
def connect():
    print('Connected to the server')

@sio.event
def disconnect():
    print('Disconnected from the server')

if __name__ == '__main__':
    sio.connect('http://localhost:831')  # Replace with the server's address

    while True:
        message = input('Enter a message (or "exit" to quit): ')
        if message.lower() == 'exit':
            break
        sio.emit('message', message)

    sio.disconnect()