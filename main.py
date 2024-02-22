import telebot
from telebot import types

bot = telebot.TeleBot('6663315211:AAFIdDTm0iief_r901XzICqvdh2wYKdcjzg')


@bot.message_handler(commands=['start'])
def start(message):
    keyboard = types.ReplyKeyboardMarkup(row_width=1, resize_keyboard=True, one_time_keyboard=True)

    button_word = types.KeyboardButton('Слово')
    button_learned = types.KeyboardButton('Выучено')
    button_my_rating = types.KeyboardButton('Мой рейтинг')
    button_dictionary = types.KeyboardButton('Словарь')
    button_help = types.KeyboardButton('Помощь')

    keyboard.add(button_word, button_learned, button_my_rating, button_dictionary, button_help)

    bot.send_message(message.chat.id, "Привет, {}! Нажми кнопку.".format(message.from_user.first_name),
                     reply_markup=keyboard)


# Обработчик текстовых сообщений
@bot.message_handler(func=lambda message: True)
def text(message):
    if message.text == 'Помощь':
        bot.send_message(message.chat.id, "1) Кнопка 'Cлово' выводит новое слово для изучения;\n"
                                          "2) Кнопка 'Выучено' выводит выученные слова;\n"
                                          "3) Кнопка 'Мой рейтинг' выводит рейтинг в котором ведется счет выученных "
                                          "слов после чего выстраивайтся рейтинг лучших учеников;\n"
                                          "4) Кнопка 'Словарь' выводит словарь всех слов;")


if __name__ == "__main__":
    bot.polling(none_stop=True)