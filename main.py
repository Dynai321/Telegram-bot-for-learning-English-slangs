import telebot
from telebot import types
import psycopg2

bot = telebot.TeleBot('6663315211:AAFIdDTm0iief_r901XzICqvdh2wYKdcjzg')

conn = psycopg2.connect(
    dbname='TelegramBotDB',
    user='postgres',
    password='1234',
    host='localhost',
    port='5432'
)
cursor = conn.cursor()


@bot.message_handler(commands=['start'])
def start(message):
    cursor.execute('SELECT * FROM users WHERE id=%s', (message.from_user.id,))
    user = cursor.fetchone()

    if not user:
        cursor.execute('INSERT INTO users (id, username) VALUES (%s, %s)',
                       (message.from_user.id, message.from_user.username))
        conn.commit()

    keyboard = types.ReplyKeyboardMarkup(row_width=2, resize_keyboard=True, one_time_keyboard=True)
    button_word = types.KeyboardButton('Слово')
    button_learned = types.KeyboardButton('Выучено')
    button_my_rating = types.KeyboardButton('Мой рейтинг')
    button_dictionary = types.KeyboardButton('Словарь')
    button_help = types.KeyboardButton('Помощь')
    keyboard.add(button_word, button_learned, button_my_rating, button_dictionary, button_help)
    bot.send_message(message.chat.id, "Привет, {}! Нажми кнопку.".format(message.from_user.first_name),
                     reply_markup=keyboard)


@bot.message_handler(func=lambda message: True)
def text(message):
    if message.text == 'Помощь':
        bot.send_message(message.chat.id, "1) Кнопка 'Слово' выводит новое слово для изучения;\n"
                                          "2) Кнопка 'Выучено' выводит выученные слова;\n"
                                          "3) Кнопка 'Мой рейтинг' выводит рейтинг в котором ведется счет выученных "
                                          "слов после чего выстраивайтся рейтинг лучших учеников;\n"
                                          "4) Кнопка 'Словарь' выводит словарь всех слов;")
    elif message.text == 'Слово':
        cursor.execute('SELECT slang_word, definition FROM words ORDER BY RANDOM() LIMIT 1')
        result = cursor.fetchone()
        if result:
            slang_word, definition = result
            bot.send_message(message.chat.id, f"Слово: {slang_word}\nОписание: {definition}")


if __name__ == "__main__":
    bot.polling(none_stop=True)

conn.close()