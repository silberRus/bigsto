﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Для Каждого СтрокаСписка Из Параметры.Продавцы Цикл
		СтрокаПолучательПлатежа = Продавцы.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаПолучательПлатежа, СтрокаСписка.Значение);
	КонецЦикла;
	
	ДатаСведений = Параметры.ДатаСведений;
	
	ЗаполнитьСлужебныеРеквизитыПродавцов();
	ЗаполнитьЗависимыеРеквизиты(ЭтотОбъект);
	
	СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		
		Отказ = Истина;
		ОписаниеОповещения = Новый ОписаниеОповещения("ОбработчикОповещенияВопросПередЗакрытием", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПродавцыПродавецПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Продавцы.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ТекущиеДанные.Продавец) Тогда
		ТекущиеДанные.ИННПродавца = "";
		ТекущиеДанные.КПППродавца = "";
	Иначе
		ЗаполнитьДанныеПродавца(Элементы.Продавцы.ТекущаяСтрока);
	КонецЕсли;
	
	ЗаполнитьЗависимыеРеквизиты(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродавцыКПППродавцаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.Продавцы.ТекущиеДанные;
	Если ЗначениеЗаполнено(ТекущиеДанные.Продавец) Тогда
		ЗаполнитьСписокВыбораКПП(СписокВыбораКПП, ТекущиеДанные.Продавец, ДатаСведений);
	КонецЕсли;
	
	ДанныеВыбора = СписокВыбораКПП;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ПеренестиДанные();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаКлиенте
Процедура ПеренестиДанные()
	
	ОчиститьСообщения();
	
	Отказ = Ложь;
	
	ПодготовленныеДанные = Новый СписокЗначений;
	СписокПродавцов      = Новый СписокЗначений;
	
	Для Индекс = 0 По Продавцы.Количество() - 1 Цикл
		
		СтрокаТаблицы = Продавцы[Индекс];
		
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.Продавец) Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'В строке %1 не выбран продавец.'"),
				Индекс + 1);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				,
				"Продавцы["+Индекс+"].Продавец",
				,
				Отказ);
		КонецЕсли;
		
		Если СписокПродавцов.НайтиПоЗначению(СтрокаТаблицы.Продавец) <> Неопределено
		 И ЗначениеЗаполнено(СтрокаТаблицы.Продавец) Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'В строке %1 повторно указан продавец %2.'"),
				Индекс + 1,
				СтрокаТаблицы.Продавец);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				,
				"Продавцы["+Индекс+"].Продавец",
				,
				Отказ);
		КонецЕсли; 
		
		СписокПродавцов.Добавить(СтрокаТаблицы.Продавец);
		
		ДанныеПродавца = Новый Структура("Продавец, ИННПродавца, КПППродавца");
		ЗаполнитьЗначенияСвойств(ДанныеПродавца, СтрокаТаблицы);
		ПодготовленныеДанные.Добавить(ДанныеПродавца);
		
	КонецЦикла;
	
	Если НЕ Отказ Тогда
		Модифицированность = Ложь;
		Закрыть(ПодготовленныеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОповещенияВопросПередЗакрытием(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ПеренестиДанные();
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСлужебныеРеквизитыПродавцов()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Продавцы.Продавец КАК Продавец,
	|	Продавцы.ИННПродавца КАК ИННПродавца,
	|	Продавцы.КПППродавца КАК КПППродавца
	|ПОМЕСТИТЬ Продавцы
	|ИЗ
	|	&Продавцы КАК Продавцы
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Продавцы.Продавец КАК Продавец,
	|	Продавцы.ИННПродавца КАК ИННПродавца,
	|	Продавцы.КПППродавца КАК КПППродавца,
	|	ВЫБОР
	|		КОГДА Контрагенты.ЮрФизЛицо = ЗНАЧЕНИЕ(Перечисление.ЮрФизЛицо.ЮрЛицо)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЮрЛицо
	|ИЗ
	|	Продавцы КАК Продавцы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Контрагенты КАК Контрагенты
	|		ПО Продавцы.Продавец = Контрагенты.Ссылка";
	
	Запрос.УстановитьПараметр("Продавцы", Продавцы.Выгрузить());
	
	Продавцы.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьЗависимыеРеквизиты(Форма)

	Для Каждого Строка Из Форма.Продавцы Цикл
		
		Строка.ТолькоПросмотрИННПродавца = Не ЗначениеЗаполнено(Строка.Продавец);
		
		Строка.ТолькоПросмотрКПППродавца = Не ЗначениеЗаполнено(Строка.Продавец)
		                                   Или НЕ Строка.ЮрЛицо;
		
		Строка.КППНеТребуется            = ЗначениеЗаполнено(Строка.Продавец)
		                                   И НЕ Строка.ЮрЛицо;
		
	КонецЦикла;
 
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ЗаполнитьДанныеПродавца(ИдентификаторСтроки)

	ДанныеСтроки = Продавцы.НайтиПоИдентификатору(ИдентификаторСтроки);
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РеквизитыПродавца = Справочники.Контрагенты.РеквизитыКонтрагента(ДанныеСтроки.Продавец, ДатаСведений);
	ДанныеСтроки.ИННПродавца = РеквизитыПродавца.ИНН;
	ДанныеСтроки.КПППродавца = РеквизитыПродавца.КПП;
	ДанныеСтроки.ЮрЛицо      = (РеквизитыПродавца.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицо);

КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьСписокВыбораКПП(СписокВыбора, Контрагент, ДатаСведений)
	
	УчетНДСУТ.ЗаполнитьСписокВыбораКППСчетФактурыПолученные(СписокВыбора, Контрагент, ДатаСведений);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
#Область ТолькоПросмотрИННППродавца

	Элемент = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПродавцыИННПродавца.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Продавцы.ТолькоПросмотрИННПродавца");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
#КонецОбласти
	
#Область ТолькоПросмотрКПППродавца

	Элемент = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПродавцыКПППродавца.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Продавцы.ТолькоПросмотрКПППродавца");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
#КонецОбласти
	
#Область ПродавецНеЮрлицоКППНеТребуется

	Элемент = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПродавцыКПППродавца.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Продавцы.КППНеТребуется");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста",     ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст",          НСтр("ru = '<не требуется>'"));
	
#КонецОбласти
	
КонецПроцедуры

#КонецОбласти
