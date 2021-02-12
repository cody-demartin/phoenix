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

// dupe channel logic
const dupeChannel = socket.channel("dupe")

dupeChannel.on("number", (payload) => {
    console.log("new number received", payload)
})

dupeChannel.join()

/////////////////////////////////////////
// StatsSocket connection

const statsSocket = new Socket("/stats_socket", {})
statsSocket.connect()

const statsChannelInvalid = statsSocket.channel("invalid")
statsChannelInvalid.join()
    .receive("error", () => statsChannelInvalid.leave())

const statsChannelValid = statsSocket.channel("valid")
statsChannelValid.join()

for (let i = 0; i < 5; i++) {
    statsChannelValid.push("ping", {})
}
//////////////////////////////////////////
// slowStatsSocket

const slowStatsSocket = new Socket("/stats_socket", {})
slowStatsSocket.connect()

const slowStatsChannel = slowStatsSocket.channel("valid")
slowStatsChannel.join()

for (let i = 0; i < 5; i++) {
    slowStatsChannel.push("slow_ping", {})
        .receive("ok", () => console.log("Slow ping response received", i))
}
console.log("5 slow pings requested")

export default socket

