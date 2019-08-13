library('telegram.bot')
updater <- Updater(token='TOKEN')

updates <- updater$bot$getUpdates()

# start_text <- function(bot, update) {
#   bot$sendMessage(chat_id = update$message$chat_id, text='Nothing to see here')
# }

dispatcher <- updater$dispatcher
#start_handler <- CommandHandler('start', start_text) #если пришла команда старт - запусти команду старт текст



pripiska_detector <- function(text) {
  if (grepl(":=", text)) return(paste0(text,"\nРазмахался тут своей приписькой!"))   
}

pripiska_answer <- function(bot, update) {
  reply<-pripiska_detector(update$message$text)
  if(!is.null(reply))  bot$sendMessage(chat_id = update$message$chat_id, text = reply)
}

replies_ <- c('С точки зрения банальной эрудиции мы не можем контролировать тенденции парадоксальных эмоций', 'Ух ты! И че?', 'Multiple exclamation marks are a sure sign of a diseased mind', 'Не шуми, все спят')

exclamation_detector <- function(text) {
 if (sample(3, 1)==1) {
  if (grepl('!', text)) return(paste(text, sample(replies, 1), sep="\n"))
 }
}

exclamation_answer <- function(bot, update) {
  reply <- exclamation_detector(update$message$text)
  if(!is.null(reply))  bot$sendMessage(chat_id = update$message$chat_id, text = reply)
}


banned <- function(bot, update) {
  if (sample(2, 1)==1) bot$sendMessage(chat_id = update$message$chat_id, text = sprintf('%s забанен по причине: пидор', update$message$from_user$id))
}



pripiska_handler <- MessageHandler(pripiska_answer, MessageFilters$text)
exclamation_handler <- MessageHandler(exclamation_answer, MessageFilters$text)
banned_handler <- MessageHandler(banned, MessageFilters$text)

dispatcher$add_handler(pripiska_handler) #добавить хэндлер в диспетчер
dispatcher$add_handler(exclamation_handler)
dispatcher$add_handler(banned_handler)

updater$start_polling()

#объекты R6 класса - похожи на ООП в питоне





