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

#### Setup this toolset
1. Add this line to your arcticcoin.conf file (changing the given path if required!)
```
blocknotify=/opt/wallets/arcticcoin/toolset/found-block.sh "%s"
```

2. Copy or rename watchdog.conf~dist to watchdog.conf
3. Edit watchdog.conf and edit path's for:
```
_walletCli="${_walletDir}/arcticcoin-cli.sh";         # Path to your wallet-cli binary (f.e. bin/arcticcoin-cli)
_logFile='${_walletDir}/debug.log';                   # Path to your arcticcoin log-file path (usually it's in same directory)
```

4.1 $>
Make sh-scripts executeable and 'install' them in upper-dir (../ -> arcticcoin-wallet directory if installing in sub-dir)
$> chmod +x ./*.sh && ln -s ./*.sh ../

#### Keeping disk-usage small ...
Setup BTRFS or ZFS File-System enabling compression and deduplication (detail setup not included atm.)
but BTRFS has been used in practice for about 12 month now by me without any issues!

For this purpose I've been using daemon with '-datadir=' argument pointing f.e. to /var/lib/blockchain/arcticcoin
using BTRFS on that mount-point (/var/lib/blockchain/ -> BTRFS or ZFS Storage-Root)

## Security hints
Don't run your wallet's as root-user as this can be a potential security risk!
