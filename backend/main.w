bring vite;
bring cloud;
bring "./broadcaster.w" as b;

let broadcaster = new b.Broadcaster();

let api = new cloud.Api(cors: true);
let counter = new cloud.Counter();

api.get("/counter", inflight () => {
  return {
    body: "{counter.peek()}"
  };
});

api.post("/counter", inflight () => {
  let oldValue = counter.inc();
  broadcaster.broadcast("refresh");

  return {
    body: "{oldValue + 1}"
  };
});

new vite.Vite(
  root: "../frontend",
  publicEnv: {
    TITLE: "Wing + Vite + React",
    WS_URL: broadcaster.url, // <-- This is new
    API_URL: api.url,
  }
);

new cloud.Function(inflight () => {
  log(broadcaster.url);
}) as "show broadcaster url";