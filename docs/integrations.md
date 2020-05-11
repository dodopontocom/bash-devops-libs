* [integrations.slack.sendMessageToChannel()](#integrationsslacksendmessagetochannel)
* [integrations.telegram.sendMessage()](#integrationstelegramsendmessage)
* [integrations.telegram.validateToken()](#integrationstelegramvalidatetoken)



# integrations.slack.sendMessageToChannel()

Send message to a Slack channel via bot

Check Slack documentation to create an App and a user bot  
then Generating an authorization token    
Also check how to create a workspace and add the bot to a channel  
[Slack API basics](https://api.slack.com/authentication/basics)  

### Arguments

* **SLACK_BOT_TOKEN** (environment variable): slack bot token
* **channel** (string): workspace channel name
* **message** (string): content

### Exit codes

* **0**: Message is sent
* **1**: Error to send the message

### Example

```bash
sendMessageToChannel <channel> <message>
```




# integrations.telegram.sendMessage()

Send message to a Telegram user/group via bot

Check Telegram documentation to [Create a bot and Generating an authorization token](https://core.telegram.org/bots#6-botfather)

### Arguments

* **TELEGRAM_BOT_TOKEN** (environment variable): telegram bot token
* **TELEGRAM_NOTIFICATION_ID** (environment variable): user receiver telegram id
* **message** (string): content

### Exit codes

* **0**: Message is sent
* **1**: Error to send the message

### Example

```bash
sendMessage <TELEGRAM_NOTIFICATION_ID> <message>
```

# integrations.telegram.validateToken()

Validate if the token is valid

### Arguments

* **TELEGRAM_BOT_TOKEN** (environment variable): telegram bot token

### Exit codes

* **0**: If token is valid
* **1**: If token is not valid

### Output on stdout

* Token is invalid.

### Example

```bash
validateToken
```

