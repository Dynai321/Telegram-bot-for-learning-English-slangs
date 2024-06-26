import telebot
from telebot import types
import psycopg2
import time

bot = telebot.TeleBot('6663315211:AAFIdDTm0iief_r901XzICqvdh2wYKdcjzg')

conn = psycopg2.connect(
    dbname='TelegramBotDB',
    user='postgres',
    password='12261556',
    host='localhost',
    port='5432'
)
cursor = conn.cursor()

last_word_button_click = {}
last_word_button_click_time = {}    #И тут


def check_user_exists(user_id):
    cursor.execute('SELECT * FROM users WHERE user_id=%s', (user_id,))
    return cursor.fetchone() is not None

#Закомитить тут

def check_word_button_blocked(user_id):
    if user_id in last_word_button_click_time:
        last_click_time = last_word_button_click_time[user_id]
        current_time = time.time()
        if current_time - last_click_time < 3600:
            return True
    return False


@bot.message_handler(commands=['start'])
def start(message):
    if not check_user_exists(message.from_user.id):
        cursor.execute('INSERT INTO users (user_id, username, rating, rank) VALUES (%s, %s, %s, %s)',
                       (message.from_user.id, message.from_user.username, 0, 'Новичок'))
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
    global new_rank
    if message.text == 'Помощь':
        bot.send_message(message.chat.id, "1) Кнопка 'Слово' выводит новое слово для изучения;\n"
                                          "2) Кнопка 'Выучено' выводит выученные слова;\n"
                                          "3) Кнопка 'Мой рейтинг' выводит рейтинг в котором ведется счет выученных "
                                          "слов после чего выстраивайтся рейтинг лучших учеников;\n"
                                          "4) Кнопка 'Словарь' выводит словарь всех слов;")
        pass


    elif message.text == 'Выучено':

        user_id = message.from_user.id

        if user_id not in last_word_button_click:
            bot.send_message(message.chat.id, "Сначала выберите слово, чтобы его выучить.")

            return

        word_id, slang_word = last_word_button_click[user_id]

        cursor.execute('INSERT INTO learned_words (user_id, word_id) VALUES (%s, %s)', (user_id, word_id))

        conn.commit()

        cursor.execute('UPDATE users SET rating = rating + 1 WHERE user_id = %s', (user_id,))

        conn.commit()

        cursor.execute('SELECT rating, rank FROM users WHERE user_id=%s', (user_id,))

        user_data = cursor.fetchone()

        if user_data:

            rating = user_data[0]

            current_rank = user_data[1]

            new_rank = None

            if rating >= 10 and current_rank != 'Мудрец':

                new_rank = 'Мудрец'

            elif rating >= 5 and current_rank != 'Продвинутый':

                new_rank = 'Продвинутый'

            if new_rank:
                cursor.execute('UPDATE users SET rank = %s WHERE user_id = %s', (new_rank, user_id))

                conn.commit()

                bot.send_message(message.chat.id, f"Поздравляем! Вы достигли нового звания: {new_rank}.")

            bot.send_message(message.chat.id, f"Слово с ID {word_id} добавлено в список выученных.")

            bot.send_message(message.chat.id, "Ваш рейтинг увеличен на 1.")

        # После успешного использования слова "Выучено", удаляем его из словаря last_word_button_click

        del last_word_button_click[user_id]


    elif message.text == 'Слово':

        user_id = message.from_user.id
        if check_word_button_blocked(user_id):
            bot.send_message(message.chat.id, "Кнопка 'Слово' заблокирована. Вы получите новое слово через час.")
            return

        #Закомитить (Сверху)

        cursor.execute('SELECT word_id FROM learned_words WHERE user_id = %s', (user_id,))
        learned_words = cursor.fetchall()
        learned_word_ids = [word[0] for word in learned_words]

        if learned_word_ids:

            cursor.execute(

                'SELECT word_id, slang_word, definition, video_url FROM words WHERE word_id NOT IN %s ORDER BY RANDOM() LIMIT 1',

                (tuple(learned_word_ids),))

            result = cursor.fetchone()

            if result:

                word_id, slang_word, definition, video_url = result

                response_message = f"ID слова: {word_id}\nСлово: {slang_word}\nОписание: {definition}\nURL: {video_url}"

                bot.send_message(message.chat.id, response_message)

                last_word_button_click[user_id] = (word_id, slang_word)

                last_word_button_click_time[user_id] = time.time()    #Закомитить

            else:

                bot.send_message(message.chat.id, "Вы уже выучили все слова из словаря.")


        else:

            cursor.execute(

                'SELECT word_id, slang_word, definition, video_url FROM words ORDER BY RANDOM() LIMIT 1')

            result = cursor.fetchone()

            if result:
                word_id, slang_word, definition, video_url = result

                response_message = f"ID слова: {word_id}\nСлово: {slang_word}\nОписание: {definition}\nURL: {video_url}"

                bot.send_message(message.chat.id, response_message)

                last_word_button_click[user_id] = (word_id, slang_word)

                last_word_button_click_time[user_id] = time.time()   #Закомитить

    elif message.text == "Мой рейтинг":
        user_id = message.from_user.id
        cursor.execute('SELECT rating, rank FROM users WHERE user_id=%s', (user_id,))
        user_info = cursor.fetchone()
        if user_info:
            rating, rank = user_info
            if rating:
                bot.send_message(message.chat.id, f"Ваш рейтинг: {rating}\nВаше звание: {rank or 'Нет звания'}")
            else:
                bot.send_message(message.chat.id, "У вас пока нет рейтинга.")

    elif message.text == 'Словарь':
        user_id = message.from_user.id
        cursor.execute('SELECT words.slang_word, words.definition FROM learned_words '
                       'INNER JOIN words ON learned_words.word_id = words.word_id '
                       'WHERE learned_words.user_id = %s', (user_id,))
        learned_words = cursor.fetchall()
        if learned_words:
            words_list = '\n\n'.join([f'{word[0]}: {word[1]}' for word in learned_words])
            bot.send_message(message.chat.id, f"Вы уже выучили следующие слова:\n\n{words_list}")
        else:
            bot.send_message(message.chat.id, "Вы еще не выучили ни одного слова.")


if __name__ == "__main__":
    bot.polling(none_stop=True)

conn.close()