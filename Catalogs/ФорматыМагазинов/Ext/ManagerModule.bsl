﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов


// Получает формат магазина, если формат один в справочнике
//
// Возвращаемое значение:
// СправочникСсылка.ФорматыМагазинов - Найденный формат магазина
// СправочникСсылка.ПустаяСсылка - если форматов нет или больше одного
//
Функция ПолучитьФорматМагазинаПоУмолчанию() Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
	|	ФорматыМагазинов.Ссылка КАК ФорматМагазина
	|ИЗ
	|	Справочник.ФорматыМагазинов КАК ФорматыМагазинов
	|ГДЕ
	|	(НЕ ФорматыМагазинов.ЭтоГруппа)
	|	И (НЕ ФорматыМагазинов.ПометкаУдаления)");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() И Выборка.Количество() = 1 Тогда
		ФорматМагазина = Выборка.ФорматМагазина;
	Иначе
		ФорматМагазина = Справочники.ФорматыМагазинов.ПустаяСсылка();
	КонецЕсли;
	
	Возврат ФорматМагазина;

КонецФункции

// Формирует текст запроса для временной таблицы текущих форматов магазинов и входящих в них складов
//
// Возвращаемое значение:
// Строка - Текст запроса
//
Функция ТекстЗапросаВтФорматыСкладов(ОтбиратьСклады = Истина) Экспорт
	
	Если ОтбиратьСклады Тогда
		
		ТекстЗапроса =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ТаблицаФорматы.Склад          КАК Склад,
			|	ТаблицаФорматы.ФорматМагазина КАК ФорматМагазина
			|ПОМЕСТИТЬ ВтФорматыСкладов
			|ИЗ
			|	РегистрСведений.ИсторияИзмененияФорматовМагазинов.СрезПоследних(,
			|		Склад В(
			|			ВЫБРАТЬ РАЗЛИЧНЫЕ
			|				ТаблицаСклады.Склад
			|			ИЗ
			|				ВтТовары КАК ТаблицаСклады)
			|		{Склад.* КАК Склад}) КАК ТаблицаФорматы
			|ГДЕ
			|	ТаблицаФорматы.ФорматМагазина <> ЗНАЧЕНИЕ(Справочник.ФорматыМагазинов.ПустаяСсылка)
			|ИНДЕКСИРОВАТЬ ПО
			|	Склад
			|;
			|
			|/////////////////////////////////////////////////
			|";
			
	Иначе
		
		ТекстЗапроса =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ТаблицаФорматы.Склад          КАК Склад,
			|	ТаблицаФорматы.ФорматМагазина КАК ФорматМагазина
			|ПОМЕСТИТЬ ВтФорматыСкладов
			|ИЗ
			|	РегистрСведений.ИсторияИзмененияФорматовМагазинов.СрезПоследних(,
			|		{Склад.* КАК Склад}) КАК ТаблицаФорматы
			|ГДЕ
			|	ТаблицаФорматы.ФорматМагазина <> ЗНАЧЕНИЕ(Справочник.ФорматыМагазинов.ПустаяСсылка)
			|ИНДЕКСИРОВАТЬ ПО
			|	Склад
			|;
			|
			|/////////////////////////////////////////////////
			|";
			
	КонецЕсли;
	
	Возврат ТекстЗапроса;

КонецФункции

// Получает блокируемые реквизиты объекта
//
// Возвращаемое значение:
//	Массив - имена реквизитов объекта
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт

	Результат = Новый Массив;
	Результат.Добавить("РозничныйВидЦены");
	
	Возврат Результат;

КонецФункции

// Получает список складов нужного формата
//
// Параметры:
//	Формат - СправочникСсылка.ФорматыМагазинов - формат магазина по которому отбираются склады
// Возвращаемое значение:
//	Массив - массив ссылок складов
Функция СкладыФормата(Формат) Экспорт
	
	СкладыФормата = Новый Массив();
	Если ЗначениеЗаполнено(Формат) Тогда
		
		Запрос = Новый Запрос();
		Запрос.Текст =
			"ВЫБРАТЬ
			|	Таблица.Склад КАК Ссылка
			|ИЗ
			|	РегистрСведений.ИсторияИзмененияФорматовМагазинов.СрезПоследних() КАК Таблица
			|ГДЕ
			|	Таблица.ФорматМагазина = &Формат";
		Запрос.УстановитьПараметр("Формат", Формат);
		СкладыФормата = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
		
	КонецЕсли;
	
	Возврат СкладыФормата;
	
КонецФункции

#КонецОбласти

#КонецЕсли