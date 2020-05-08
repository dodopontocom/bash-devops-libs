* [telegram.sendMessage()](#telegramsendmessage)



# telegram.sendMessage()

Send a Telegram message via Telegram bot  
Check Telegram documentation to [Create a bot and Generating an authorization token](https://core.telegram.org/bots#6-botfather)

### Arguments

* $TELEGRAM_BOT_TOKEN telegram bot token
* $TELEGRAM_NOTIFICATION_ID user receiver telegram id
* $TELEGRAM_MESSAGE message content

### Exit codes

* **0**: Message is sent
* **1**: Error to send the message

### Example

```bash
sendMessage <TELEGRAM_BOT_TOKEN> <TELEGRAM_NOTIFICATION_ID> <TELEGRAM_MESSAGE>
```

