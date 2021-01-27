import { Socket } from 'phoenix';

// create and connect to new socket
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

export default socket

