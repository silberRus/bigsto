﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интеграция с 1С:Документооборотом"
// Модуль ИнтеграцияС1СДокументооборотПовтИсп, сервер, повт. использование
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

//Получает настройки базы Документооборота.
//Возвращает структуру настроек Документооборота
Функция ПолучитьНастройки() Экспорт
	
	Возврат ИнтеграцияС1СДокументооборотВызовСервера.ПолучитьНастройки();
	
КонецФункции

// Создает прокси веб-сервиса Документооборота. В случае ошибки при создании вызывается исключение.
//
// Возвращаемое значение:
//	WSПрокси - Прокси веб-сервиса
//
Функция ПолучитьПрокси() Экспорт
	
	Возврат ИнтеграцияС1СДокументооборот.ПолучитьПрокси();
	
КонецФункции

//Проверяет доступность функционала версии сервиса.
//Параметры:
//	ВерсияСервиса - версия сервиса, содержащая нужный функционал
//Возвращает:
//	Признак доступности функционала версии сервиса
Функция ДоступенФункционалВерсииСервиса(ВерсияСервиса = "", Оптимистично = Ложь) Экспорт
	
	Возврат ИнтеграцияС1СДокументооборот.ДоступенФункционалВерсииСервиса(ВерсияСервиса, Оптимистично);
	
КонецФункции

// Возвращает таблицу данных о шаблонах бизнес-процессов по типу объекта.
//
Функция ШаблоныПроцессовОбъекта(ТипОбъекта) Экспорт
	
	Шаблоны = Новый ТаблицаЗначений;
	Шаблоны.Колонки.Добавить("Наименование");
	Шаблоны.Колонки.Добавить("Тип");
	Шаблоны.Колонки.Добавить("ID");
	
	Запрос = Новый Запрос;
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	НастройкиЗаполнения.ЗначениеРеквизитаДокументооборота КАК Имя,
		|	НастройкиЗаполнения.ИдентификаторЗначенияРеквизита КАК ID,
		|	НастройкиЗаполнения.ТипЗначенияРеквизита КАК Тип
		|ИЗ
		|	Справочник.ПравилаИнтеграцииС1СДокументооборотом.ПравилаЗаполненияРеквизитовПриВыгрузке КАК НастройкиЗаполнения
		|ГДЕ
		|	НастройкиЗаполнения.ИмяРеквизитаОбъектаДокументооборота = ""documentType""
		|	И НастройкиЗаполнения.ТипЗначенияРеквизита ПОДОБНО ""%DocumentType""
		|	И НастройкиЗаполнения.Ссылка.ТипОбъектаПотребителя = &ТипОбъекта";
	Запрос.УстановитьПараметр("ТипОбъекта", ТипОбъекта);
	
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		
		ВидДокумента = Результат.Выбрать();
		ВидДокумента.Следующий();
		
		Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
		Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMGetBusinessProcessTemplatesRequest");
		
		ВидДокументаXDTO = ИнтеграцияС1СДокументооборот.СоздатьObjectID(Прокси, ВидДокумента.ID, ВидДокумента.Тип);
		
		Запрос.businessProcessTargetId = ВидДокументаXDTO;
		
		Результат = Прокси.execute(Запрос);
		ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Результат);
		
		Для Каждого СтрокаXDTO Из Результат.businessProcessTemplates Цикл
			Строка = Шаблоны.Добавить();
			Строка.Наименование = СтрокаXDTO.name;
			Строка.Тип = СтрокаXDTO.objectId.type;
			Строка.ID = СтрокаXDTO.objectId.id;
		КонецЦикла;
		
		Шаблоны.Сортировать("Наименование ВОЗР");
		
	КонецЕсли;
	
	Возврат Шаблоны;
	
КонецФункции

//Возвращает идетификатор текущей базы данных, если он есть. Если нет, создает его и возвращает.
//
Функция ИдентификаторБазыДанных() Экспорт
	
	ЭтотУзел = ПланыОбмена.ИнтеграцияС1СДокументооборотом.ЭтотУзел();
	Если СтрДлина(ЭтотУзел.Наименование) <> 36 Тогда
		ЭтотУзелОбъект = ЭтотУзел.ПолучитьОбъект();
		ЭтотУзелОбъект.Наименование = Строка(Новый УникальныйИдентификатор);
		ЭтотУзелОбъект.Код = 0;
		ЭтотУзелОбъект.ОбменДанными.Загрузка = Истина;
		ЭтотУзелОбъект.Записать();
	КонецЕсли;
	
	Возврат ЭтотУзел.Наименование;
	
КонецФункции

//Возвращает узел Документооборота. В случае отсутствия узел будет создан.
//
Функция УзелДокументооборота() Экспорт
	
	ЭтотУзел = ПланыОбмена.ИнтеграцияС1СДокументооборотом.ЭтотУзел();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИнтеграцияС1СДокументооборотом.Ссылка,
		|	ИнтеграцияС1СДокументооборотом.Наименование
		|ИЗ
		|	ПланОбмена.ИнтеграцияС1СДокументооборотом КАК ИнтеграцияС1СДокументооборотом
		|ГДЕ
		|	ИнтеграцияС1СДокументооборотом.Ссылка <> &ЭтотУзел";
		
	Запрос.УстановитьПараметр("ЭтотУзел", ЭтотУзел);
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Узел1СДокументооборота = ПланыОбмена.ИнтеграцияС1СДокументооборотом.СоздатьУзел();
		Узел1СДокументооборота.Наименование = НСтр("ru='1С:Документооборот'");
		Узел1СДокументооборота.Код = 1;
		Узел1СДокументооборота.Записать();
		Узел = Узел1СДокументооборота.Ссылка;
	Иначе
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Узел = Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Узел;
	
