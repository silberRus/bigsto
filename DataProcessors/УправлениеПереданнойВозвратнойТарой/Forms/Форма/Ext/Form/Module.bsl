﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(ОтборСрокВозврата) Тогда
		Актуальность = НСтр("ru='Любой'");
	КонецЕсли;
	ПереданнаяТара.Параметры.УстановитьЗначениеПараметра("ДатаВозврата", НачалоДня(ТекущаяДатаСеанса()));
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ДокументыВозвратаТары,
		"Менеджер",
		ОтборМенеджер,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(ОтборМенеджер));
	
	ОтборыСписковКлиентСервер.СкопироватьСписокВыбораОтбораПоМенеджеру(
		Элементы.ОтборМенеджер.СписокВыбора,
		ОбщегоНазначенияУТ.ПолучитьСписокПользователейСПравомДобавления(Метаданные.Документы.ВозвратТоваровОтКлиента));
		
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриСозданииНаСервереСписокДокументов(ДокументыВыкупаТары);
	
	Если Не ПроверкаКонтрагентовВызовСервера.ИспользованиеПроверкиВозможно() Тогда
		Элементы.ДокументыВыкупаТарыЕстьОшибкиПроверкиКонтрагентов.Видимость = Ложь;
	КонецЕсли;
	
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
		
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	СписокТипов = ДокументыВозвратаТары.КомпоновщикНастроек.Настройки.Выбор.ДоступныеПоляВыбора.НайтиПоле(Новый ПолеКомпоновкиДанных("Ссылка")).Тип;
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = СписокТипов;
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ДокументыВозвратаТарыКоманднаяПанель;
	ПараметрыРазмещения.ПрефиксГрупп = "ДокументыВозвратаТары";
	
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	
	СписокТипов = ДокументыВыкупаТары.КомпоновщикНастроек.Настройки.Выбор.ДоступныеПоляВыбора.НайтиПоле(Новый ПолеКомпоновкиДанных("Ссылка")).Тип;
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = СписокТипов;
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ДокументыВыкупаТарыКоманднаяПанель;
	ПараметрыРазмещения.ПрефиксГрупп = "ДокументыВыкупаТары";

	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "ДокументыВозвратаТары.Дата", Элементы.ДокументыВозвратаТарыДата.Имя);
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "ДокументыВыкупаТары.Дата", Элементы.ДокументыВыкупаТарыДата.Имя);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ОтборМенеджер     = Настройки.Получить("ОтборМенеджер");
	ОтборПартнер      = Настройки.Получить("ОтборПартнер");
	ОтборДатаВозврата = Настройки.Получить("ОтборДатаВозврата");
	ОтборСрокВозврата = Настройки.Получить("ОтборСрокВозврата");
	
	УстановитьОтборПоМенеджеру();
	УстановитьОтборПоПартнеру();
	УстановитьОтборВСпискеПоСрокуВозврата(ПереданнаяТара, ОтборСрокВозврата);
	УстановитьОтборВСпискеПоДатеВозврата(ПереданнаяТара, ОтборДатаВозврата);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_РеализацияТоваровУслуг"
		Или ИмяСобытия = "Запись_ВозвратТоваровОтКлиента"
		Или ИмяСобытия = "Запись_ВыкупВозвратнойТарыКлиентом" Тогда
		Элементы.ПереданнаяТара.Обновить();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборСрокВозвратаПриИзменении(Элемент)

	ПриИзмененииОтбораПоСрокуВозврата(ПереданнаяТара, ОтборСрокВозврата, ОтборДатаВозврата);

КонецПроцедуры

