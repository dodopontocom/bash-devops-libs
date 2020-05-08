#!/bin/bash

# Verify Dependencies
checkBins curl || return ${?}
checkVars TELEGRAM_BOT_TOKEN TELEGRAM_NOTIFICATION_ID || return ${?}

# @description Send a Telegram message via Telegram bot
# @description Check Telegram documentation to [Create a bot and Generating an authorization token](https://core.telegram.org/bots#6-botfather)
# @arg $TELEGRAM_BOT_TOKEN telegram bot token
# @arg $TELEGRAM_NOTIFICATION_ID user receiver telegram id
# @arg $TELEGRAM_MESSAGE message content
# @exitcode 0 Message is sent
# @exitcode 1 Error to send the message
# @example
#   sendMessage <TELEGRAM_BOT_TOKEN> <TELEGRAM_NOTIFICATION_ID> <TELEGRAM_MESSAGE>
function sendMessage() {

    getArgs "TELEGRAM_BOT_TOKEN TELEGRAM_NOTIFICATION_ID TELEGRAM_MESSAGE"
    
    # Send Telegram Notification
    curl -X POST \
                -d chat_id=${TELEGRAM_NOTIFICATION_ID} \
                -d text="${TELEGRAM_MESSAGE}" \
                https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage
    exitOnError "Error while trying to use telegram api to send the message."

}