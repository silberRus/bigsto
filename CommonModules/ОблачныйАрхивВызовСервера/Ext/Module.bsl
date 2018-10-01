﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "ОблачныйАрхив".
// ОбщийМодуль.ОблачныйАрхивВызовСервера.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Интеграция подсистем библиотеки.

#Область ПанельАдминистрированияБСП

// Выполняет изменение способа резервного копирования в форме "ПанельАдминистрированияБСП".
// Вызывается на сервере.
//
// Параметры:
//  СпособРезервногоКопирования - Строка - "На локальном компьютере" или "1С:Облачный архив".
//
Процедура ПанельАдминистрированияБСП_СпособРезервногоКопированияПриИзменении(СпособРезервногоКопирования) Экспорт

	ОблачныйАрхив.ПанельАдминистрированияБСП_СпособРезервногоКопированияПриИзменении(СпособРезервногоКопирования);

КонецПроцедуры

#КонецОбласти

#Область ОблачныйАрхив

// Вызывается после стандартного резервного копирования БСП.
// Активирует Агента резервного копирования, чтобы он отправил указанный файл в облако.
//
// Параметры:
//  ИмяФайла             - Строка - Полное имя файла, который необходимо выгрузить;
//  ОтсрочкаСтартаСекунд - Число - число секунд, после которого начнется выгрузка архива в облако.
//
Процедура ВыгрузитьФайлВОблако(ИмяФайла, ОтсрочкаСтартаСекунд = 30) Экспорт

	ОблачныйАрхив.ВыгрузитьФайлВОблако(ИмяФайла, ОтсрочкаСтартаСекунд);

КонецПроцедуры

#КонецОбласти

#Область ЛогИОтладка

// Функция возвращает значение, надо ли вести подробный журнал регистрации.
//
// Возвращаемое значение:
//   Булево - Истина, если надо вести подробный журнал регистрации, Ложь в противном случае.
//
Функция ВестиПодробныйЖурналРегистрации() Экспорт

	Результат = ОблачныйАрхивПовтИсп.ВестиПодробныйЖурналРегистрации();

	Возврат Результат;

КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ФоновыеЗадания

// Завершает фоновое задание по его идентификатору.
//
// Параметры:
//  ИдентификаторФоновогоЗадания - УникальныйИдентификатор - Идентификатор фонового задания, которое необходимо принудительно завершить.
//
Процедура ОтменитьФоновоеЗадание(ИдентификаторФоновогоЗадания) Экспорт

	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторФоновогоЗадания);

КонецПроцедуры

// Возвращает состояние выполнения фонового задания.
//
// Параметры:
//  ИдентификаторФоновогоЗадания - УникальныйИдентификатор - идентификатор фонового задания.
//
// Возвращаемое значение:
//   Структура - структура с ключами:
//    * Процент;
//    * Текст;
//    * ДополнительныеПараметры - Структура с ключами:
//      ** КодСостояния       - Число (код ошибки) или Строка ("Завершено без ошибок", "Завершено с ошибками");
//      ** ОписаниеРезультата - Неопределено (если "Завершено без ошибок") или текст ошибки.
//
Функция ДлительныеОперацииПрочитатьПрогресс(ИдентификаторФоновогоЗадания) Экспорт

	Возврат ДлительныеОперации.ПрочитатьПрогресс(ИдентификаторФоновогоЗадания);

КонецФункции

// Процедура включает / отключает регламентное задание.
//
// Параметры:
//  Использовать - Булево - Ложь - отключить использование регламентного задания, Истина - включить, иначе - без изменений.
//
Процедура ИзменитьИспользованиеРегламентныхЗаданий(Использовать) Экспорт

	ОблачныйАрхив.ИзменитьИспользованиеРегламентныхЗаданий(Использовать);

КонецПроцедуры

#КонецОбласти

#Область ФункциональныеОпции

