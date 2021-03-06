﻿Функция КодОшибкиНеНайденаСсылка() Возврат 404 КонецФункции
Функция КодОшибкиПлохойЗапрос() Возврат 400 КонецФункции

Функция ТестКлючЗначение(Коллекция)
	
	Текст = "";
	Для каждого Параметр Из Коллекция Цикл 
		Текст = Текст + Параметр.Ключ + ":" + Параметр.Значение + Символы.ПС; 
	КонецЦикла;
	
	Возврат Текст;
	
КонецФункции
Процедура ЛогЗапроса(Запрос, ТелоЭтоФайл = Ложь, Менеджер = Неопределено) Экспорт
	
	Если Менеджер = Неопределено Тогда 
		Менеджер = РегистрыСведений.ЛогЗапросовRest;
	КонецЕсли;
		
	Результат = СтрШаблон(">>%1->%2
					|%3
					|Заголовки: %4
					|Параметры URL: %5
					|Параметры запроса: %6
					|
					|Тело запроса:
					|%7",
			Запрос.HTTPМетод,
			Запрос.HTTPМеОтносительныйURL,
			Запрос.БазовыйURL,
			ТестКлючЗначение(Запрос.Заголовки),
			ТестКлючЗначение(Запрос.ПараметрыURL),
			ТестКлючЗначение(Запрос.ПараметрыЗапроса),
			Запрос.ПолучитьТелоКакСтроку());
			
	Запись = Менеджер.СоздатьМенеджерЗаписи();
	Запись.ИДзапроса = Новый УникальныйИдентификатор;
	Запись.Дата 		= ТекущаяДата(); 
	Запись.СокрТекст 	= Результат;
	Запись.Текст 		= Результат;
	Запись.Записать(); 
	
КонецПроцедуры
Процедура ЛогОтвета(Ответ, ТелоЭтоФайл = Ложь, Менеджер = Неопределено) Экспорт
	
	Если Менеджер = Неопределено Тогда 
		Менеджер = РегистрыСведений.ЛогЗапросовRest;
	КонецЕсли;
		
	Результат = СтрШаблон("<<%1 %2
					|Заголовки: %3
					|
					|Тело ответа:
					|%4",
		Ответ.КодСостояния,
		Ответ.Причина,
		ТестКлючЗначение(Ответ.Заголовки),
		?(ТелоЭтоФайл, " тело это файл не логируется ", Ответ.ПолучитьТелоКакСтроку()));
		
	Запись = Менеджер.СоздатьМенеджерЗаписи();
	Запись.ИДзапроса = Новый УникальныйИдентификатор;
	Запись.Дата 		= ТекущаяДата(); 
	Запись.СокрТекст 	= Результат;
	Запись.Текст 		= Результат;
	Запись.Записать();
	
КонецПроцедуры

Функция Параметр(Запрос, ИмяПараметра, ЭтоОтладка)
	
	Если ЭтоОтладка Тогда
		
		Значение = Неопределено;
		Запрос.Свойство(ИмяПараметра, Значение);
		Возврат Значение;
		
	Иначе
		
		Значение = Запрос.ПараметрыURL.Получить(ИмяПараметра);
		Возврат ?(Значение = Неопределено, Запрос.ПараметрыЗапроса.Получить(ИмяПараметра), Значение);
		
	КонецЕсли;
	
КонецФункции
Функция ПолучитьПоГуиду(Менеджер, guid, стрОшибки = "") Экспорт
	
	Если ПустаяСтрока(guid) Тогда
		стрОшибки = стрОшибки + "Не указан гуид <guid>";
	Иначе
		
		Попытка
			Ид = Новый УникальныйИдентификатор(guid);
		Исключение
			стрОшибки = стрОшибки + СтрШаблон("Не верный формат гуида <?guid> <%1>", Строка(Менеджер));
			Возврат Неопределено;
		КонецПопытки;
		
		Ссылка = Менеджер.ПолучитьСсылку(Ид);
		Попытка
			текОбъект = Ссылка.ПолучитьОбъект();
		Исключение
			текОбъект = Неопределено;
		КонецПопытки;
		
		Если текОбъект = Неопределено Тогда
			стрОшибки = стрОшибки + СтрШаблон("Не найден объект по гуиду <guid = %1> <%2>", guid, Строка(Менеджер));
		Иначе
			Возврат Ссылка;
		КонецЕсли;
		
	КонецЕсли;
	
КонецФункции

Функция РезультатЗапросаJSON(Запрос, Параметры = Неопределено)
	
	// Выполняет переданный запрос и возвращает строку JSON
	//	как массив структур
	
	Если Параметры <> Неопределено Тогда
		Для Каждого Параметр Из Параметры Цикл
			Запрос.УстановитьПараметр(Параметр.Ключ, Параметр.Значение);
		КонецЦикла;
	КонецЕсли;
	
	Возврат w1_Json.JSON36(Запрос.Выполнить().Выгрузить());
	
КонецФункции

