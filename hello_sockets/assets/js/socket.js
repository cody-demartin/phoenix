import { Socket } from 'phoenix';

// create and connect to new socket
const socket = new Socket("/socket", {});
socket.connect();

// define and join channels
const channel = socket.channel("ping");
channel.join()
    .receive("ok", (resp) => {console.log("Joined ping channel"), resp })
    .receive("error", (resp) => {console.log("Unable to join ping channel", resp) })

export default socket

