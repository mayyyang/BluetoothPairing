# iOS-BluetoothPairing
common iOS-BluetoothPairing

User 1 - Sends Payment

1. Upon launch, create a session with your MCPeerID and begin advertising to other peers.

2. Browse for nearby peers in NearbyViewController (tap on '+' sign).  Note that the other device must be advertising as well.

3. Tap on device name to invite peer.  Upon successful connection, dialog appears.

4.  You may now send money. Enter amount and tap 'PAY'.  Payment item is converted to NSData object and MCSession delegate method sendData... is called.



User 2 - Receives Payment

5. If two peers are successfully connected, didReceiveData gets called for User 2 upon successful data transfer.  Data object is converted to NSDictionary and passed to our delegate method, paymentReceived.  A dialog confirms the amount received.# BluetoothPairing
