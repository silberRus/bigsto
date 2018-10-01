﻿
#Область СлужебныйПрограммныйИнтерфейс

// Конвертирует дату из формата UnixTime в тип Дата.
// Параметры:
//   Источник - Число - число в формате UnixTime, например 1405955187848899.
//
Функция ДатаИзUnixTime(Источник) Экспорт
	
	Возврат МестноеВремя(Дата(1970, 1, 1, 0 ,0, 0) + Источник / 1000)
	
КонецФункции

// Подготовка строки идентификатора для сервиса, "0" если не заполнено.
//
// Параметры:
//   Значение - Строка - ИНН, КПП юридического лица.
//
Функция ФорматИдентификатора(Знач Значение) Экспорт
	
	Значение = СокрЛП(Значение);
	Если ПустаяСтрока(Значение) Тогда
		Значение = "0";
	КонецЕсли;
	
	Возврат Значение;
		
КонецФункции

// Описание результата выполнения команды сервиса.
//
// Возвращаемое значение:
//   Структура - структура для заполнения результата:
//     * КодСостояния - Строка - код состояния ответа HTTP-сервера, например "200".
//     * Данные - Строка, Массив, Структура - полученные данные ответа.
//     * ТекстОшибки - Строка - текст ошибки.
//     * ПодробныйТекстОшибки - Строка - подробный текст ошибки.
//
Функция ОписаниеРезультатаКомандыСервиса() Экспорт
	
	// Структура ответа HTTP-сервера.
	Результат = Новый Структура;
	Результат.Вставить("КодСостояния"); // Код состояния ответа HTTP-сервера.
	Результат.Вставить("Данные");       // Полученные данные ответа.
	Результат.Вставить("ТекстОшибки");  // Текст ошибки ответа.
	Результат.Вставить("ПодробныйТекстОшибки"); // Подробный текст ошибки ответа.
	
	Возврат Результат;

КонецФункции

#КонецОбласти