&НаКлиенте
Процедура ОтборСрокВозвратаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ВыбранноеЗначение = "Истекает на дату" Тогда
		
		ОткрытьФорму(
			"ОбщаяФорма.ВыборДаты",
			Новый Структура("НачальноеЗначение"),,,,,
			Новый ОписаниеОповещения("ПриВыбореСрокаВозвратаВыборДатыЗавершение", ЭтотОбъект));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСрокВозвратаОчистка(Элемент, СтандартнаяОбработка)
	
	ПриОчисткеОтбораПоСрокуВозврата(ПереданнаяТара, ОтборСрокВозврата, ОтборДатаВозврата, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПартнерПриИзменении(Элемент)
	
	УстановитьОтборПоПартнеру();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборМенеджерПриИзменении(Элемент)
	
	УстановитьОтборПоМенеджеру();
	
КонецПроцедуры

&НаКлиенте
Процедура ПереданнаяТараВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ПереданнаяТара.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Или Не ЗначениеЗаполнено(ТекущиеДанные.ДокументПередачи) Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьЗначение(Неопределено, ТекущиеДанные.ДокументПередачи);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОформитьЗаявкуНаВозвратТары(Команда)
	
	ОформитьДокумент("Заявка");
	
КонецПроцедуры

&НаКлиенте
Процедура ОформитьВозвратТары(Команда)
	
	ОформитьДокумент("Возврат");
	
КонецПроцедуры

&НаКлиенте
Процедура ОформитьВыкупТары(Команда)
	
	ОформитьДокумент("Выкуп");
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаДокументыВозвратаТары Тогда
		ТекущийСписок = Элементы.ДокументыВозвратаТары;
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаДокументыВыкупаТары Тогда
		ТекущийСписок = Элементы.ДокументыВыкупаТары;
	Иначе
		Возврат;
	КонецЕсли;
	
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, ТекущийСписок);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаДокументыВозвратаТары Тогда
		ТекущийСписок = Элементы.ДокументыВозвратаТары;
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаДокументыВыкупаТары Тогда
		ТекущийСписок = Элементы.ДокументыВыкупаТары;
	Иначе
		Возврат;
	КонецЕсли;
	
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, ТекущийСписок, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаДокументыВозвратаТары Тогда
		ТекущийСписок = Элементы.ДокументыВозвратаТары;
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаДокументыВыкупаТары Тогда
		ТекущийСписок = Элементы.ДокументыВыкупаТары;
	Иначе
		Возврат;
	КонецЕсли;
	
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, ТекущийСписок);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция СообщитьОбОшибкахФормированияДанныхЗаполненияВозвратаВыкупаТары(ВыборкаРеквизиты)
	
	Отказ = Ложь;
	
	ТекстСообщения = НСтр("ru='У выделенных строк в документе поступления отличается поле ""%ПредставлениеПоля%""'");
	
	Если ВыборкаРеквизиты.ЕстьОтличияПартнер Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтрЗаменить(ТекстСообщения, "%ПредставлениеПоля%", НСтр("ru='Клиент'")),
			,
			,
			,
			Отказ);
		
	КонецЕсли;
	
	
	Если ВыборкаРеквизиты.ЕстьОтличияКонтрагент Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтрЗаменить(ТекстСообщения, "%ПредставлениеПоля%", НСтр("ru='Контрагент'")),
			,
			,
			,
			Отказ);
		
	КонецЕсли;
	
	Если ВыборкаРеквизиты.ЕстьОтличияОрганизация Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтрЗаменить(ТекстСообщения, "%ПредставлениеПоля%", НСтр("ru='Организация'")),
			,
			,
			,
			Отказ);
		
	КонецЕсли;
	
	Если ВыборкаРеквизиты.ЕстьОтличияСоглашение Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтрЗаменить(ТекстСообщения, "%ПредставлениеПоля%", НСтр("ru='Соглашение'")),
			,
			,
			,
			Отказ);
		
	КонецЕсли;
	
	Если ВыборкаРеквизиты.ЕстьОтличияНаправлениеДеятельности Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтрЗаменить(ТекстСообщения, "%ПредставлениеПоля%", НСтр("ru='Направление деятельности'")),
			,
			,
			,
			Отказ);
		
	КонецЕсли;
	
	Если ВыборкаРеквизиты.ЕстьОтличияДоговор Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтрЗаменить(ТекстСообщения, "%ПредставлениеПоля%", НСтр("ru='Договор'")),
			,
			,
			,
			Отказ);
		
	КонецЕсли;
	
	Если ВыборкаРеквизиты.ЕстьОтличияХозяйственнаяОперация Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтрЗаменить(ТекстСообщения, "%ПредставлениеПоля%", НСтр("ru='Операция'")),
			,
			,
			,
			Отказ);
		
	КонецЕсли;
	
	Если ВыборкаРеквизиты.ЕстьОтличияВалюта Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтрЗаменить(ТекстСообщения, "%ПредставлениеПоля%", НСтр("ru='Валюта'")),
			,
			,
			,
			Отказ);
		
	КонецЕсли;
	
	Если ВыборкаРеквизиты.ЕстьОтличияВалютаВзаиморасчетов Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтрЗаменить(ТекстСообщения, "%ПредставлениеПоля%", НСтр("ru='Валюта взаиморасчетов'")),
			,
			,
			,
			Отказ);
		
	КонецЕсли;
	
	Если ВыборкаРеквизиты.ЕстьОтличияНалогообложениеНДС Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтрЗаменить(ТекстСообщения, "%ПредставлениеПоля%", НСтр("ru='Налогообложение НДС'")),
			,
			,
			,
			Отказ);
		
	КонецЕсли;
	
	Если ВыборкаРеквизиты.ЕстьОтличияПредусмотренЗалогЗаТару Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтрЗаменить(ТекстСообщения, "%ПредставлениеПоля%", НСтр("ru='Предусмотрен залог'")),
			,
			,
			,
			Отказ);
		
	КонецЕсли;
	
	Возврат Отказ;
	
