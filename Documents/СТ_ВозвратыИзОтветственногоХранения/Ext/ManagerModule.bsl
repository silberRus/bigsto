﻿

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	ЭтоПартнер = ПраваПользователяПовтИсп.ЭтоПартнер();
	
	//Если НЕ ЭтоПартнер
	//	 И ПолучитьФункциональнуюОпцию("ИспользоватьОтветственноеХранение") Тогда
		// МХ-3 
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.МенеджерПечати = "Обработка.ПечатьОбщихФорм";
		КомандаПечати.Идентификатор = "МХ3";
		КомандаПечати.Представление = НСтр("ru = 'Акт о возврате ТМЦ, сданных на хранение (МХ-3)'");
		КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
		КомандаПечати.Порядок = 1;
	//КонецЕсли;
	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
			
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "КомплектДокументов") Тогда
		КоллекцияПечатныхФорм.Очистить();
		СформироватьКомплектПечатныхФорм(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати);
	КонецЕсли;
	
	ФормированиеПечатныхФорм.ЗаполнитьПараметрыОтправки(ПараметрыВывода.ПараметрыОтправки, МассивОбъектов, КоллекцияПечатныхФорм);
	
КонецПроцедуры

Функция СформироватьКомплектПечатныхФорм(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати) Экспорт
	
	Перем АдресКомплектаПечатныхФорм;
	
	Если ТипЗнч(ПараметрыПечати) = Тип("Структура") И ПараметрыПечати.Свойство("АдресКомплектаПечатныхФорм", АдресКомплектаПечатныхФорм) Тогда
		
		КомплектПечатныхФорм = ПолучитьИзВременногоХранилища(АдресКомплектаПечатныхФорм);
		
	Иначе

		КомплектПечатныхФорм = РегистрыСведений.НастройкиПечатиОбъектов.КомплектПечатныхФорм(
			Метаданные.Документы.РеализацияТоваровУслуг.ПолноеИмя(),
			МассивОбъектов, Неопределено);
		
	КонецЕсли;
		
	Если КомплектПечатныхФорм = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	СтруктураТипов = Новый Соответствие;
	СтруктураТипов.Вставить("Документ.СТ_ВозвратыИзОтветственногоХранения", МассивОбъектов);
	
	ИмяМакета = "МХ3";
	ТекущийКомплект = КомплектПечатныхФорм.Скопировать(Новый Структура("Имя,Печатать,",ИмяМакета,Истина));
	Если ТекущийКомплект.Количество() > 0 Тогда
		Если ТекущийКомплект.Колонки.Найти("Ссылка") <> Неопределено И ЗначениеЗаполнено(ТекущийКомплект[0].Ссылка) Тогда
			РегистрыСведений.НастройкиПечатиОбъектов.СкопироватьПечатнуюФормуВКоллекциюОдинЭкземпляр(КоллекцияПечатныхФорм, ИмяМакета);
			ТаблицаСсылок = ТекущийКомплект.Скопировать(,"Ссылка");
			ТаблицаСсылок.Свернуть("Ссылка");
			ТекущаяСтруктураТипов = Новый Соответствие;
			ТекущаяСтруктураТипов.Вставить("Документ.СТ_ВозвратыИзОтветственногоХранения", ТаблицаСсылок.ВыгрузитьКолонку("Ссылка"));
		Иначе
			РегистрыСведений.НастройкиПечатиОбъектов.СкопироватьПечатнуюФормуВКоллекцию(КоллекцияПечатныхФорм, ТекущийКомплект[0]);
			ТекущаяСтруктураТипов = СтруктураТипов;
		КонецЕсли;
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			ИмяМакета,
			ТекущийКомплект[0].Представление,
			Обработки.ПечатьОбщихФорм.СформироватьПечатнуюФормуМХ3(ТекущаяСтруктураТипов, ОбъектыПечати, ПараметрыПечати, ТекущийКомплект));
	КонецЕсли;
	
	РегистрыСведений.НастройкиПечатиОбъектов.СформироватьКомплектВнешнихПечатныхФорм(
			"Документ.СТ_ВозвратыИзОтветственногоХранения",
			МассивОбъектов,
			ПараметрыПечати,
			КоллекцияПечатныхФорм,
			ОбъектыПечати);
	
КонецФункции

