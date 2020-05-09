* [notifications.slack.sendMessageToChannel()](#notificationsslacksendmessagetochannel)
* [notifications.telegram.sendMessage()](#notificationstelegramsendmessage)
* [notifications.telegram.validateToken()](#notificationstelegramvalidatetoken)



# notifications.slack.sendMessageToChannel()

Send message to a Slack channel via bot

Check Slack documentation to create an App and a user bot  
then Generating an authorization token    
Also check how to create a workspace and add the bot to a channel  
[Slack API basics](https://api.slack.com/authentication/basics)  

### Arguments

* **SLACK_BOT_TOKEN** slack bot token
* **channel** (slack): workspace channel name
* **message** (message): content

### Exit codes

* **0**: Message is sent
* **1**: Error to send the message

### Example

```bash
sendMessageToChannel <channel> <message>
```




# notifications.telegram.sendMessage()

Send message to a Telegram user/group via bot

Check Telegram documentation to [Create a bot and Generating an authorization token](https://core.telegram.org/bots#6-botfather)

### Arguments

* **TELEGRAM_BOT_TOKEN** telegram bot token
* **TELEGRAM_NOTIFICATION_ID** user receiver telegram id
* **message** (message): content

### Exit codes

* **0**: Message is sent
* **1**: Error to send the message

### Example

```bash
sendMessage <message>
```

# notifications.telegram.validateToken()

Validate if the token is valid

### Arguments

* **TELEGRAM_BOT_TOKEN** telegram bot token

### Exit codes

* **0**: If token is valid
* **1**: If token is not valid

### Output on stdout

* Token is invalid.

### Example

```bash
validateToken
```