КонецФункции

&НаКлиенте
Процедура ПриВыбореСрокаВозвратаВыборДатыЗавершение(ДатаВозврата, ДополнительныеПараметры) Экспорт
	
	ОтборДатаВозврата = ДатаВозврата;
	
	Если ЗначениеЗаполнено(ДатаВозврата) Тогда
		
		ОтборСрокВозврата = НСтр("ru='Истекает на %Дата%'");
		ОтборСрокВозврата = СтрЗаменить(ОтборСрокВозврата, "%Дата%", Формат(ДатаВозврата, "ДЛФ=D"));
		
	КонецЕсли;
	
	ПриИзмененииОтбораПоСрокуВозврата(ПереданнаяТара, ОтборСрокВозврата, ОтборДатаВозврата);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОчисткеОтбораПоСрокуВозврата(Список, СрокВозврата, ДатаВозврата, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если СрокВозврата <> "Любой" Тогда
		СрокВозврата = НСтр("ru='Любой'");
		ПриИзмененииОтбораПоСрокуВозврата(Список, СрокВозврата, ДатаВозврата);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииОтбораПоСрокуВозврата(Список, СрокВозврата, ДатаВозврата)
	
	УстановитьОтборВСпискеПоСрокуВозврата(Список, СрокВозврата);
	
	НеПоказыватьВсе = (СрокВозврата <> "Любой");
	
	Если Не НеПоказыватьВсе Тогда
		ДатаВозврата = Дата(1,1,1);
	КонецЕсли;
	
	УстановитьОтборВСпискеПоДатеВозврата(Список, ДатаВозврата);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборВСпискеПоСрокуВозврата(Список, СрокВозврата)
	
	ЗначениеОтбора = (СрокВозврата = "Просрочен" Или СтрНайти(СрокВозврата, "Истекает на") > 0);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Просрочен",
		ЗначениеОтбора,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(СрокВозврата) И СрокВозврата <> "Любой");
	
