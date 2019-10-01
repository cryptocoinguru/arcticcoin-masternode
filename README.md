# arcticcoin-masternode
Some toolsets to manage and keep up ARC-Masternode

## How-To
### Generic Notices
Please note that you may have to replace some path's. This tutorial assumes that you are running Linux OS and that the
wallet is in this path: '/opt/wallets/arcticcoin/'

You may check-out this repositry into f.e. /opt/wallets/arcticcoin/toolset/ and then use symlinks
using git:
$> git clone https://github.com/cryptocoinguru/arcticcoin-masternode.git

or by downloading this repo as ZIP-file.

### Insights

Add this line to your arcticcoin.conf file
```
blocknotify=/opt/wallets/arcticcoin/toolset/found-block.sh "%s"
```

## Security hints
Don't run your wallet's as root-user as this can be a potential security risk!
