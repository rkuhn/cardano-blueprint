# KeepAlive

TODO: fill this section

The state machine for the KeepAlive protocol is as follows:

```mermaid
graph LR
  classDef client color:black,fill:PaleGreen,stroke:DarkGreen;
  classDef server color:black,fill:PowderBlue,stroke:DarkBlue;
  linkStyle default stroke:gray

  StDone(((StDone)))

  i(( )) --> StClient
  StClient --MsgKeepAlive--> StServer
  StServer --MsgKeepAliveResponse--> StClient
  StClient --MsgDone--> StDone

  class StClient client
  class StServer server
```

The CDDL for the messages in `KeepAlive` is as follows:

```cddl
;; messages.cddl
{{#include messages.cddl}}
```
