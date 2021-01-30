import { Socket } from 'phoenix';

// create and connect to new general socket
const socket = new Socket("/socket", {});
socket.connect();

// define and join channels
const channel = socket.channel("ping");
channel.join()
    .receive("ok", (resp) => {console.log("Joined ping channel"), resp })
    .receive("error", (resp) => {console.log("Unable to join ping channel", resp) })

console.log("send ping")
channel.push("ping", {})
    .receive("ok", (resp) => console.log("receive", resp.ping));

console.log("send pong")
channel.push("pong", {})
    .receive("ok", (resp) => console.log("won't happen"))
    .receive("error", (resp) => console.error("won't happen yet"))
    .receive("timeout", (resp) => console.error("pong message timeout", resp));

// simulates error message
channel.push("param_ping", { error: true })
    .receive("error", resp => console.error("param_ping error:", resp));

// on an event..
channel.on("send_ping", (payload) => {
    console.log("ping requested", payload)
    channel.push("ping", {})
        .receive("ok", resp => console.log("ping:", resp.ping))
})

// simulates unhandled error
channel.push("invalid", {})
    .receive("ok", resp => console.error("o no I don't ever run"))


/////////////////////////////////////////////////////////////

const authSocket = new Socket("/auth_socket", {
    params: { token: window.authToken }
})

authSocket.onOpen(() => console.log('authSocket connected'))
authSocket.connect()

// connect to recurring channel
const recurringChannel = authSocket.channel("recurring");
recurringChannel.on("new_token", (payload) => {
    console.log("received new auth token", payload)
})
recurringChannel.join()

export default socket

