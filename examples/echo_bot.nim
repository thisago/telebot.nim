import telebot, asyncdispatch, logging, options
from strutils import strip

var L = newConsoleLogger(fmtStr="$levelname, [$time] ")
addHandler(L)

const API_KEY = slurp("secret.key").strip()

proc updateHandler(b: Telebot, u: Update) {.async.} =
  if not u.message.isSome:
    return
  var response = u.message.get
  if response.text.isSome:
    let text = response.text.get
    discard await b.sendMessage(response.chat.id, text, parseMode = "markdown", disableNotification = true, replyToMessageId = response.messageId)


proc greatingHandler(b: Telebot, c: Command) {.async.} =
  var message = newMessage(c.message.chat.id, "hello " & c.message.fromUser.get().firstName)
  message.disableNotification = true
  message.replyToMessageId = c.message.messageId
  message.parseMode = "markdown"
  discard b.send(message)

when isMainModule:
  let bot = newTeleBot(API_KEY)

  bot.onUpdate(updateHandler)
  bot.onCommand("hello", greatingHandler)
  bot.poll(timeout=300)
