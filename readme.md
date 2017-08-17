# Справочник регионов

## Проверки

* Вызов get /regions возвращает "200 OK"
* В теле ответа возвращается валидный JSON
* Страна с идентификатором 113 называется "Россия"
* Регион России с идентификатором 2 называется "Санкт-Петербург"

# Поиск работодателя "Новые Облачные Технологии", в стране "Россия"

## Предзапросы

* Найти идентификатор страны "Россия" в справочнике регионов

## Проверки
* Вызов get /employers возвращает "200 OK"
* В теле ответа возвращается валидный JSON
* Поиск находит работодателя с названием "Новые Облачные Технологии", в стране Россия

# Поиск вакансии "QA Automation Engineer", у работодателя "Новые Облачные технологии" в регионе "Санкт-Петербург"

# Предзапросы

* Найти идентификатор региона "Санкт-Петербург" и страны "Россия" в справочнике регионов
* Найти идентификатор работодателя "Новые Облачные технологии" в стране "Россия"

# Проверки

* Вызов get /vacancies возвращает "200 OK"
* В теле ответа возвращается валидный JSON
* Поиск находит вакансию "QA Automation Engineer", у работодателя Новые Облачные технологии в Санкт-Петербурге
