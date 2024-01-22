# Используем официальный образ Ruby
FROM ruby:3.1.4

# Устанавливаем зависимости
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем Gemfile и Gemfile.lock и устанавливаем зависимости
COPY Gemfile Gemfile.lock /app/
RUN bundle install

# Копируем остальные файлы приложения
COPY . /app/

# Запускаем миграции при запуске контейнера
CMD ["sh", "-c", "bundle exec rails db:create db:migrate && bundle exec rails server -b 0.0.0.0"]

