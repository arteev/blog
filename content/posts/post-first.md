---
categories:
  - Blogging
tags:
- HUGO
- Yandex Cloud
- Blogging

title: "Блог на основе генератора статических сайтов Hugo и Яндекс.Облако"
date: 2019-10-19T21:55:19+05:00
draft: false
---

> **Сложность**: средняя **Время**: 2-4 часа

> Необходима банковская карта для [Яндекс.Облако](https://cloud.yandex.ru/)

## Вступление
Итак, настало время создать блог. 
Для этого используем генератов сайтов [HUGO](https://gohugo.io/).
Хостиг будем использовать Яндекс.Облако, в частности сервис [Yandex Object Storage](https://cloud.yandex.ru/services/storage). Стоимость хостинга в месяц эквивалента примерно одна поездка на автобусе и зависит от популярности блога и объема.


Это не полное руководство по настройке и установке.



## Установка и создание проекта

### Установка HUGO
Установить можно несколькими [способами](https://gohugo.io/getting-started/quick-start/), но если увас установлен [Golang](https://golang.org/) и [Git](https://git-scm.com/), то лучше воспользоваться:

```bash
mkdir $HOME/src
cd $HOME/src
git clone https://github.com/gohugoio/hugo.git
cd hugo
go install
```

### Создание проекта для блога

Следуй инструкциям HUGO [QuickStart](https://gohugo.io/getting-started/quick-start/).

```bash
mkdir $HOME/blog
cd $HOME/blog
hugo new site .

```

### Установка темы

Выбери по вкусу [тут](https://themes.gohugo.io/). Мой выбор [hyde](https://github.com/spf13/hyde).

```bash
cd $HOME/blog/themes/
git clone https://github.com/spf13/hyde.git
```
Укажи hyde в качестве темы по умолчанию в файле config.toml. Просто добавьте строку `theme = "hyde"`. Если тема не настроена, то при генерации будет пустая страница.

### Добавление страницы

Добавь контента и проверь что получилось.

```bash
hugo new posts/my-first-post.md
hugo server -D
```
Опция `-D` необходима для того, чтобы HUGO дополнительно генерировал страницы для черновиков.

Отредактируй `content/posts/my-first-post.md`, для проверки открой в браузере адрес, который указала команда `hugo server`.

Вообще всю статику для сайта HUGO  генерирует в каталог `public`.

## Настройки блога

Укажи `baseURL`, `language`, `title`

```toml
baseURL = "URL_твоего_блога"
languageCode = "ru-ru"
title = "Это мог блог"
theme = "hyde"
```

## Deploy

### Настройка 

На этом шаге тебе необходимо [Yandex Object Storage](https://cloud.yandex.ru/services/storage). Надеюсь, что у тебя есть подтвержденный аккаунт Яндекса. Я не буду повторять [инструкцию](https://cloud.yandex.ru/docs/storage/hosting/) с официального сайта, отмечу важные только моменты:

* создайте публичный бакет, также настройте веб-сайт на main page: `index.html` error: `404.html`
* сгенерируйте сайт `hugo`
* исправь `baseURL` параметр в `config.toml` на `http://<имя_бакета>.website.yandexcloud.net` либо на твой конкретный сайт.
* загрузите в бакет сгенерированный сайт из `$HOME/blog/public`
* если у тебя свой сайт, то добавь запись у DNS провайдера `ТВОЙ_САЙТ CNAME ТВОЙ_САЙТ.website.yandexcloud.net`
* открой и проверь в браузере

### Автоматизируй deploy
Для того чтобы вручную через браузер не обновлять твой бакет,воспользуйся 
[FUSE s3fs](https://cloud.yandex.ru/docs/storage/instruments/s3fs).
Загрузка через FUSE показалась мне более простой.

* создай сервисного пользователя с ролью `editor` в Яндекс.Облако
* сгенерируй статически ключ в Яндекс.Облако
* сохрани сгенерированный ключ в `$HOME/.passwd-s3fs` в виде `<ID>:<KEY>`. Сделай права 600 на этот файл.
* установи [FUSE s3fss](https://github.com/s3fs-fuse/s3fs-fuse/wiki/Fuse-Over-Amazon)
* примонтируй `s3fs <имя бакета> /mount/<путь к папке> -o passwd_file=~/.passwd-s3fs \
    -o url=http://storage.yandexcloud.net -o use_path_request_style`
* Копируй: `cp -f -r public/** /mount/<путь к папке>`
* Profit!