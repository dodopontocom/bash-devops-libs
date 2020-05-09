#!/bin/bash

# Verify Dependencies
checkBins curl || return ${?}
checkVars SLACK_BOT_TOKEN || return ${?}

# @description Send a Slack message via Slack bot
# @description Check Slack documentation to 
#   Create a App and a user bot then Generating an authorization token
#   Also how to create a workspace and add the bot to a channel 
#   [Slack API basics](https://api.slack.com/authentication/basics)
# @arg $SLACK_BOT_TOKEN slack bot token
# @arg $channel slack workspace channel name
# @arg $message message content
# @exitcode 0 Message is sent
# @exitcode 1 Error to send the message
# @example
#   sendMessageToChannel <channel> <message>
function sendMessageToChannel() {

    getArgs "channel message"

    slack_api_url="https://slack.com/api/chat.postMessage"
    
    # Send Slack Notification
    curl -X POST -H 'Authorization: Bearer '"${SLACK_BOT_TOKEN}" \
    -H 'Content-type: application/json; charset=utf-8' \
    --data '{"channel":'\""${channel}"\"',"text":'\""${message}"\"'}' ${slack_api_url}
    #--data '{"channel":'"${channel}"',"text":'"${message}"'}' ${slack_api_url} &> /dev/null
    exitOnError "Error while trying to use telegram api to send the message."

}