КонецФункции

// Получает текущего пользователя 1С:Документооборота.
//
// Возвращаемое значение:
//   ОбъектXDTO типа DMUser или Неопределено.
//
Функция ТекущийПользовательДокументооборота() Экспорт
	
	Возврат ИнтеграцияС1СДокументооборот.ТекущийПользовательДокументооборота();
	
КонецФункции

// Возвращает массив типов объектов ИС, поддерживающих бесшовную интеграцию.
//
Функция ТипыОбъектовПоддерживающихИнтеграцию() Экспорт
	
	Типы = Новый Массив;
	
	Команды = Новый Массив;
	Команды.Добавить(Метаданные.ОбщиеКоманды.ИнтеграцияС1СДокументооборот);
	Команды.Добавить(Метаданные.ОбщиеКоманды.ИнтеграцияС1СДокументооборотПрисоединенныеФайлы);
	Команды.Добавить(Метаданные.ОбщиеКоманды.ИнтеграцияС1СДокументооборотСоздатьБизнесПроцесс);
	Команды.Добавить(Метаданные.ОбщиеКоманды.ИнтеграцияС1СДокументооборотСоздатьПисьмо);
	Команды.Добавить(Метаданные.ОбщиеКоманды.ИнтеграцияС1СДокументооборотСоздатьПроцессСогласования);
	
	Для Каждого Команда Из Команды Цикл
		
		ТипыПараметраКоманды = Команда.ТипПараметраКоманды.Типы();
		
		Для Каждого Тип Из ТипыПараметраКоманды Цикл
			
			Если Типы.Найти(Тип) = Неопределено Тогда
				Типы.Добавить(Тип);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	ИнтеграцияС1СДокументооборотПереопределяемый.
		ПриОпределенииТиповОбъектовПоддерживающихИнтеграцию(Типы);
	
	Возврат Типы;
	
КонецФункции

// Возвращает массив типов объектов ИС, для которых заданы правила интеграции.
//
Функция ПолучитьТипыОбъектовСПравиламиИнтеграции(ТипыОбъектовДО) Экспорт
	
	Результат = Новый Массив;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТипОбъектаПотребителя КАК ТипСтрокой
		|ИЗ
		|	Справочник.ПравилаИнтеграцииС1СДокументооборотом КАК Правила
		|ГДЕ
		|	НЕ Правила.ПометкаУдаления
		|	И Правила.ТипОбъектаДокументооборота В (&ТипыОбъектовДО)");
	Запрос.УстановитьПараметр("ТипыОбъектовДО", Новый Массив);
	МассивСтрок = СтрРазделить(ТипыОбъектовДО, ",", Ложь);
	Для Каждого Строка Из МассивСтрок Цикл
		Запрос.Параметры.ТипыОбъектовДО.Добавить(СокрЛП(Строка));
	КонецЦикла;
		
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если СтрНачинаетсяС(Выборка.ТипСтрокой, "Справочник.") Тогда
			ТипСтрокой = "СправочникСсылка." + Сред(Выборка.ТипСтрокой,
				СтрДлина("Справочник.") + 1);
		ИначеЕсли СтрНачинаетсяС(Выборка.ТипСтрокой, "Документ.") Тогда
			ТипСтрокой = "ДокументСсылка." + Сред(Выборка.ТипСтрокой,
				СтрДлина("Документ.") + 1);
		ИначеЕсли СтрНачинаетсяС(Выборка.ТипСтрокой, "ПланСчетов.") Тогда
			ТипСтрокой = "ПланСчетовСсылка." + Сред(Выборка.ТипСтрокой,
				СтрДлина("ПланСчетов.") + 1);
		ИначеЕсли СтрНачинаетсяС(Выборка.ТипСтрокой, "ПланВидовРасчета.") Тогда
			ТипСтрокой = "ПланВидовРасчетаСсылка." + Сред(Выборка.ТипСтрокой,
				СтрДлина("ПланВидовРасчета.") + 1);
		ИначеЕсли СтрНачинаетсяС(Выборка.ТипСтрокой, "ПланВидовХарактеристик.") Тогда
			ТипСтрокой = "ПланВидовХарактеристикСсылка." + Сред(Выборка.ТипСтрокой,
				СтрДлина("ПланВидовХарактеристик.") + 1);
		ИначеЕсли СтрНачинаетсяС(Выборка.ТипСтрокой, "БизнесПроцесс.") Тогда
			ТипСтрокой = "БизнесПроцессСсылка." + Сред(Выборка.ТипСтрокой,
				СтрДлина("БизнесПроцесс.") + 1);
		ИначеЕсли СтрНачинаетсяС(Выборка.ТипСтрокой, "Задача.") Тогда
			ТипСтрокой = "ЗадачаСсылка." + Сред(Выборка.ТипСтрокой, СтрДлина("Задача.") + 1);
		Иначе
			Продолжить;
		КонецЕсли;
		
		// Устаревшие типы в правилах не должны приводить к неработоспособности связей.
		Попытка
			ТипОбъекта = Тип(ТипСтрокой);
		Исключение
			Продолжить;
		КонецПопытки;
		
		Если Не ПравоДоступа("Чтение", Метаданные.НайтиПоТипу(ТипОбъекта)) Тогда
			Продолжить;
		КонецЕсли;
		
		Результат.Добавить(ТипОбъекта);
		
	КонецЦикла;
		
	Возврат Результат;
	
КонецФункции

// Возвращает Истина, если используется термин "Корреспонденты".
//
Функция ИспользоватьТерминКорреспонденты() Экспорт
	
	Возврат Не ДоступенФункционалВерсииСервиса("2.1.0.1", Истина);
	
КонецФункции

#КонецОбласти