Функция КомплектПечатныхФорм() Экспорт
	
	КомплектПечатныхФорм = РегистрыСведений.НастройкиПечатиОбъектов.ПодготовитьКомплектПечатныхФорм();
	
	//Если ПолучитьФункциональнуюОпцию("ИспользоватьОтветственноеХранение") Тогда
		РегистрыСведений.НастройкиПечатиОбъектов.ДобавитьПечатнуюФормуВКомплект(КомплектПечатныхФорм,
			"МХ3", 
			НСтр("ru = 'Акт о возврате ТМЦ, сданных на хранение (МХ-3)'"),
			0);
	//КонецЕсли; 
	
	Возврат КомплектПечатныхФорм;
	
КонецФункции

// Функция получает данные для формирования печатной формы МХ - 3
//
Функция ПолучитьДанныеДляПечатнойФормыМХ3(ПараметрыПечати, МассивОбъектов) Экспорт 
	
	КолонкаКодов = ФормированиеПечатныхФорм.ИмяДополнительнойКолонки();
	Если Не ЗначениеЗаполнено(КолонкаКодов) Тогда
		КолонкаКодов = "Код";
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	РасчетСебестоимостиТоваровОрганизации.Ссылка.ПредварительныйРасчет КАК ПредварительныйРасчет,
	               |	ОбщийДокумент.Ссылка КАК Ссылка,
	               |	ОбщийДокумент.Ссылка.Номер КАК Номер,
	               |	ОбщийДокумент.Ссылка.Дата КАК Дата,
	               |	ОбщийДокумент.Ссылка.Дата КАК ДатаДокумента,
	               |	ОбщийДокумент.Ссылка.Организация КАК Организация,
	               |	ОбщийДокумент.Ссылка.Организация.Префикс КАК Префикс,
	               |	ОбщийДокумент.Документ.Склад КАК Склад,
	               |	Склады.ИсточникИнформацииОЦенахДляПечати КАК ИсточникИнформацииОЦенахДляПечати,
	               |	Склады.УчетныйВидЦены КАК ВидЦены,
	               |	Склады.УчетныйВидЦены.ВалютаЦены КАК ВалютаЦены,
	               |	ДокументТовары.Ссылка КАК ДокументСсылка
	               |ПОМЕСТИТЬ ВтШапка
	               |ИЗ
	               |	Документ.СТ_ВозвратыИзОтветственногоХранения.ДокументыНаПечать КАК ОбщийДокумент
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РеализацияТоваровУслуг.Товары КАК ДокументТовары
	               |			ЛЕВОЕ СОЕДИНЕНИЕ Документ.РасчетСебестоимостиТоваров.Организации КАК РасчетСебестоимостиТоваровОрганизации
	               |			ПО (РасчетСебестоимостиТоваровОрганизации.Ссылка.Дата МЕЖДУ НАЧАЛОПЕРИОДА(ДокументТовары.Ссылка.Дата, МЕСЯЦ) И КОНЕЦПЕРИОДА(ДокументТовары.Ссылка.Дата, МЕСЯЦ))
	               |				И (РасчетСебестоимостиТоваровОрганизации.Ссылка.Проведен)
	               |				И ДокументТовары.Ссылка.Организация = РасчетСебестоимостиТоваровОрганизации.Организация
	               |			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Склады КАК Склады
	               |			ПО ДокументТовары.Склад = Склады.Ссылка
	               |				И (Склады.СкладОтветственногоХранения)
	               |				И ДокументТовары.Ссылка.Организация <> Склады.Поклажедержатель
	               |		ПО ОбщийДокумент.Документ = ДокументТовары.Ссылка
	               |ГДЕ
	               |	ОбщийДокумент.Ссылка В(&МассивДокументов)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Товары.Ссылка КАК Ссылка,
	               |	Товары.Склад КАК Склад,
	               |	Товары.Упаковка КАК Упаковка,
	               |	Товары.НомерСтроки КАК НомерСтроки,
	               |	Товары.Номенклатура КАК Номенклатура,
	               |	Товары.Характеристика КАК Характеристика,
	               |	ВЫБОР
	               |		КОГДА ЕСТЬNULL(Товары.Упаковка, ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)) = ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
	               |			ТОГДА Товары.Номенклатура.ЕдиницаИзмерения.Наименование
	               |		КОГДА Товары.Упаковка.ТипИзмеряемойВеличины = ЗНАЧЕНИЕ(Перечисление.ТипыИзмеряемыхВеличин.Упаковка)
	               |			ТОГДА Товары.Упаковка.ЕдиницаИзмерения.Наименование
	               |		ИНАЧЕ Товары.Упаковка.Наименование
	               |	КОНЕЦ КАК ЕдиницаИзмеренияНаименование,
	               |	ВЫБОР
	               |		КОГДА ЕСТЬNULL(Товары.Упаковка, ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)) = ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
	               |			ТОГДА Товары.Номенклатура.ЕдиницаИзмерения.Код
	               |		КОГДА Товары.Упаковка.ТипИзмеряемойВеличины = ЗНАЧЕНИЕ(Перечисление.ТипыИзмеряемыхВеличин.Упаковка)
	               |			ТОГДА Товары.Упаковка.ЕдиницаИзмерения.Код
	               |		ИНАЧЕ Товары.Упаковка.Код
	               |	КОНЕЦ КАК ЕдиницаИзмеренияКод,
	               |	ВЫБОР
	               |		КОГДА ЕСТЬNULL(Товары.Упаковка, ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)) = ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
	               |			ТОГДА Товары.Номенклатура.ЕдиницаИзмерения.Наименование
	               |		КОГДА Товары.Упаковка.ТипИзмеряемойВеличины = ЗНАЧЕНИЕ(Перечисление.ТипыИзмеряемыхВеличин.Упаковка)
	               |			ТОГДА Товары.Упаковка.ЕдиницаИзмерения.Наименование
	               |		ИНАЧЕ Товары.Упаковка.Наименование
	               |	КОНЕЦ КАК ВидУпаковки,
	               |	Товары.КоличествоУпаковок КАК КоличествоУпаковок,
	               |	Товары.Количество КАК Количество,
	               |	КОНЕЦПЕРИОДА(Товары.Ссылка.Дата, ДЕНЬ) КАК ДатаПолученияЦены,
	               |	Шапка.ВидЦены КАК ВидЦены,
	               |	Шапка.ВалютаЦены КАК ВалютаЦены,
	               |	Шапка.Ссылка КАК ОбщийДокумент
	               |ПОМЕСТИТЬ ВтТовары
	               |ИЗ
	               |	Документ.РеализацияТоваровУслуг.Товары КАК Товары
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтШапка КАК Шапка
	               |		ПО Товары.Склад = Шапка.Склад
	               |			И Товары.Ссылка = Шапка.ДокументСсылка
	               |ГДЕ
	               |	Товары.Номенклатура.ТипНоменклатуры В (ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар), ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))
	               |	И (Шапка.ИсточникИнформацииОЦенахДляПечати = ЗНАЧЕНИЕ(Перечисление.ИсточникиИнформацииОЦенахДляПечати.ПоВидуЦен)
	               |			ИЛИ Шапка.ИсточникИнформацииОЦенахДляПечати = ЗНАЧЕНИЕ(Перечисление.ИсточникиИнформацииОЦенахДляПечати.ПоСебестоимости)
	               |				И Шапка.ПредварительныйРасчет ЕСТЬ NULL)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВидыЗапасов.Ссылка КАК Ссылка,
	               |	ВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	               |	ВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	               |	Шапка.Организация КАК Организация,
	               |	Аналитика.Склад КАК Склад,
	               |	ВидыЗапасов.Упаковка КАК Упаковка,
	               |	ВидыЗапасов.НомерСтроки КАК НомерСтроки,
	               |	Аналитика.Номенклатура КАК Номенклатура,
	               |	Аналитика.Характеристика КАК Характеристика,
	               |	ВЫБОР
	               |		КОГДА ЕСТЬNULL(ВидыЗапасов.Упаковка, ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)) = ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
	               |			ТОГДА Аналитика.Номенклатура.ЕдиницаИзмерения.Наименование
	               |		КОГДА ВидыЗапасов.Упаковка.ТипИзмеряемойВеличины = ЗНАЧЕНИЕ(Перечисление.ТипыИзмеряемыхВеличин.Упаковка)
	               |			ТОГДА ВидыЗапасов.Упаковка.ЕдиницаИзмерения.Наименование
	               |		ИНАЧЕ ВидыЗапасов.Упаковка.Наименование
	               |	КОНЕЦ КАК ЕдиницаИзмеренияНаименование,
	               |	ВЫБОР
	               |		КОГДА ЕСТЬNULL(ВидыЗапасов.Упаковка, ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)) = ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
	               |			ТОГДА Аналитика.Номенклатура.ЕдиницаИзмерения.Код
	               |		КОГДА ВидыЗапасов.Упаковка.ТипИзмеряемойВеличины = ЗНАЧЕНИЕ(Перечисление.ТипыИзмеряемыхВеличин.Упаковка)
	               |			ТОГДА ВидыЗапасов.Упаковка.ЕдиницаИзмерения.Код
	               |		ИНАЧЕ ВидыЗапасов.Упаковка.Код
	               |	КОНЕЦ КАК ЕдиницаИзмеренияКод,
	               |	ВЫБОР
	               |		КОГДА ЕСТЬNULL(ВидыЗапасов.Упаковка, ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)) = ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
	               |			ТОГДА Аналитика.Номенклатура.ЕдиницаИзмерения.Наименование
	               |		КОГДА ВидыЗапасов.Упаковка.ТипИзмеряемойВеличины = ЗНАЧЕНИЕ(Перечисление.ТипыИзмеряемыхВеличин.Упаковка)
	               |			ТОГДА ВидыЗапасов.Упаковка.ЕдиницаИзмерения.Наименование
	               |		ИНАЧЕ ВидыЗапасов.Упаковка.Наименование
	               |	КОНЕЦ КАК ВидУпаковки,
	               |	ВидыЗапасов.КоличествоУпаковок КАК КоличествоУпаковок,
	               |	ВидыЗапасов.Количество КАК Количество,
	               |	КОНЕЦПЕРИОДА(ВидыЗапасов.Ссылка.Дата, ДЕНЬ) КАК ДатаПолученияЦены,
	               |	Аналитика.Склад.УчетныйВидЦены КАК ВидЦены,
	               |	Аналитика.Склад.УчетныйВидЦены.ВалютаЦены КАК ВалютаЦены,
	               |	Шапка.ПредварительныйРасчет КАК ПредварительныйРасчет,
	               |	Шапка.Ссылка КАК ОбщийДокумент
	               |ПОМЕСТИТЬ ВтВидыЗапасов
	               |ИЗ
	               |	Документ.РеализацияТоваровУслуг.ВидыЗапасов КАК ВидыЗапасов
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	               |		ПО ВидыЗапасов.АналитикаУчетаНоменклатуры = Аналитика.КлючАналитики
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтШапка КАК Шапка
	               |		ПО ВидыЗапасов.АналитикаУчетаНоменклатуры.Склад = Шапка.Склад
	               |			И ВидыЗапасов.Ссылка = Шапка.ДокументСсылка
	               |ГДЕ
	               |	Аналитика.Номенклатура.ТипНоменклатуры В (ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар), ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))
	               |	И Аналитика.Склад.ИсточникИнформацииОЦенахДляПечати = ЗНАЧЕНИЕ(Перечисление.ИсточникиИнформацииОЦенахДляПечати.ПоСебестоимости)
	               |;";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаНаименованиеЕдиницыИзмерения1",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаЗначениеРеквизитаЕдиницыИзмерения(
			"Наименование", "Товары.Упаковка", "Товары.Номенклатура"));
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаКодЕдиницыИзмерения1",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаЗначениеРеквизитаЕдиницыИзмерения(
			"Код", "Товары.Упаковка", "Товары.Номенклатура"));
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаНаименованиеЕдиницыИзмерения2",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаЗначениеРеквизитаЕдиницыИзмерения(
			"Наименование", "ВидыЗапасов.Упаковка", "Аналитика.Номенклатура"));
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаКодЕдиницыИзмерения2",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаЗначениеРеквизитаЕдиницыИзмерения(
			"Код", "ВидыЗапасов.Упаковка", "Аналитика.Номенклатура"));
	
	//СкладыСервер.ДополнитьТекстЗапросаДляПечатныхФормМХ1Х3(Запрос);
	ДополнитьТекстЗапросаДляПечатныхФормМХ1Х3(Запрос);
	//МассивДокументов = Новый Массив;
	//Для каждого ОбъектПечати Из МассивОбъектов Цикл
	//	Для каждого СтрокаДокументы Из ОбъектПечати.Документы Цикл
	//	
	//		МассивДокументов.Добавить(СтрокаДокументы.Документ);	
	//	
	//	КонецЦикла; 
	//КонецЦикла; 
	
	Запрос.УстановитьПараметр("МассивДокументов", МассивОбъектов);
	Запрос.УстановитьПараметр("УчитыватьСебестоимостьТоваровПоВидамЗапасов",
		ПолучитьФункциональнуюОпцию("УчитыватьСебестоимостьТоваровПоВидамЗапасов"));
	Запрос.УстановитьПараметр("КолонкаКодов", КолонкаКодов);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	РезультатПоШапке = МассивРезультатов[6];
	РезультатПоСкладам = МассивРезультатов[7];
	РезультатПоТабличнойЧасти = МассивРезультатов[8];
	
	СтруктураДанныхДляПечати = Новый Структура(
		"РезультатПоШапке, РезультатПоСкладам, РезультатПоТабличнойЧасти",
		РезультатПоШапке,
		РезультатПоСкладам,
		РезультатПоТабличнойЧасти);
		
	Возврат СтруктураДанныхДляПечати
	
