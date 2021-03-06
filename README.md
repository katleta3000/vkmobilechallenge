# VKChallenge

## Архитектура
Во избежания холиварных тем типа CleanSwift, VIPER и реактивных подходов была использована архитектура на базе MVC.
DI реализован через сервис-локатор. Данные прокидываются и хранятся в модели. Есть одно наружение – в PostView (не хватило времени сделать красиво).
Используется следующий flow: View обрабатывает userInteraction, Controller запрашивает данные у репозитория (Service), далее формируются модели для отображения (PresentationModel), далее Controller обновляет layout View с помощью модели отображения.

## Реализованные фичи
- Авторизация через VKSdk
- Получение userId, запрос и вывод аватара пользователя
- Вывод новостной ленты, фильтр по friends и groups
- Вывод заблокированных и удалённых пользователей
- Pull-to-refresh
- Infinite скролл (очень плавный)
- Кеширование на уровне URLSession
- Вывод постов с текстом и изображениями
- Обрезание поста в случае текста, длина которого > 8 строк
- Анимированное открытие поста (как в Instagram, в нативной реализации VK App отстуствует :-))
- Очень плавный скролл, подзагрузка данных на лету

## Known issues
- Время постов выводится не совсем так как в дизайне. Сейчас используется вывод полного имени месяца, можно выводить в формате MMM и вырезать точку (на ru-локали, она есть)
- Не поддерживаются все виды вложений
- Ссылки не визуализируются
- Нет поиска (к сожалению, не хватило времени, чтобы сделать хорошо). Показалось также что это самая непродуманная часть – по её реализовации очень много вопросов (минимальная строка поиска, синхронизация поиска оффлайн и онлайн постов и т.д.)
- Для 320px (iPhone5s и iPhone4s) по-хорошему нужно ресайзить нижний бар – выглядит он не очень красиво
- Pull-to-refresh реализован на базе UIRefreshControl и иногда есть ситуации, когда он "дёргается"
- Не обработано много сценариев ошибок (VKSdk, ошибки сетевых запросов и т.д.) – проработан в основном только golden path
- Местами есть magic numbers (по-хорошему, нужно было выделить единую базу констант между View и PresentationModel)
- Нет правильных красивых теней под плашкой постов (не хватило времени)