Функция ПолучитьЗначениеИзТела(Запрос, Ошибка, ОжидаемыйТип = Неопределено, Менеджеры = Неопределено, ЭтоОтладка = Ложь)
	
	// Распарсивает тело запроса и возвращает значение
	// Ошибка - если произойдет ошибка тогда, вернеттся ответHTTP
	//	если ошибки не будет то вернется распарсенное значение
	//
	// ОжидаемыйТип - тип который должен вернуться, если заполнить и тип не совпадет то будет ошибка
	
	ТекстЗапроса = ?(ЭтоОтладка, Запрос.Тело, Запрос.ПолучитьТелоКакСтроку());
	
	Если ПустаяСтрока(ТекстЗапроса) Тогда
		Возврат ВернутьОтвет(Новый Структура("КодОтвета, Тело", КодОшибкиПлохойЗапрос(), "Не передан запрос"), ЭтоОтладка);
	КонецЕсли;
	
	стрОшибки = "";
	Попытка
		Значение = UnJSON(ТекстЗапроса, ОжидаемыйТип = Тип("Соответствие"),,?(Менеджеры = Неопределено, Неопределено, Новый Структура("Менеджеры", Менеджеры)), стрОшибки);
	Исключение
		Возврат ВернутьОтвет(Новый Структура("КодОтвета, Тело", КодОшибкиПлохойЗапрос(), "Не удалось распарсить переданный запрос"), ЭтоОтладка);
	КонецПопытки;
	
	Если стрОшибки <> "" Тогда
		Ошибка = Истина;
		Возврат ВернутьОтвет(Новый Структура("КодОтвета, Тело", КодОшибкиПлохойЗапрос(), "Ошибка парсера JSON: " + стрОшибки), ЭтоОтладка);
	КонецЕсли;
	
	Если ОжидаемыйТип <> Неопределено И ТипЗнч(Значение) <> ОжидаемыйТип Тогда
		Возврат ВернутьОтвет(Новый Структура("КодОтвета, Тело", КодОшибкиПлохойЗапрос(), "Не верный тип значения, ожидалось " + ОжидаемыйТип), ЭтоОтладка);
	КонецЕсли;
	
	Возврат Значение;
	
КонецФункции

#Область Сущности_rest

Функция ТиповаяСущность(ИмяМенеджер, Поля, Условия = Неопределено, Упорядочивание = Неопределено, Параметры = Неопределено)
	
	// ИмяМенеджер 	- имя таблицы для запроса
	// Поля 		- струкутура, в ключе имя поля в 1с, в значении имя поля для json
	// Параметры	- структура доп. параметров (для расширений)
	// Условия		- структура условий в запросе, в ключе имя поля условия, в значении параметр
	// Упорядочивание - строка, поля для упорядочивания в запросе через запятую
	// Возвращает результат запроса json (всегда есть поле ссылка - guid и остальные поля указанные в "полях")
	
	Запрос = Новый Запрос;
	
	массПолей = Новый Массив;
	Для Каждого Поле Из Поля Цикл
		массПолей.Добавить(стрШаблон("%1 %2", Поле.Ключ, Поле.Значение));
	КонецЦикла;
	
	массУсловий = Новый Массив;
	Если Параметры <> Неопределено И Параметры.Свойство("Ссылка") Тогда
		массУсловий.Добавить("Ссылка = &Ссылка");
	КонецЕсли;
	Если Условия <> Неопределено Тогда
		Для Каждого Условие Из Условия Цикл
			массУсловий.Добавить(стрШаблон("%1 = &%1", Условие.Ключ));
			Запрос.УстановитьПараметр(Условие.Ключ, Условие.Значение);
		КонецЦикла;
	КонецЕсли;
	
	Запрос.Текст = СтрШаблон("ВЫБРАТЬ Ссылка guid, %1 ИЗ %2 %5 %3 %4", 
			СтрСоединить(массПолей, ","), 
			ИмяМенеджер,
			СтрСоединить(массУсловий, " И "),
			?(Упорядочивание = Неопределено, "", " УПОРЯДОЧИТЬ ПО " + Упорядочивание),
			?(массУсловий.Количество(), "ГДЕ ", ""));
	
	Возврат РезультатЗапросаJSON(Запрос, Параметры);
	
КонецФункции

Функция Сущность_Склады(Параметры = Неопределено)
	
	Возврат ТиповаяСущность("Справочник.Склады", Новый Структура("Наименование", "title"), Новый Структура("ПометкаУдаления", Ложь), "Наименование", Параметры);
	
КонецФункции
Функция Сущность_Производители(Параметры = Неопределено)
	
	Возврат ТиповаяСущность("Справочник.Производители", Новый Структура("Наименование", "title"), Новый Структура("ПометкаУдаления", Ложь), "Наименование", Параметры);
	
КонецФункции
Функция Сущность_Категории(Параметры = Неопределено)
	
	Возврат РезультатЗапросаJSON(Новый Запрос(СтрШаблон("
	|ВЫБРАТЬ 	Ссылка guid, Родитель parent, Наименование title 
	|ИЗ 		Справочник.Номенклатура 
	|ГДЕ		ЭтоГруппа И НЕ ПометкаУдаления %1 %2
	|УПОРЯДОЧИТЬ ПО Наименование ИЕРАРХИЯ",
		?(Параметры <> Неопределено И Параметры.Свойство("Ссылка"), "И Ссылка = &Ссылка", ""),
		?(Параметры <> Неопределено И Параметры.Свойство("Родитель"), "И Родитель = &Родитель", ""))), 
	Параметры);
	