// Можно ли технически работать с облачным архивом и включена ли опция, разрешающая работать с этой подсистемой.
// В отличие от ВозможнаРаботаСОблачнымАрхивом() проверяется наличие технической возможности
//  и результат выбора пользователя в форме настроек.
// Это результат функциональной опции "РазрешенаРаботаСОблачнымАрхивом",
//   И доступны нужные роли,
//   И это файловая база,
//   И конфигурация запущена в Windows,
//   И это не веб-клиент и не внешнее соединение.
//
// Возвращаемое значение:
//  Булево - Истина, если возможна и разрешена работа с облачным архивом.
//
Функция РазрешенаРаботаСОблачнымАрхивом() Экспорт

	Результат = ОблачныйАрхивПовтИсп.РазрешенаРаботаСОблачнымАрхивом();

	Возврат Результат;

КонецФункции

// Можно ли технически работать с облачным архивом.
// В отличие от РазрешенаРаботаСОблачнымАрхивом() проверяется только наличие технической возможности работы с облачным архивом.
// Это результат, что
//   доступны нужные роли,
//   И это файловая база,
//   И конфигурация запущена в Windows,
//   И это не веб-клиент и не внешнее соединение.
// 
// Возвращаемое значение:
//  Булево - Истина, если возможна работа с облачным архивом.
//
Функция ВозможнаРаботаСОблачнымАрхивом() Экспорт

	Результат = ОблачныйАрхивПовтИсп.ВозможнаРаботаСОблачнымАрхивом();

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область РаботаСХранилищемЗначений

// Возвращает значение настроек "НастройкиОблачногоАрхива". Написана отдельной функцией специально,
//  чтобы было можно вызвать так:
// МодульСервер = ОбщегоНазначения.ОбщийМодуль("ОблачныйАрхив");
// МодульСервер.НастройкиОблачногоАрхива(...);
// В противном случае, если подсистема не внедрена, то на код ХранилищаНастроек.НастройкиОблачногоАрхива.Загрузить("...")
//  будет выдавать ошибки синтаксический анализатор конфигуратора.
//
// Параметры:
//  КлючОбъекта  - Строка, Структура - КлючОбъекта или Структура:
//      * Ключ - Строка - КлючОбъекта;
//      * Значение - Строка - КлючНастроек.
//  КлючНастроек - Строка или Неопределено - ключ настроек.
//
// Возвращаемое значение:
//  Произвольный - результат получения настроек.
//
Функция ПолучитьНастройкиОблачногоАрхива(КлючОбъекта, КлючНастроек = Неопределено) Экспорт

	Результат = ОблачныйАрхив.ПолучитьНастройкиОблачногоАрхива(КлючОбъекта, КлючНастроек);
	ОблачныйАрхив.ПодготовитьНастройкиОблачногоАрхива(Результат);

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область ПриНачалеРаботыСистемы

// Процедура вызывается из модуля управляемого приложения,
//  затем ОблачныйАрхивКлиент.ПриНачалеРаботыСистемы,
//  затем ОблачныйАрхивВызовСервера.ПриНачалеРаботыСистемы,
//  затем ОблачныйАрхив.ПриНачалеРаботыСистемы,
//  затем ОблачныйАрхивПереопределяемый.ПриНачалеРаботыСистемы.
//
Процедура ПриНачалеРаботыСистемы() Экспорт

	ОблачныйАрхив.ПриНачалеРаботыСистемы();

КонецПроцедуры

#КонецОбласти

#Область Расписание

// Функция рассчитывает расписание создания резервных копий по данным регистра сведений "НастройкиОблачногоАрхиваНаЛокальномКомпьютере"
//  и заполняет список значений, который будет потом сохранен в глобальной переменной
//  ПараметрыПриложения["ИнтернетПоддержкаПользователей.ОблачныйАрхив.РасписаниеСозданияРезервныхКопий"].
//
// Параметры:
//  ВремяНачала - Дата - дата, от которой плюс 12 часов надо увидеть расписания создания резервных копий.
//
// Возвращаемое значение:
//   СписокЗначений - Список значений с параметрами:
//    * Представление - Строка - ИмяКомпьютера, где должно сработать расписание;
//    * Значение      - Дата - дата выполнения расписания.
//
Функция ПолучитьРасписаниеСозданияРезервныхКопий(ВремяНачала) Экспорт

	Результат = ОблачныйАрхив.ПолучитьРасписаниеСозданияРезервныхКопий(ВремяНачала);

	Возврат Результат;

КонецФункции

#КонецОбласти

#КонецОбласти

