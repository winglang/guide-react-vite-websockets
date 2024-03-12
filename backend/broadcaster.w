bring cloud;
bring websockets;

pub class Broadcaster {
  pub url: str;
  server: websockets.WebSocket;
  clients: cloud.Bucket;

  new() {
    this.server = new websockets.WebSocket(name: "counters");
    this.url = this.server.url;
    this.clients = new cloud.Bucket();
 
    // upon connection, add the client to the list
    this.server.onConnect(inflight(id: str) => {
      log("new connection {id}");
      this.clients.put(id, "");
    });

    // upon disconnect, remove the client from the list
    this.server.onDisconnect(inflight(id: str): void => {
      this.clients.delete(id);
    });
  }

  // send a message to all clients
  pub inflight broadcast(message: str) {
    for id in this.clients.list() {
      log("sending message to {id}");
      this.server.sendMessage(id, message);
    }
  }
}