КонецФункции

// Дополняет текст запроса для формирования печатных форм МХ-1, МХ-3
//
//Параметры:
//	Запрос - Запрос - Выполняемый запрос
//
Процедура ДополнитьТекстЗапросаДляПечатныхФормМХ1Х3(Запрос) Экспорт
	
	ТекстЗапроса = "ВЫБРАТЬ
	               |	ПериодыЦенНоменклатуры.Ссылка,
	               |	ПериодыЦенНоменклатуры.НомерСтроки,
	               |	ЦеныНоменклатуры.Цена,
	               |	ЦеныНоменклатуры.Упаковка
	               |ПОМЕСТИТЬ ЦеныПоВидуЦен
	               |ИЗ
	               |	(ВЫБРАТЬ
	               |		Товары.Ссылка КАК Ссылка,
	               |		Товары.НомерСтроки КАК НомерСтроки,
	               |		ЦеныНоменклатуры.ВидЦены КАК ВидЦены,
	               |		ЦеныНоменклатуры.Номенклатура КАК Номенклатура,
	               |		ЦеныНоменклатуры.Характеристика КАК Характеристика,
	               |		МАКСИМУМ(ЦеныНоменклатуры.Период) КАК Период
	               |	ИЗ
	               |		ВтТовары КАК Товары
	               |			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры КАК ЦеныНоменклатуры
	               |			ПО Товары.ВидЦены = ЦеныНоменклатуры.ВидЦены
	               |				И Товары.Номенклатура = ЦеныНоменклатуры.Номенклатура
	               |				И Товары.Характеристика = ЦеныНоменклатуры.Характеристика
	               |				И Товары.ДатаПолученияЦены >= ЦеныНоменклатуры.Период
	               |				И Товары.ВалютаЦены = ЦеныНоменклатуры.Валюта
	               |	
	               |	СГРУППИРОВАТЬ ПО
	               |		Товары.Ссылка,
	               |		Товары.НомерСтроки,
	               |		ЦеныНоменклатуры.ВидЦены,
	               |		ЦеныНоменклатуры.Номенклатура,
	               |		ЦеныНоменклатуры.Характеристика) КАК ПериодыЦенНоменклатуры
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры КАК ЦеныНоменклатуры
	               |		ПО ПериодыЦенНоменклатуры.Период = ЦеныНоменклатуры.Период
	               |			И ПериодыЦенНоменклатуры.ВидЦены = ЦеныНоменклатуры.ВидЦены
	               |			И ПериодыЦенНоменклатуры.Номенклатура = ЦеныНоменклатуры.Номенклатура
	               |			И ПериодыЦенНоменклатуры.Характеристика = ЦеныНоменклатуры.Характеристика
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ПериодыСтоимостиТоваров.Ссылка,
	               |	СтоимостьТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	               |	СтоимостьТоваров.ВидЗапасов КАК ВидЗапасов,
	               |	СтоимостьТоваров.Организация КАК Организация,
	               |	СтоимостьТоваров.СтоимостьРегл КАК Стоимость
	               |ПОМЕСТИТЬ ЦеныПоСебестоимостиПредварительно
	               |ИЗ
	               |	(ВЫБРАТЬ
	               |		ВидыЗапасов.Ссылка КАК Ссылка,
	               |		СтоимостьТоваров.ВидЗапасов КАК ВидЗапасов,
	               |		СтоимостьТоваров.Организация КАК Организация,
	               |		СтоимостьТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	               |		МАКСИМУМ(СтоимостьТоваров.Период) КАК Период
	               |	ИЗ
	               |		ВтВидыЗапасов КАК ВидыЗапасов
	               |			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СтоимостьТоваров КАК СтоимостьТоваров
	               |			ПО ВидыЗапасов.АналитикаУчетаНоменклатуры = СтоимостьТоваров.АналитикаУчетаНоменклатуры
	               |				И ВидыЗапасов.Организация = СтоимостьТоваров.Организация
	               |				И (ВидыЗапасов.ВидЗапасов = СтоимостьТоваров.ВидЗапасов
	               |						И &УчитыватьСебестоимостьТоваровПоВидамЗапасов
	               |					ИЛИ НЕ &УчитыватьСебестоимостьТоваровПоВидамЗапасов)
	               |				И ВидыЗапасов.ДатаПолученияЦены >= СтоимостьТоваров.Период
	               |				И (ВидыЗапасов.ПредварительныйРасчет)
	               |	
	               |	СГРУППИРОВАТЬ ПО
	               |		ВидыЗапасов.Ссылка,
	               |		СтоимостьТоваров.ВидЗапасов,
	               |		СтоимостьТоваров.Организация,
	               |		СтоимостьТоваров.АналитикаУчетаНоменклатуры) КАК ПериодыСтоимостиТоваров
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СтоимостьТоваров КАК СтоимостьТоваров
	               |		ПО ПериодыСтоимостиТоваров.АналитикаУчетаНоменклатуры = СтоимостьТоваров.АналитикаУчетаНоменклатуры
	               |			И ПериодыСтоимостиТоваров.Организация = СтоимостьТоваров.Организация
	               |			И ПериодыСтоимостиТоваров.Период = СтоимостьТоваров.Период
	               |			И (ПериодыСтоимостиТоваров.ВидЗапасов = СтоимостьТоваров.ВидЗапасов
	               |					И &УчитыватьСебестоимостьТоваровПоВидамЗапасов
	               |				ИЛИ НЕ &УчитыватьСебестоимостьТоваровПоВидамЗапасов)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВидыЗапасов.Ссылка КАК Ссылка,
	               |	СебестоимостьТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	               |	СебестоимостьТоваров.ВидЗапасов КАК ВидЗапасов,
	               |	СебестоимостьТоваров.Организация КАК Организация,
	               |	СУММА(СебестоимостьТоваров.СтоимостьРегл) КАК Стоимость
	               |ПОМЕСТИТЬ ЦеныПоСебестоимости
	               |ИЗ
	               |	РегистрНакопления.СебестоимостьТоваров КАК СебестоимостьТоваров
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтВидыЗапасов КАК ВидыЗапасов
	               |		ПО (ВидыЗапасов.Ссылка = СебестоимостьТоваров.ДокументДвижения
	               |				ИЛИ ВидыЗапасов.Ссылка = СебестоимостьТоваров.Регистратор)
	               |			И (ВидыЗапасов.АналитикаУчетаНоменклатуры = СебестоимостьТоваров.АналитикаУчетаНоменклатуры)
	               |			И (ВидыЗапасов.Организация = СебестоимостьТоваров.Организация)
	               |			И (ВидыЗапасов.ВидЗапасов = СебестоимостьТоваров.ВидЗапасов
	               |					И &УчитыватьСебестоимостьТоваровПоВидамЗапасов
	               |				ИЛИ НЕ &УчитыватьСебестоимостьТоваровПоВидамЗапасов)
	               |			И (НЕ ВидыЗапасов.ПредварительныйРасчет)
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ВидыЗапасов.Ссылка,
	               |	СебестоимостьТоваров.АналитикаУчетаНоменклатуры,
	               |	СебестоимостьТоваров.ВидЗапасов,
	               |	СебестоимостьТоваров.Организация
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	ВтШапка.Ссылка КАК Ссылка,
	               |	ВтШапка.Номер КАК Номер,
	               |	ВтШапка.Дата КАК Дата,
	               |	ВтШапка.ДатаДокумента КАК ДатаДокумента,
	               |	ВтШапка.Организация КАК Организация
	               |ИЗ
	               |	ВтШапка КАК ВтШапка
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Склады КАК Склады
	               |		ПО ВтШапка.Склад = Склады.Ссылка
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	ВтШапка.Ссылка КАК Ссылка,
	               |	ВтШапка.ПредварительныйРасчет КАК ПредварительныйРасчет,
	               |	Склады.ИсточникИнформацииОЦенахДляПечати КАК ИсточникИнформацииОЦенахДляПечати,
	               |	ПРЕДСТАВЛЕНИЕ(ВтШапка.Склад) КАК ПредставлениеСклада,
	               |	ВтШапка.Склад КАК Склад,
	               |	ВтШапка.ВидЦены КАК ВидЦены,
	               |	ВтШапка.ВалютаЦены КАК ВалютаЦены,
	               |	ПРЕДСТАВЛЕНИЕ(Склады.Подразделение) КАК ПредставлениеПодразделения,
	               |	Склады.Поклажедержатель КАК Поклажедержатель,
	               |	ВЫБОР
	               |		КОГДА Склады.ОтветственноеХранениеДоВостребования
	               |			ТОГДА &довостребования
	               |		ИНАЧЕ Склады.СрокОтветственногоХранения
	               |	КОНЕЦ КАК СрокХранения,
	               |	ВЫРАЗИТЬ(Склады.ОсобыеОтметки КАК СТРОКА(250)) КАК ОсобыеОтметки,
	               |	ВЫРАЗИТЬ(Склады.УсловияХраненияТоваров КАК СТРОКА(250)) КАК УсловияХранения,
	               |	Склады.ТекущаяДолжностьОтветственного КАК ДолжностьМОЛ,
	               |	Склады.ТекущийОтветственный КАК МОЛ
	               |ИЗ
	               |	ВтШапка КАК ВтШапка
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Склады КАК Склады
	               |		ПО ВтШапка.Склад = Склады.Ссылка
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВТ.Ссылка КАК Ссылка,
	               |	ВТ.Склад КАК Склад,
	               |	ВТ.НоменклатураКод,
	               |	ВТ.Номенклатура,
	               |	ВТ.ПредставлениеНоменклатуры,
	               |	ВТ.ПредставлениеХарактеристики,
	               |	ВТ.ЕдиницаИзмеренияНаименование,
	               |	ВТ.ЕдиницаИзмеренияКод,
	               |	СУММА(ВТ.Количество) КАК Количество,
	               |	ВТ.ВидУпаковки,
	               |	СУММА(ВТ.Сумма) КАК Сумма,
	               |	ВТ.Цена
	               |ИЗ
	               |	(ВЫБРАТЬ
	               |		Товары.ОбщийДокумент КАК Ссылка,
	               |		Товары.Склад КАК Склад,
	               |		ВЫБОР
	               |			КОГДА &КолонкаКодов = ""Артикул""
	               |				ТОГДА Товары.Номенклатура.Артикул
	               |			ИНАЧЕ Товары.Номенклатура.Код
	               |		КОНЕЦ КАК НоменклатураКод,
	               |		Товары.Номенклатура КАК Номенклатура,
	               |		Товары.Номенклатура.НаименованиеПолное КАК ПредставлениеНоменклатуры,
	               |		Товары.Характеристика.НаименованиеПолное КАК ПредставлениеХарактеристики,
	               |		Товары.ЕдиницаИзмеренияНаименование КАК ЕдиницаИзмеренияНаименование,
	               |		Товары.ЕдиницаИзмеренияКод КАК ЕдиницаИзмеренияКод,
	               |		Товары.КоличествоУпаковок КАК Количество,
	               |		Товары.ВидУпаковки КАК ВидУпаковки,
	               |		ВЫРАЗИТЬ(ЕСТЬNULL(Цены.Цена, 0) / ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки, 1) * Товары.Количество КАК ЧИСЛО(15, 2)) КАК Сумма,
	               |		ВЫБОР
	               |			КОГДА Товары.КоличествоУпаковок = 0
	               |				ТОГДА ВЫРАЗИТЬ(ЕСТЬNULL(Цены.Цена, 0) / ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки, 1) * Товары.Количество КАК ЧИСЛО(15, 2))
	               |			ИНАЧЕ ВЫРАЗИТЬ(ЕСТЬNULL(Цены.Цена, 0) / ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки, 1) * Товары.Количество / Товары.КоличествоУпаковок КАК ЧИСЛО(15, 2))
	               |		КОНЕЦ КАК Цена,
	               |		Товары.Ссылка КАК ДокументСсылка
	               |	ИЗ
	               |		ВтТовары КАК Товары
	               |			ЛЕВОЕ СОЕДИНЕНИЕ ЦеныПоВидуЦен КАК Цены
	               |			ПО Товары.Ссылка = Цены.Ссылка
	               |				И Товары.НомерСтроки = Цены.НомерСтроки
	               |	
	               |	ОБЪЕДИНИТЬ ВСЕ
	               |	
	               |	ВЫБРАТЬ
	               |		ВидыЗапасов.Ссылка,
	               |		ВидыЗапасов.Склад,
	               |		ВЫБОР
	               |			КОГДА &КолонкаКодов = ""Артикул""
	               |				ТОГДА ВидыЗапасов.Номенклатура.Артикул
	               |			ИНАЧЕ ВидыЗапасов.Номенклатура.Код
	               |		КОНЕЦ,
	               |		ВидыЗапасов.Номенклатура,
	               |		ВидыЗапасов.Номенклатура.НаименованиеПолное,
	               |		ВидыЗапасов.Характеристика.НаименованиеПолное,
	               |		ВидыЗапасов.ЕдиницаИзмеренияНаименование,
	               |		ВидыЗапасов.ЕдиницаИзмеренияКод,
	               |		ВидыЗапасов.КоличествоУпаковок,
	               |		ВидыЗапасов.ВидУпаковки,
	               |		Цены.Стоимость,
	               |		ВЫБОР
	               |			КОГДА ВидыЗапасов.КоличествоУпаковок = 0
	               |				ТОГДА Цены.Стоимость
	               |			ИНАЧЕ Цены.Стоимость / ВидыЗапасов.КоличествоУпаковок
	               |		КОНЕЦ,
	               |		ВидыЗапасов.Ссылка
	               |	ИЗ
	               |		ВтВидыЗапасов КАК ВидыЗапасов
	               |			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ЦеныПоСебестоимостиПредварительно КАК Цены
	               |			ПО ВидыЗапасов.Ссылка = Цены.Ссылка
	               |				И ВидыЗапасов.АналитикаУчетаНоменклатуры = Цены.АналитикаУчетаНоменклатуры
	               |				И ВидыЗапасов.Организация = Цены.Организация
	               |				И (ВидыЗапасов.ВидЗапасов = Цены.ВидЗапасов
	               |						И &УчитыватьСебестоимостьТоваровПоВидамЗапасов
	               |					ИЛИ НЕ &УчитыватьСебестоимостьТоваровПоВидамЗапасов)
	               |	
	               |	ОБЪЕДИНИТЬ ВСЕ
	               |	
	               |	ВЫБРАТЬ
	               |		ВидыЗапасов.Ссылка,
	               |		ВидыЗапасов.Склад,
	               |		ВЫБОР
	               |			КОГДА &КолонкаКодов = ""Артикул""
	               |				ТОГДА ВидыЗапасов.Номенклатура.Артикул
	               |			ИНАЧЕ ВидыЗапасов.Номенклатура.Код
	               |		КОНЕЦ,
	               |		ВидыЗапасов.Номенклатура,
	               |		ВидыЗапасов.Номенклатура.НаименованиеПолное,
	               |		ВидыЗапасов.Характеристика.НаименованиеПолное,
	               |		ВидыЗапасов.ЕдиницаИзмеренияНаименование,
	               |		ВидыЗапасов.ЕдиницаИзмеренияКод,
	               |		ВидыЗапасов.КоличествоУпаковок,
	               |		ВидыЗапасов.ВидУпаковки,
	               |		Цены.Стоимость,
	               |		ВЫБОР
	               |			КОГДА ВидыЗапасов.КоличествоУпаковок = 0
	               |				ТОГДА Цены.Стоимость
	               |			ИНАЧЕ Цены.Стоимость / ВидыЗапасов.КоличествоУпаковок
	               |		КОНЕЦ,
	               |		ВидыЗапасов.Ссылка
	               |	ИЗ
	               |		ВтВидыЗапасов КАК ВидыЗапасов
	               |			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ЦеныПоСебестоимости КАК Цены
	               |			ПО ВидыЗапасов.Ссылка = Цены.Ссылка
	               |				И ВидыЗапасов.АналитикаУчетаНоменклатуры = Цены.АналитикаУчетаНоменклатуры
	               |				И ВидыЗапасов.Организация = Цены.Организация
	               |				И (ВидыЗапасов.ВидЗапасов = Цены.ВидЗапасов
	               |						И &УчитыватьСебестоимостьТоваровПоВидамЗапасов
	               |					ИЛИ НЕ &УчитыватьСебестоимостьТоваровПоВидамЗапасов)) КАК ВТ
	               |
	               |СГРУППИРОВАТЬ ПО	               
	               |	ВТ.ВидУпаковки,
	               |	ВТ.Ссылка,
	               |	ВТ.НоменклатураКод,
	               |	ВТ.ПредставлениеНоменклатуры,
	               |	ВТ.ПредставлениеХарактеристики,
	               |	ВТ.Номенклатура,
	               |	ВТ.ЕдиницаИзмеренияНаименование,
	               |	ВТ.Склад,
	               |	ВТ.ЕдиницаИзмеренияКод,
	               |	ВТ.Цена
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ВТ.Ссылка
	               |ИТОГИ ПО
	               |	Ссылка,
	               |	Склад";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
		"&ТекстЗапросаКоэффициентУпаковки",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
		"Цены.Упаковка",
		"Товары.Номенклатура"));
	
	Запрос.Текст = Запрос.Текст + ТекстЗапроса;
	Запрос.УстановитьПараметр("довостребования", НСтр("ru='до востребования'"));
	
КонецПроцедуры

#КонецОбласти
