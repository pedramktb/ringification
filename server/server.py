import eventlet
import socketio

sio = socketio.Server()
app = socketio.WSGIApp(sio, static_files={
    '/': {'content_type': 'text/html', 'filename': 'index.html'}
})

@sio.event
def connect(sid, environ):
    print('connect ', sid)

@sio.event
def disconnect(sid):
    print('disconnect ', sid)

@sio.event
def message(sid, data):
    sio.emit('message', data, broadcast=True)
    print('message:', data)

if __name__ == '__main__':
    eventlet.wsgi.server(eventlet.listen(('', 831)), app)