КонецПроцедуры 

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборВСпискеПоДатеВозврата(Список, ДатаВозврата)
	
	Если ЗначениеЗаполнено(ДатаВозврата) Тогда
		Список.Параметры.УстановитьЗначениеПараметра("ДатаВозврата", ДатаВозврата);
	Иначе
		#Если Клиент Тогда
			Список.Параметры.УстановитьЗначениеПараметра("ДатаВозврата", НачалоДня(ОбщегоНазначенияКлиент.ДатаСеанса()));
		#Иначе
			Список.Параметры.УстановитьЗначениеПараметра("ДатаВозврата", НачалоДня(ТекущаяДатаСеанса()));
		#КонецЕсли
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОформитьДокумент(ТипОперации)
	
	Если Элементы.ПереданнаяТара.ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Команда не может быть выполнена для указанного объекта.'"));
		Возврат;
	КонецЕсли;
	
	МассивСтрок = Новый Массив();
	
	Для Каждого ТекСтрока Из Элементы.ПереданнаяТара.ВыделенныеСтроки Цикл
		
		Если ТипЗнч(ТекСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			Продолжить;
		КонецЕсли;
		
		ДанныеСтроки = Элементы.ПереданнаяТара.ДанныеСтроки(ТекСтрока);
		МассивСтрок.Добавить(ДанныеСтроки);
		
	КонецЦикла;
	
	
	Если ТипОперации = "Заявка" Тогда
		ИмяФормыДокумента = "Документ.ЗаявкаНаВозвратТоваровОтКлиента.Форма.ФормаДокумента";
	ИначеЕсли ТипОперации = "Возврат" Тогда
		ИмяФормыДокумента = "Документ.ВозвратТоваровОтКлиента.Форма.ФормаДокумента";
	Иначе // Выкуп
		ИмяФормыДокумента = "Документ.ВыкупВозвратнойТарыКлиентом.Форма.ФормаДокумента";
	КонецЕсли;
	
	Если МассивСтрок.Количество() > 0 Тогда
		
		ОчиститьСообщения();
		СтруктураРеквизитов = ПоместитьТаруВоВременноеХранилищеСервер(МассивСтрок);
		Если СтруктураРеквизитов <> Неопределено Тогда
			ОткрытьФорму(ИмяФормыДокумента, Новый Структура("Основание", СтруктураРеквизитов));
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПоместитьТаруВоВременноеХранилищеСервер(МассивСтрок)
	
	ТипРеализации = Новый ОписаниеТипов("ДокументСсылка.РеализацияТоваровУслуг");
	
	ТаблицаТары = Новый ТаблицаЗначений();
	ТаблицаТары.Колонки.Добавить("Партнер",                 Новый ОписаниеТипов("СправочникСсылка.Партнеры"));
	ТаблицаТары.Колонки.Добавить("Номенклатура",            Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТаблицаТары.Колонки.Добавить("Характеристика",          Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	ТаблицаТары.Колонки.Добавить("Количество",              Новый ОписаниеТипов("Число"));
	ТаблицаТары.Колонки.Добавить("Сумма",                   Новый ОписаниеТипов("Число"));
	ТаблицаТары.Колонки.Добавить("ДокументРеализации",      ТипРеализации);
	ТаблицаТары.Колонки.Добавить("ПредусмотренЗалогЗаТару", Новый ОписаниеТипов("Булево"));
	
	Для Каждого ТекСтрока Из МассивСтрок Цикл
		
		НоваяСтрока = ТаблицаТары.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
		НоваяСтрока.Количество = ТекСтрока.КоличествоОстаток;
		НоваяСтрока.Сумма = ТекСтрока.СуммаОстаток;
		НоваяСтрока.ДокументРеализации = ТекСтрока.ДокументПередачи;
		НоваяСтрока.ПредусмотренЗалогЗаТару = ТекСтрока.ПредусмотренЗалогЗаТару;
		
	КонецЦикла;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ТаблицаТары.Партнер                 КАК Партнер,
	|	ТаблицаТары.Номенклатура            КАК Номенклатура,
	|	ТаблицаТары.Характеристика          КАК Характеристика,
	|	ТаблицаТары.Количество              КАК Количество,
	|	ТаблицаТары.ДокументРеализации      КАК ДокументРеализации,
	|	ТаблицаТары.ПредусмотренЗалогЗаТару КАК ПредусмотренЗалогЗаТару
	|ПОМЕСТИТЬ
	|	втТаблицаТары
	|ИЗ
	|	&ТаблицаТары КАК ТаблицаТары
	|;
	|ВЫБРАТЬ
	|	МИНИМУМ(втТаблицаТары.Партнер)                                       КАК Партнер,
	|	МИНИМУМ(втТаблицаТары.ДокументРеализации.Контрагент)                 КАК Контрагент,
	|	МИНИМУМ(втТаблицаТары.ДокументРеализации.Договор)                    КАК Договор,
	|	МИНИМУМ(втТаблицаТары.ДокументРеализации.Организация)                КАК Организация,
	|	МИНИМУМ(втТаблицаТары.ДокументРеализации.Соглашение)                 КАК Соглашение,
	|	МИНИМУМ(втТаблицаТары.ДокументРеализации.НаправлениеДеятельности)    КАК НаправлениеДеятельности,
	|	МИНИМУМ(втТаблицаТары.ДокументРеализации.ХозяйственнаяОперация)      КАК ХозяйственнаяОперация,
	|	МИНИМУМ(втТаблицаТары.ДокументРеализации.Валюта)                     КАК Валюта,
	|	МИНИМУМ(ВЫБОР
	|				КОГДА втТаблицаТары.ДокументРеализации ССЫЛКА Документ.РеализацияТоваровУслуг 
	|					ТОГДА втТаблицаТары.ДокументРеализации.ВалютаВзаиморасчетов
	|				ИНАЧЕ втТаблицаТары.ДокументРеализации.Валюта
	|			КОНЕЦ)                                                               КАК ВалютаВзаиморасчетов,
	|	МИНИМУМ(
	|	ВЫБОР
	|		КОГДА втТаблицаТары.ДокументРеализации ССЫЛКА Документ.РеализацияТоваровУслуг ТОГДА
	|			ВЫБОР
	|				КОГДА &ИспользоватьСоглашенияСКлиентами
	|					ТОГДА втТаблицаТары.ДокументРеализации.Соглашение.ФормаОплаты
	|				ИНАЧЕ втТаблицаТары.ДокументРеализации.ФормаОплаты
	|			КОНЕЦ
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ)                                                               КАК ФормаОплаты,
	|	МИНИМУМ(
	|	ВЫБОР
	|		КОГДА втТаблицаТары.ДокументРеализации ССЫЛКА Документ.РеализацияТоваровУслуг ТОГДА
	|			ВЫБОР
	|				КОГДА &ИспользоватьСоглашенияСКлиентами
	|					ТОГДА втТаблицаТары.ДокументРеализации.Соглашение.ЦенаВключаетНДС
	|				ИНАЧЕ втТаблицаТары.ДокументРеализации.ЦенаВключаетНДС
	|			КОНЕЦ
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ)                                                               КАК ЦенаВключаетНДС,
	|	МИНИМУМ(втТаблицаТары.ДокументРеализации.НалогообложениеНДС)         КАК НалогообложениеНДС,
	|	МИНИМУМ(втТаблицаТары.ПредусмотренЗалогЗаТару)                       КАК ПредусмотренЗалогЗаТару,
	|	ВЫБОР
	|		КОГДА
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ втТаблицаТары.ДокументРеализации.Склад) = 1 И
	|			МАКСИМУМ(втТаблицаТары.ДокументРеализации.Склад.ЭтоГруппа) = ЛОЖЬ
	|		ТОГДА
	|			МАКСИМУМ(втТаблицаТары.ДокументРеализации.Склад)
	|		ИНАЧЕ
	|			ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	|	КОНЕЦ КАК Склад,
	|	ВЫБОР
	|		КОГДА
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ втТаблицаТары.Партнер) > 1
	|		ТОГДА
	|			ИСТИНА
	|		ИНАЧЕ
	|			ЛОЖЬ
	|	КОНЕЦ КАК ЕстьОтличияПартнер,
	|	ВЫБОР
	|		КОГДА
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ втТаблицаТары.ДокументРеализации.Контрагент) > 1
	|		ТОГДА
	|			ИСТИНА
	|		ИНАЧЕ
	|			ЛОЖЬ
	|	КОНЕЦ КАК ЕстьОтличияКонтрагент,
	|	ВЫБОР
	|		КОГДА
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ втТаблицаТары.ДокументРеализации.Организация) > 1
	|		ТОГДА
	|			ИСТИНА
	|		ИНАЧЕ
	|			ЛОЖЬ
	|	КОНЕЦ КАК ЕстьОтличияОрганизация,
	|	ВЫБОР
	|		КОГДА
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ втТаблицаТары.ДокументРеализации.Соглашение) > 1
	|		ТОГДА
	|			ИСТИНА
	|		ИНАЧЕ
	|			ЛОЖЬ
	|	КОНЕЦ КАК ЕстьОтличияСоглашение,
	|	ВЫБОР
	|		КОГДА
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ втТаблицаТары.ДокументРеализации.НаправлениеДеятельности) > 1
	|		ТОГДА
	|			ИСТИНА
	|		ИНАЧЕ
	|			ЛОЖЬ
	|	КОНЕЦ КАК ЕстьОтличияНаправлениеДеятельности,
	|	ВЫБОР
	|		КОГДА
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ втТаблицаТары.ДокументРеализации.Договор) > 1
	|		ТОГДА
	|			ИСТИНА
	|		ИНАЧЕ
	|			ЛОЖЬ
	|	КОНЕЦ КАК ЕстьОтличияДоговор,
	|	ВЫБОР
	|		КОГДА
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ втТаблицаТары.ДокументРеализации.ХозяйственнаяОперация) > 1
	|		ТОГДА
	|			ИСТИНА
	|		ИНАЧЕ
	|			ЛОЖЬ
	|	КОНЕЦ КАК ЕстьОтличияХозяйственнаяОперация,
	|	ВЫБОР
	|		КОГДА
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ втТаблицаТары.ДокументРеализации.Валюта) > 1
	|		ТОГДА
	|			ИСТИНА
	|		ИНАЧЕ
	|			ЛОЖЬ
	|	КОНЕЦ КАК ЕстьОтличияВалюта,
	|	ВЫБОР
	|		КОГДА
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВЫБОР
	|									КОГДА втТаблицаТары.ДокументРеализации ССЫЛКА Документ.РеализацияТоваровУслуг 
	|										ТОГДА втТаблицаТары.ДокументРеализации.ВалютаВзаиморасчетов
	|									ИНАЧЕ втТаблицаТары.ДокументРеализации.Валюта
	|								КОНЕЦ) > 1
	|		ТОГДА
	|			ИСТИНА
	|		ИНАЧЕ
	|			ЛОЖЬ
	|	КОНЕЦ КАК ЕстьОтличияВалютаВзаиморасчетов,
	|	ВЫБОР
	|		КОГДА
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ втТаблицаТары.ДокументРеализации.НалогообложениеНДС) > 1
	|		ТОГДА
	|			ИСТИНА
	|		ИНАЧЕ
	|			ЛОЖЬ
	|	КОНЕЦ КАК ЕстьОтличияНалогообложениеНДС,
	|	ВЫБОР
	|		КОГДА
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ втТаблицаТары.ПредусмотренЗалогЗаТару) > 1
	|		ТОГДА
	|			ИСТИНА
	|		ИНАЧЕ
	|			ЛОЖЬ
	|	КОНЕЦ КАК ЕстьОтличияПредусмотренЗалогЗаТару,
	|	ВЫБОР
	|		КОГДА
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ
	|				ВЫБОР
	|					КОГДА
	|						втТаблицаТары.ДокументРеализации.БанковскийСчетОрганизации <> ЗНАЧЕНИЕ(Справочник.БанковскиеСчетаОрганизаций.ПустаяСсылка)
	|					ТОГДА
	|						втТаблицаТары.ДокументРеализации.БанковскийСчетОрганизации
	|					ИНАЧЕ
	|						NULL
	|				КОНЕЦ) = 1 И
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ втТаблицаТары.ДокументРеализации.Организация) = 1
	|		ТОГДА
	|			МАКСИМУМ(втТаблицаТары.ДокументРеализации.БанковскийСчетОрганизации)
	|		ИНАЧЕ
	|			ЗНАЧЕНИЕ(Справочник.БанковскиеСчетаОрганизаций.ПустаяСсылка)
	|	КОНЕЦ КАК БанковскийСчетОрганизации,
	|	ВЫБОР
	|		КОГДА
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ
	|				ВЫБОР
	|					КОГДА
	|						втТаблицаТары.ДокументРеализации.БанковскийСчетКонтрагента <> ЗНАЧЕНИЕ(Справочник.БанковскиеСчетаКонтрагентов.ПустаяСсылка)
	|					ТОГДА
	|						втТаблицаТары.ДокументРеализации.БанковскийСчетКонтрагента
	|					ИНАЧЕ
	|						NULL
	|				КОНЕЦ) = 1 И
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ втТаблицаТары.ДокументРеализации.Контрагент) = 1
	|		ТОГДА
	|			МАКСИМУМ(втТаблицаТары.ДокументРеализации.БанковскийСчетКонтрагента)
	|		ИНАЧЕ
	|			ЗНАЧЕНИЕ(Справочник.БанковскиеСчетаКонтрагентов.ПустаяСсылка)
	|	КОНЕЦ КАК БанковскийСчетКонтрагента,
	|	ВЫБОР
	|		КОГДА
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ
	|				ВЫБОР
	|					КОГДА
	|						втТаблицаТары.ДокументРеализации.Грузоотправитель <> ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|					ТОГДА
	|						втТаблицаТары.ДокументРеализации.Грузоотправитель
	|					ИНАЧЕ
	|						NULL
	|				КОНЕЦ) = 1
	|		ТОГДА
	|			МАКСИМУМ(втТаблицаТары.ДокументРеализации.Грузоотправитель)
	|		ИНАЧЕ
	|			ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|	КОНЕЦ КАК Грузополучатель,
	|	ВЫБОР
	|		КОГДА
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ
	|				ВЫБОР
	|					КОГДА
	|						втТаблицаТары.ДокументРеализации.БанковскийСчетГрузоотправителя <> ЗНАЧЕНИЕ(Справочник.БанковскиеСчетаКонтрагентов.ПустаяСсылка)
	|					ТОГДА
	|						втТаблицаТары.ДокументРеализации.БанковскийСчетГрузоотправителя
	|					ИНАЧЕ
	|						NULL
	|				КОНЕЦ) = 1 И
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ
	|				ВЫБОР
	|					КОГДА
	|						втТаблицаТары.ДокументРеализации.Грузоотправитель <> ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|					ТОГДА
	|						втТаблицаТары.ДокументРеализации.Грузоотправитель
	|					ИНАЧЕ
	|						NULL
	|				КОНЕЦ) = 1
	|		ТОГДА
	|			МАКСИМУМ(втТаблицаТары.ДокументРеализации.БанковскийСчетГрузоотправителя)
	|		ИНАЧЕ
	|			ЗНАЧЕНИЕ(Справочник.БанковскиеСчетаКонтрагентов.ПустаяСсылка)
	|	КОНЕЦ КАК БанковскийСчетГрузополучателя
	|ИЗ
	|	втТаблицаТары КАК втТаблицаТары
	|");
	
	Запрос.УстановитьПараметр("ТаблицаТары", ТаблицаТары);
	Запрос.УстановитьПараметр("ИспользоватьСоглашенияСКлиентами", ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами"));
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаРеквизиты = РезультатЗапроса.Выбрать();
	ВыборкаРеквизиты.Следующий();
	
	Если СообщитьОбОшибкахФормированияДанныхЗаполненияВозвратаВыкупаТары(ВыборкаРеквизиты) Тогда
		
		ТекстОшибки = НСтр("ru='Ввод одного документа по выделенным строкам невозможен'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		
		Возврат Неопределено;
		
	Иначе
		
		РеквизитыШапки = Новый Структура();
		РеквизитыШапки.Вставить("Партнер",                       ВыборкаРеквизиты.Партнер);
		РеквизитыШапки.Вставить("Контрагент",                    ВыборкаРеквизиты.Контрагент);
		РеквизитыШапки.Вставить("Договор",                       ВыборкаРеквизиты.Договор);
		РеквизитыШапки.Вставить("Организация",                   ВыборкаРеквизиты.Организация);
		РеквизитыШапки.Вставить("Склад",                         ВыборкаРеквизиты.Склад);
		РеквизитыШапки.Вставить("Соглашение",                    ВыборкаРеквизиты.Соглашение);
		РеквизитыШапки.Вставить("НаправлениеДеятельности",       ВыборкаРеквизиты.НаправлениеДеятельности);
		РеквизитыШапки.Вставить("ХозяйственнаяОперация",         ПродажиСервер.ПолучитьХозяйственнуюОперациюВозвратаПоРеализации(ВыборкаРеквизиты.ХозяйственнаяОперация));
		РеквизитыШапки.Вставить("Валюта",                        ВыборкаРеквизиты.Валюта);
		РеквизитыШапки.Вставить("ВалютаВзаиморасчетов",          ВыборкаРеквизиты.ВалютаВзаиморасчетов);
		РеквизитыШапки.Вставить("ФормаОплаты",                   ВыборкаРеквизиты.ФормаОплаты);
		РеквизитыШапки.Вставить("НалогообложениеНДС",            ВыборкаРеквизиты.НалогообложениеНДС);
		РеквизитыШапки.Вставить("ЦенаВключаетНДС",               ВыборкаРеквизиты.ЦенаВключаетНДС);
		РеквизитыШапки.Вставить("Грузополучатель",               ВыборкаРеквизиты.Грузополучатель);
		РеквизитыШапки.Вставить("БанковскийСчетГрузополучателя", ВыборкаРеквизиты.БанковскийСчетГрузополучателя);
		РеквизитыШапки.Вставить("БанковскийСчетОрганизации",     ВыборкаРеквизиты.БанковскийСчетОрганизации);
		РеквизитыШапки.Вставить("БанковскийСчетКонтрагента",     ВыборкаРеквизиты.БанковскийСчетКонтрагента);
		РеквизитыШапки.Вставить("ПредусмотренЗалогЗаТару",       ВыборкаРеквизиты.ПредусмотренЗалогЗаТару);
		
		АдресТарыВоВременномХранилище = ПоместитьВоВременноеХранилище(ТаблицаТары, УникальныйИдентификатор);
		Возврат Новый Структура(
						"РеквизитыШапки,АдресТарыВоВременномХранилище,ЗаполнитьПоПереданнойТаре",
						РеквизитыШапки,
						АдресТарыВоВременномХранилище);
		
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура УстановитьОтборПоПартнеру()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ПереданнаяТара,        "Партнер", ОтборПартнер, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ОтборПартнер));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ДокументыВозвратаТары, "Партнер", ОтборПартнер, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ОтборПартнер));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ДокументыВыкупаТары,   "Партнер", ОтборПартнер, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ОтборПартнер));
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоМенеджеру()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ПереданнаяТара,        "ДокументПередачи.Менеджер", ОтборМенеджер, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ОтборМенеджер));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ДокументыВозвратаТары, "Менеджер", ОтборМенеджер, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ОтборМенеджер));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ДокументыВыкупаТары,   "Менеджер", ОтборМенеджер, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ОтборМенеджер));
	
КонецПроцедуры

#КонецОбласти
