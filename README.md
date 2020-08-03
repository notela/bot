# [ToOfan](https://telegram.me/To0fan)

**An advanced and powerful administration bot based on NEW TG-CLI


* * *

## Commands

| Use help |
|:--------|:------------|
| [#!/]help | just send help in your group and get the commands |

**You can use "#", "!", or "/" to begin all commands

* * *

# Installation

```sh
# Let's install the bot.
cd $HOME
git clone https://github.com/notela/good.git
cd good
chmod +x launch.sh
./launch.sh install
./launch.sh # Enter a phone number & confirmation code.
```
### One command
To install everything in one command, use:
```sh
cd $HOME && git clone https://github.com/To0fan/good.git && cd good && chmod +x launch.sh && ./launch.sh install && ./launch.sh
```

* * *

### Sudo And Bot
After you run the bot for first time, send it `!id`. Get your ID and stop the bot.

Open ./bot/bot.lua and add your ID to the "sudo_users" section in the following format:
```
    sudo_users = {
    111334847,
    0,
    YourID
  }
```
add your bot ID at line 4
add your ID at line 82
Then restart the bot.

# Support and development

More information [ToOfan Development](https://telegram.me/To0fan)

* * *

# Developers!

[ToOfan](https://github.com/To0fan) ([Telegram](https://telegram.me/To0fan))
