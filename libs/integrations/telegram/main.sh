#!/bin/bash

# Verify Dependencies
checkBins curl jq || return ${?}
checkVars TELEGRAM_BOT_TOKEN || return ${?}

telegram_api_url="https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}"

# @description Send a Telegram message via Telegram bot
# @description Check Telegram documentation to [Create a bot and Generating an authorization token](https://core.telegram.org/bots#6-botfather)
# @arg $TELEGRAM_BOT_TOKEN telegram bot token
# @arg $TELEGRAM_NOTIFICATION_ID user receiver telegram id
# @arg $message message content
# @exitcode 0 Message is sent
# @exitcode 1 Error to send the message
# @example
#   sendMessage <TELEGRAM_NOTIFICATION_ID> <message>
function sendMessage() {

    getArgs "TELEGRAM_NOTIFICATION_ID message"
    
    # Send Telegram Notification
    curl -X POST \
                -d chat_id=${TELEGRAM_NOTIFICATION_ID} \
                -d text="${message}" \
                ${telegram_api_url}/sendMessage &> /dev/null
    exitOnError "Error while trying to use telegram api to send the message."

}

# @description Validate if the token is valid
# @arg $TELEGRAM_BOT_TOKEN telegram bot token
# @exitcode 0 If token is valid
# @exitcode 1 If token is not valid
# @stdout Token is invalid.
# @example 
#   validateToken <TELEGRAM_BOT_TOKEN>
function validateToken() {

    local _result _status
    _result=0
    _status=$(curl --silent "${telegram_api_url}/getMe" | jq '.ok')
    if [[ "${_status}" == "false" ]]; then
        echoWarn "Token is invalid."
        _result=1
    fi
    return ${_result}
}