КонецФункции
Функция Сущность_Товары(Параметры = Неопределено) Экспорт
	
	ПолеПоиска 			= АТ_ОбщегоНазначения.Параметр(Параметры, "Поиск", "");
	ДобавлятьАналоги 	= СтрНайти(ПолеПоиска, "Артикул");
	
	Первые 		= АТ_ОбщегоНазначения.Параметр(Параметры, "Первые");
	Ссылка 		= АТ_ОбщегоНазначения.Параметр(Параметры, "Ссылка");
	Родитель 	= АТ_ОбщегоНазначения.Параметр(Параметры, "Родитель");
	
	Возврат РезультатЗапросаJSON(Новый Запрос(СтрШаблон("
	|ВЫБРАТЬ %2	Спр.Ссылка guid, Спр.Родитель parent, Спр.Наименование title, Спр.Ссылка.Артикул SKU,
	|			Спр.Производитель 				manufacture,
	|			Спр.Производитель.Наименование 	manufactureTitle,
	|			Ост.Склад 				Store,
	|			Ост.Склад.Наименование 	StoreTitle,
	|			ЕСТЬNULL(Ост.ВНаличииОстаток, 0) - ЕСТЬNULL(Ост.ВРезервеСоСкладаОстаток, 0) - ЕСТЬNULL(Ост.ВРезервеПодЗаказОстаток, 0) StoreAmount
	|ИЗ 		Справочник.Номенклатура Спр
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.СвободныеОстатки.Остатки(,ИСТИНА %7 %8 %9) Ост
	|ПО Спр.Ссылка = Ост.Номенклатура
	|
	|%1
	|ГДЕ		НЕ Спр.ЭтоГруппа И НЕ Спр.ПометкаУдаления %3 %4 %5 %6
	|УПОРЯДОЧИТЬ ПО Наименование
	|",
		?(ДобавлятьАналоги, "
			|ЛЕВОЕ 	СОЕДИНЕНИЕ РегистрСведений.АналогиТоваров.СрезПоследних Рег
			|ПО		Спр.Ссылка = Рег.Номенклатура", ""),
		?(Первые = Неопределено, "", СтрШаблон("ПЕРВЫЕ %1", Формат(Первые, "ЧГ="))),
		?(Ссылка = Неопределено, "", "				И Ссылка = &Ссылка"),
		?(Родитель = Неопределено, "", "			И Родитель = &Родитель"),
		?(СтрНайти(ПолеПоиска, "Наименование"), "	И Спр.Наименование ПОДОБНО ""%" + Параметры.ЗначениеПоиска + "%""", ""),
		?(СтрНайти(ПолеПоиска, "Артикул"), 		"	И (Спр.Артикул ПОДОБНО ""%" + Параметры.ЗначениеПоиска + "%"" ИЛИ Рег.Артикул ПОДОБНО ""%" + Параметры.ЗначениеПоиска + "%"")", ""),
		?(Ссылка = Неопределено, "", "И Номенклатура = &Ссылка"),
		?(Родитель = Неопределено, "", "И Номенклатура.Родитель = &Родитель")
		)),
	Параметры);
	
КонецФункции

Функция Сущность_ВременаДоставки(Параметры = Неопределено) Экспорт
	
	регион = АТ_ОбщегоНазначения.Параметр(Параметры, "БизнесРегион");
	
	Возврат РезультатЗапросаJSON(Новый Запрос(СтрШаблон("
	|ВЫБРАТЬ 
	|	Склад 			warehouse,
	|	Бизнесрегион 	region,
	|	ВремяВДнях		days 
	|ИЗ
	|	регистрСведений.АТ_СрокиДоставки
	|
	|ГДЕ ИСТИНА %1
	|", ?(ЗначениеЗаполнено(регион) , " И БизнесРегион = &БизнесРегион", ""))), 
	Параметры);
	
КонецФункции
Функция Сущность_АдресаДоставки(Параметры = Неопределено) Экспорт
	
	// Эту функцию надо разбить на две
	
	Контрагент = АТ_ОбщегоНазначения.Параметр(Параметры, "Контрагент");
	Если ЗначениеЗаполнено(Контрагент) Тогда
		
		Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	Ссылка 			guid,
		|	Контрагент 		kontra,
		|	Представление 	description,
		|	Склад,
		|	ВЫБОР КОГДА Дост.ВремяОтгрузки ЕСТЬ NULL ТОГДА ЛОЖЬ ИНАЧЕ ИСТИНА КОНЕЦ ЕстьВремяДоставки,
		|	СЕКУНДА(ВремяОтгрузки) + МИНУТА(ВремяОтгрузки) * 60 + ЧАС(ВремяОтгрузки) * 3600 key,
		|	СЕКУНДА(ВремяДоставки) + МИНУТА(ВремяДоставки) * 60 + ЧАС(ВремяДоставки) * 3600 value
		|ИЗ
		|	Справочник.БП_АдресаДоставкиКонтрагентов Спр
		|
		|ЛЕВОЕ СОЕДИНЕНИЕ	РегистрСведений.АТ_РасписаниеДоставки Дост
		|ПО					Спр.ЗонаДоставки = Дост.ЗонаДоставки 
		|	
		|ГДЕ НЕ ПометкаУдаления И КОнтрагент = &КОнтрагент
		|
		|ИТОГИ МАКСИМУМ(guid), МАКСИМУМ(kontra), МАКСИМУМ(description), МАКСИМУМ(ЕстьВремяДоставки)ПО  Ссылка, Склад
		|");
		
		Адреса = Новый Массив;
		
		Запрос.УстановитьПараметр("ПустаяДата", '00010101');
		Запрос.УстановитьПараметр("Контрагент", Контрагент);
		ВыборкаАдреса = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
		
		Пока ВыборкаАдреса.Следующий() Цикл
			
			Склады 			= Новый Массив;
			ВыборкаСклад 	= ВыборкаАдреса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
				
			Пока ВыборкаСклад.Следующий() Цикл
				Если ВыборкаСклад.ЕстьВремяДоставки Тогда
					
					timing 	= Новый Массив;
					Выборка	= ВыборкаСклад.Выбрать();
					
					Пока Выборка.Следующий() Цикл
						timing.Добавить(КонвертацияТипов.ЗаполнитьСтруктуру(Новый Структура("key, value"), Выборка));
					КонецЦикла;
					
					Склады.Добавить(Новый Структура("guid, timing", ВыборкаСклад.Склад, timing));
					
				КонецЕсли;
			КонецЦикла;
			Адреса.Добавить(КонвертацияТипов.ЗаполнитьСтруктуру(Новый Структура("guid, kontra, description, stores"), ВыборкаАдреса, Новый Структура("stores", Склады)));
		КонецЦикла;
		
		Возврат w1_Json.JSON36(Адреса);
		
	Иначе
		
		Возврат РезультатЗапросаJSON(Новый Запрос(СтрШаблон("
		|ВЫБРАТЬ 
		|	Ссылка 			guid,
		|	Контрагент 		kontra,
		|	Представление 	description
		|ИЗ
		|	Справочник.БП_АдресаДоставкиКонтрагентов
		|
		|ГДЕ НЕ ПометкаУдаления", Параметры)));
		
	КонецЕсли;
	
КонецФункции

Функция Сущность_Контрагенты(Параметры = Неопределено) Экспорт
	
	// Возвращает только контрагентов юридических лиц
	
	Отбор = Новый Структура("ЭтоРозничный", Ложь);
	Если Параметры.Свойство("Партнер") Тогда
		Отбор.Вставить("Партнер", Параметры.Партнер);
	КонецЕсли;
	Отбор.Вставить("ПометкаУдаления", Ложь);
	
	Возврат ТиповаяСущность("Справочник.Контрагенты", Новый Структура("Наименование", "title"), Отбор);
	
КонецФункции
Функция Сущность_ДебиторскаяЗадолженностьПартнера(Партнер) Экспорт
	
	// Возвращает дебиторскую задолженность партнера
	
	//СоответствиеЗапросыДанные = Новый Соответствие;
	//МассивРезультатовЗапросовПоПартнеру = Отчеты.ДосьеПартнера.Создать().ВыполнитьПакетЗапросовПоПартнеру(Партнер, СоответствиеЗапросыДанные);

	УстановитьПривилегированныйРежим(Истина);
	
	Договор = АТ_Сервер.ПолучитьДействующийДоговор(Партнер);
	
	Запрос = Новый Запрос("
	
	// Календарь
	|
	|ВЫБРАТЬ 	Дни.Дата, Количество(Дни.ВидДня = &РабочийДень) РабДней
	|ПОМЕСТИТЬ	Дни
	|ИЗ			РегистрСведений.ДанныеПроизводственногоКалендаря Дни
	|	
	|ЛЕВОЕ СОЕДИНЕНИЕ	РегистрСведений.ДанныеПроизводственногоКалендаря Накопл
	|ПО					Дни.Дата <= накопл.Дата
	|	
	|ГДЕ 	Дни.Дата МЕЖДУ &НачалоУчета И &ТекущаяДата И
	|		Накопл.ВидДня = &РабочийДень И Накопл.Дата МЕЖДУ &НачалоУчета И &ТекущаяДата

	|
	|СГРУППИРОВАТЬ ПО Дни.Дата;

	// Долги по документам

	|ВЫБРАТЬ
	|	Ост.РасчетныйДокумент.Номер								doc_number,
	|	Ост.РасчетныйДокумент.СуммаДокумента					doc_sum,
	|	""2018.05.17""											doc_data,
	|	Ост.РасчетныйДокумент.Дата								ДатаДок,
	|	Ост.АналитикаУчетаПоПартнерам.Контрагент.Наименование	contra_title,
	|	МАКСИМУМ(Ост.РасчетныйДокумент.СуммаДокумента - ДолгУпрОстаток) 	accept,
	|	МАКСИМУМ(ЕСТЬNULL(Дни.РабДней, 0))						days_alarm,
	|	МАКСИМУМ(ДолгУпрОстаток) 								debit,
	|	МАКСИМУМ(ВЫБОР КОГДА Дни.Дата ЕСТЬ NULL ТОГДА 0 ИНАЧЕ Ост.ДолгУпрОстаток КОНЕЦ) debit_alarm
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентамиПоДокументам.Остатки(,АналитикаУчетаПоПартнерам.Партнер = &Партнер) Ост
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	РегистрНакопления.РасчетыСКлиентамиПоДокументам Двиг
	|ПО
	|	Двиг.ДолгУпр > 0 И
	|	Ост.АналитикаУчетаПоПартнерам 	= Двиг.АналитикаУчетаПоПартнерам И
	|	Ост.ЗаказКлиента 				= Двиг.ЗаказКлиента И
	|	Ост.РасчетныйДокумент 			= Двиг.РасчетныйДокумент И
	|	Ост.Валюта 						= Двиг.Валюта
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	Дни Дни
	|ПО
	|	НАЧАЛОПЕРИОДА(Двиг.ДатаПлатежа, ДЕНЬ) = Дни.Дата
	|
	|СГРУППИРОВАТЬ ПО
	|	Ост.РасчетныйДокумент, Ост.АналитикаУчетаПоПартнерам
	|");
	
	Запрос.УстановитьПараметр("НачалоУчета", '20170101');
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДата());
	Запрос.УстановитьПараметр("РабочийДень", Перечисления.ВидыДнейПроизводственногоКалендаря.Рабочий);
	Запрос.УстановитьПараметр("Партнер", Партнер);
	
	ТабПоДокам 	= Запрос.Выполнить().Выгрузить();
	просрСумма 	= ТабПоДокам.Итог("debit_alarm");
	ТаблОплат	= АТ_Сервер.ПолучитьСформироватьСоглашение(Партнер, Новый Структура("ФормаОплаты", Перечисления.АТ_ТипыСоглашенийСКлиентами.Основное)).ЭтапыГрафикаОплаты;	
	
	КонвертацияТипов.ВыполнитьВыражениеВКаждойСтрокеТаблицы(ТабПоДокам, "Строка.doc_data = Формат(Строка.ДатаДок, ""ДФ=dd.MM.yyyy"")");
	ТабПоДокам.Колонки.Удалить("ДатаДок");
	
	ДебЗад = Новый Массив;
	ДебЗад.Добавить(Новый Структура("days, credit, debit, debit_alarm, contractors",
				?(ТаблОплат.Количество(), ТаблОплат[0].Сдвиг, 0),
				Договор.ДопустимаяСуммаЗадолженности - просрСумма,
				ТабПоДокам.Итог("debit"),
				просрСумма,
				ТабПоДокам));
				
	УстановитьПривилегированныйРежим(Ложь);
				
	Возврат w1_Json.JSON36(ДебЗад);
				
КонецФункции
Функция Сущность_РазрешенныеСклады(Параметры)
	
	// Возвращает доступные склады пользователю для заказа по адресам доставки
	
	Возврат w1_Json.JSON36(АТ_Сервер.ПолучитьДоступныеСкладыПоПартнеру(Параметры.Партнер));
	
КонецФункции

#КонецОбласти

#Область Парсер

Функция ПреобразованиеЧтенияJSON(Свойство, Значение, ДопПараметры) Экспорт
	
	Если ДопПараметры <> Неопределено И ДопПараметры.Свойство("Менеджеры") И АТ_ОбщегоНазначения.ЭтоГуид(Значение) Тогда
		Для Каждого Менеджер Из ДопПараметры.Менеджеры Цикл
			
			Ссылка = Менеджер.ПолучитьСсылку(Новый УникальныйИдентификатор(Значение));
			Если Ссылка.ПолучитьОбъект() <> Неопределено Тогда
				Возврат Ссылка;
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
	
КонецФункции

Функция UnJSON(стрJSON, ПрочитатьВСоответствие = Ложь, ИменаСвойствСоЗначениямиДата = Неопределено, ДопПараметры = Неопределено, стрОшибки = "") Экспорт
	
	Чтение = Новый ЧтениеJSON;
	Чтение.УстановитьСтроку(стрJSON);
	
	Попытка
		Возврат ПрочитатьJSON(Чтение, ПрочитатьВСоответствие, ИменаСвойствСоЗначениямиДата,,"ПреобразованиеЧтенияJSON", HTTPМодуль, ДопПараметры);
	Исключение
		опОшибки = ОписаниеОшибки();
		стрОшибки = "Ошибка чтения JSON: " + опОшибки; 
	КонецПопытки;
	
КонецФункции


#КонецОбласти

Функция ВернутьОтвет(Параметры, ЭтоОтладка)
	
	Если ЭтоОтладка Тогда
		
		Возврат Параметры;
		
	Иначе
	
		Ответ = Новый HTTPСервисОтвет(?(Параметры.Свойство("КодОтвета"), Параметры.КодОтвета, 200));
		
		Если Параметры.Свойство("Тело") Тогда
			Ответ.УстановитьТелоИзСтроки(Параметры.Тело, КодировкаТекста.UTF8);
		КонецЕсли;
		
		Возврат Ответ;
		
	КонецЕсли;
	
КонецФункции

Процедура ДобавитьПараметр_ИзПоискаСсылки(Имя, ИмяПараметра, Менеджер, Параметры, Запрос, Ошибка, стрОшибки, ЭтоОтладка)
	
	// Добавляет параметр ссылку по найденому гуиду из параметров запроса
	// если ничего не найдет тогда установит ошибку и "Ошибка" установит в ЛОЖЬ
	// если ок то добавит параметр
	
	Перем Гуид;
	
	Если ПолучитьПараметрЗапроса(ИмяПараметра, Гуид, Запрос, ЭтоОтладка) Тогда
	
		Ссылка = ПолучитьПоГуиду(Менеджер, Гуид, стрОшибки);
		Если Ссылка <> Неопределено Тогда
			Параметры.Вставить(Имя, Ссылка);
		Иначе
			Ошибка = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
Функция ПолучитьПараметрЗапроса(ИмяПараметра, Значение, Запрос, ЭтоОтладка = Ложь)
	
	Значение = Параметр(Запрос, ИмяПараметра, ЭтоОтладка);
	Возврат Значение <> Неопределено;
		
КонецФункции

#Область rest_вызовы

Функция ТиповоеПолучениеОбъектаПоГуиду(Запрос, Менеджер, ИмяФункцииСущности, ЭтоОтладка = Ложь)
	
	стрОшибки 	= "";
	Ссылка 		= ПолучитьПоГуиду(Менеджер, Параметр(Запрос, "guid", ЭтоОтладка), стрОшибки);
	
	Возврат ?(Ссылка = Неопределено,
		ВернутьОтвет(Новый Структура("КодОтвета, Тело", КодОшибкиНеНайденаСсылка(), стрОшибки), ЭтоОтладка),
		ВернутьОтвет(Новый Структура("Тело", Вычислить(ИмяФункцииСущности + "(Новый Структура(""Ссылка"", Ссылка))")), ЭтоОтладка));
	
КонецФункции

Функция СкладыGET(Запрос, ЭтоОтладка = Ложь) Экспорт
	
	Возврат ВернутьОтвет(Новый Структура("Тело", Сущность_Склады()), ЭтоОтладка);
	
КонецФункции
Функция СкладGET(Запрос, ЭтоОтладка = Ложь) Экспорт

	Возврат ТиповоеПолучениеОбъектаПоГуиду(Запрос, Справочники.Склады, "Сущность_Склады", ЭтоОтладка);
		
КонецФункции
	
Функция ПроизводителиGET(Запрос, ЭтоОтладка = Ложь) Экспорт
	
	Возврат ВернутьОтвет(Новый Структура("Тело", Сущность_Производители()), ЭтоОтладка);
	
КонецФункции
Функция ПроизводительGET(Запрос, ЭтоОтладка = Ложь) Экспорт
	
	Возврат ТиповоеПолучениеОбъектаПоГуиду(Запрос, Справочники.Производители, "Сущность_Производители", ЭтоОтладка);
	
КонецФункции

Функция КатегорииGET(Запрос, ЭтоОтладка = Ложь) Экспорт
	
	Параметры 	= Новый Структура;
	стрОшибки 	= "";
	Ошибка 		= Ложь;
	
	ДобавитьПараметр_ИзПоискаСсылки("Родитель", "category", Справочники.Номенклатура, Параметры, Запрос, Ошибка, стрОшибки, ЭтоОтладка);
	
	Возврат ?(Ошибка, 
		ВернутьОтвет(Новый Структура("КодОтвета, Тело", КодОшибкиНеНайденаСсылка(), стрОшибки), ЭтоОтладка),
		ВернутьОтвет(Новый Структура("Тело", Сущность_Категории(Параметры)), ЭтоОтладка));
	
КонецФункции
Функция КатегорияGET(Запрос, ЭтоОтладка = Ложь) Экспорт
	
	Возврат ТиповоеПолучениеОбъектаПоГуиду(Запрос, Справочники.Номенклатура, "Сущность_Категории", ЭтоОтладка);
	
КонецФункции
	
Функция ТоварыGET(Запрос, ЭтоОтладка = Ложь) Экспорт
	
	Параметры 	= Новый Структура;
	стрОшибки 	= "";
	Ошибка 		= Ложь;
	
	ДобавитьПараметр_ИзПоискаСсылки("Родитель", "category", Справочники.Номенклатура, Параметры, Запрос, Ошибка, стрОшибки, ЭтоОтладка);
	
	Возврат ?(Ошибка, 
		ВернутьОтвет(Новый Структура("КодОтвета, Тело", КодОшибкиНеНайденаСсылка(), стрОшибки), ЭтоОтладка),
		ВернутьОтвет(Новый Структура("Тело", Сущность_Товары(Параметры)), ЭтоОтладка));
	
КонецФункции
Функция ТоварGET(Запрос, ЭтоОтладка = Ложь) Экспорт
	
	Возврат ТиповоеПолучениеОбъектаПоГуиду(Запрос, Справочники.Номенклатура, "Сущность_Товары", ЭтоОтладка);
	
КонецФункции
Функция ПоискТоваровGET(Запрос, ЭтоОтладка = Ложь) Экспорт
	
	Перем ТипЗапроса, Первые;
	
	Параметры = Новый Структура;
	
	ТекстОшибкиТипаЗапроса = "Не указан или не заполнен тип запороса (type), должно быть bigdata, sku или title";
	Если ПолучитьПараметрЗапроса("type", ТипЗапроса, Запрос, ЭтоОтладка) Тогда
		
		Если НРег(ТипЗапроса) = "bigdata" Тогда
			Параметры.Вставить("Поиск", "Наименование,Артикул");
		ИначеЕсли НРег(ТипЗапроса) = "sku" Тогда
			Параметры.Вставить("Поиск", "Артикул");
		ИначеЕсли НРег(ТипЗапроса) = "title" Тогда
			Параметры.Вставить("Поиск", "Наименование");
		Иначе
			Возврат ВернутьОтвет(Новый Структура("КодОтвета, Тело", КодОшибкиНеНайденаСсылка(), ТекстОшибкиТипаЗапроса), ЭтоОтладка);
		КонецЕсли;
		
		Параметры.Вставить("ЗначениеПоиска", Параметр(Запрос, "ЗначениеПоиска", ЭтоОтладка));
		
	Иначе
		Возврат ВернутьОтвет(Новый Структура("КодОтвета, Тело", КодОшибкиНеНайденаСсылка(), ТекстОшибкиТипаЗапроса), ЭтоОтладка);
	КонецЕсли;
	
	Если ПолучитьПараметрЗапроса("hint", Первые, Запрос, ЭтоОтладка) Тогда
		Попытка
			Первые = Число(Первые);
		Исключение
			Возврат ВернутьОтвет(Новый Структура("КодОтвета, Тело", КодОшибкиНеНайденаСсылка(), "hint должен быть числом"), ЭтоОтладка);
		КонецПопытки;
		Параметры.Вставить("Первые", Первые);
	КонецЕсли;
	
	Возврат ВернутьОтвет(Новый Структура("Тело", Сущность_Товары(Параметры)), ЭтоОтладка);
	
КонецФункции


Функция ДобавитьПараметр_ИзПоискаСсылки_ПоУИН(ИмяСправочника, Запрос, Параметры, Ошибка, строшибки, ЭтоОтладка)
	
	// Ищет ссылку по гуидо или УИНу (Партнер или Контрагент)
	// если находит до добавляет параметры в параметры
	
	ГуидИлиУИН = Параметр(Запрос, "id", ЭтоОтладка);
	
	Если Не ЗначениеЗаполнено(ГуидИлиУИН) Тогда
		
		Ошибка 		= Истина;
		стрОшибки 	= "Нужно указать гуид или УИН";
		
	ИначеЕсли СтрДлина(ГуидИлиУИН) = 36 Тогда
		
		ДобавитьПараметр_ИзПоискаСсылки(ИмяСправочника, "id", Справочники[ИмяСправочника + "ы"], Параметры, Запрос, Ошибка, стрОшибки, ЭтоОтладка);
		
	Иначе
		
		Запрос = Новый Запрос(СтрШаблон("ВЫБРАТЬ ПЕРВЫЕ 1 Ссылка ИЗ Справочник.%1ы ГДЕ УН_%1а = ""%2""", ИмяСправочника, ГуидИлиУИН));
		Выполнение = Запрос.Выполнить();
		Если Выполнение.Пустой() Тогда
			Ошибка= Истина;
			стрОшибки = "Не найден по УИНу " + ГуидИлиУИН;
		Иначе
			Выборка = Выполнение.Выбрать();
			Выборка.Следующий();
			Параметры.Вставить(ИмяСправочника, Выборка.Ссылка);
		КонецЕсли;
		
	КонецЕсли;
	
КонецФункции
Функция ВремяДоставкиGET(Запрос, ЭтоОтладка = Ложь) Экспорт
	
	Параметры 	= Новый Структура;
	стрОшибки 	= "";
	Ошибка 		= Ложь;
	
	ДобавитьПараметр_ИзПоискаСсылки_ПоУИН("Контрагент", Запрос, Параметры, Ошибка, строшибки, ЭтоОтладка);
	Если Ошибка Тогда
		Возврат ВернутьОтвет(Новый Структура("КодОтвета, Тело", КодОшибкиНеНайденаСсылка(), стрОшибки), ЭтоОтладка);
	КонецЕсли;
	
	Параметры.Вставить("БизнесРегион", Параметры.Контрагент.Партнер.БизнесРегион);
	
	Возврат ВернутьОтвет(Новый Структура("Тело", Сущность_ВременаДоставки(Параметры)), ЭтоОтладка);
	
КонецФункции
Функция АдресаДоставкиGET(Запрос, ЭтоОтладка = Ложь) Экспорт
	
	Параметры 	= Новый Структура;
	стрОшибки 	= "";
	Ошибка 		= Ложь;
	
	ДобавитьПараметр_ИзПоискаСсылки_ПоУИН("Контрагент", Запрос, Параметры, Ошибка, стрОшибки, ЭтоОтладка);
	
	Возврат ?(Ошибка, 
		ВернутьОтвет(Новый Структура("КодОтвета, Тело", КодОшибкиНеНайденаСсылка(), стрОшибки), ЭтоОтладка),
		ВернутьОтвет(Новый Структура("Тело", Сущность_АдресаДоставки(Параметры)), ЭтоОтладка));
	
КонецФункции

Функция КонтрагентыGET(Запрос, ЭтоОтладка = Ложь) Экспорт
	
	Параметры 	= Новый Структура;
	стрОшибки 	= "";
	Ошибка 		= Ложь;
	
	ДобавитьПараметр_ИзПоискаСсылки_ПоУИН("Партнер", Запрос, Параметры, Ошибка, стрОшибки, ЭтоОтладка);
	
	Возврат ?(Ошибка, 
		ВернутьОтвет(Новый Структура("КодОтвета, Тело", КодОшибкиНеНайденаСсылка(), стрОшибки), ЭтоОтладка),
		ВернутьОтвет(Новый Структура("Тело", Сущность_Контрагенты(Параметры)), ЭтоОтладка));
	
КонецФункции
Функция ДебиторскаяЗадолженностьGET(Запрос, ЭтоОтладка = Ложь) Экспорт
	
	Параметры 	= Новый Структура;
	стрОшибки 	= "";
	Ошибка 		= Ложь;
	
	ДобавитьПараметр_ИзПоискаСсылки_ПоУИН("Партнер", Запрос, Параметры, Ошибка, стрОшибки, ЭтоОтладка);
	
	Возврат ?(Ошибка, 
		ВернутьОтвет(Новый Структура("КодОтвета, Тело", КодОшибкиНеНайденаСсылка(), стрОшибки), ЭтоОтладка),
		ВернутьОтвет(Новый Структура("Тело", Сущность_ДебиторскаяЗадолженностьПартнера(Параметры.Партнер)), ЭтоОтладка));
	
КонецФункции
Функция ДоступныеСкладыGET(Запрос, ЭтоОтладка = Ложь) Экспорт
	
	Параметры 	= Новый Структура;
	стрОшибки 	= "";
	Ошибка 		= Ложь;
	
	ДобавитьПараметр_ИзПоискаСсылки_ПоУИН("Партнер", Запрос, Параметры, Ошибка, стрОшибки, ЭтоОтладка);
	
	Возврат ?(Ошибка, 
		ВернутьОтвет(Новый Структура("КодОтвета, Тело", КодОшибкиНеНайденаСсылка(), стрОшибки), ЭтоОтладка),
		ВернутьОтвет(Новый Структура("Тело", Сущность_РазрешенныеСклады(Параметры)), ЭтоОтладка));
	
КонецФункции

Функция МинимальнаяСуммаДоставкиGET(Запрос, ЭтоОтладка = Ложь) Экспорт
	
	Параметры 	= Новый Структура;
	стрОшибки 	= "";
	Ошибка 		= Ложь;
	address		= "address";
	
	hope = ПолучитьЗначениеИзТела(Запрос, Ошибка, Тип("Соответствие"),, ЭтоОтладка);
	Если Ошибка Тогда
		Возврат hope;
	КонецЕсли;
	
	Если hope[address] = Неопределено Тогда
		Возврат ВернутьОтвет(Новый Структура("КодОтвета, Тело", КодОшибкиПлохойЗапрос(), "Ожидается " + address), ЭтоОтладка);
	КонецЕсли;
	
	АдресСсылка = ПолучитьПоГуиду(Справочники.БП_АдресаДоставкиКонтрагентов, hope[address], стрОшибки);
	Если АдресСсылка = Неопределено Тогда
		ВернутьОтвет(Новый Структура("КодОтвета, Тело", КодОшибкиНеНайденаСсылка(), стрОшибки), ЭтоОтладка);
	КонецЕсли;
	
	Товары = Новый ТаблицаЗначений;
	Товары.Колонки.Добавить("Склад", 		Новый ОписаниеТипов("СправочникСсылка.Склады"));
	Товары.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	Товары.Колонки.Добавить("Количество", 	Новый ОписаниеТипов("Число"));
	
	Для Каждого ЭлСклад Из hope Цикл
		Если ЭлСклад.Ключ <> address Тогда
			
			СкладСсылка = ПолучитьПоГуиду(Справочники.Склады, ЭлСклад.Ключ, стрОшибки);
			Если СкладСсылка = Неопределено Тогда
				ВернутьОтвет(Новый Структура("КодОтвета, Тело", КодОшибкиНеНайденаСсылка(), стрОшибки), ЭтоОтладка);
			КонецЕсли;
			
			Для Каждого ЭлТовар Из ЭлСклад.Значение Цикл
				
				СсылкаТовар = ПолучитьПоГуиду(Справочники.Номенклатура, ЭлТовар.Ключ, стрОшибки);
				Если СсылкаТовар = Неопределено Тогда
					ВернутьОтвет(Новый Структура("КодОтвета, Тело", КодОшибкиНеНайденаСсылка(), стрОшибки), ЭтоОтладка);
				КонецЕсли;
				
				НовСтрока = Товары.Добавить();
				НовСтрока.Склад 		= СкладСсылка;
				НовСтрока.Номенклатура 	= СсылкаТовар;
				НовСтрока.Количество 	= ЭлТовар.Значение;
				
			КонецЦикла;
			
		КонецЕсли;
	КонецЦикла;
	
	МинСумма = Формат(АТ_ФункцииРасчета.МинимальнаяСуммаЗаказа(АдресСсылка, Товары), "ЧГ=");
	Возврат ВернутьОтвет(Новый Структура("Тело", МинСумма), ЭтоОтладка);
	
КонецФункции

#КонецОбласти