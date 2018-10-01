﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ЗначениеВладельца = Неопределено;
	
	Если Параметры.Свойство("Владелец") Тогда
		РеквизитыВладельца = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Параметры.Владелец,
					"ТоварныеКатегорииОбщиеСДругимВидомНоменклатуры,ВладелецТоварныхКатегорий");
					
		Если РеквизитыВладельца.ТоварныеКатегорииОбщиеСДругимВидомНоменклатуры Тогда
			ЗначениеВладельца = Параметры.ВладелецТоварныхКатегорий;
		Иначе
			ЗначениеВладельца = Параметры.Владелец;
		КонецЕсли;
	ИначеЕсли Параметры.Свойство("Отбор")
		И (Параметры.Отбор.Свойство("Владелец")
		Или Параметры.Отбор.Свойство("ВладелецТоварныхКатегорий")) Тогда
		
		Если Параметры.Отбор.Свойство("ВладелецТоварныхКатегорий") Тогда
			ЗначениеВладельца = Параметры.Отбор.ВладелецТоварныхКатегорий;
			Параметры.Отбор.Удалить("ВладелецТоварныхКатегорий");
		КонецЕсли;
		
		Если Параметры.Отбор.Свойство("Владелец") Тогда
			
			Если Не ЗначениеЗаполнено(ЗначениеВладельца) Тогда
				ЗначениеВладельца = Параметры.Отбор.Владелец;
			КонецЕсли;
			
			Параметры.Отбор.Удалить("Владелец");
		КонецЕсли;	
		
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(ЗначениеВладельца) Тогда
		Элементы.СписокВидовНоменклатуры.Видимость = Ложь;
		ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(
			Список,
			"Владелец",
			ЗначениеВладельца,
			Истина,
			ВидСравненияКомпоновкиДанных.Равно);
	Иначе
		Элементы.СписокВидовНоменклатуры.Видимость = Истина;
		ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(
			Список,
			"Владелец",
			Справочники.ВидыНоменклатуры.ПустаяСсылка(),
			Ложь,
			ВидСравненияКомпоновкиДанных.Равно);
	КонецЕсли;

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписоквидовноменклатуры

&НаКлиенте
Процедура СписокВидовНоменклатурыПриАктивизацииСтроки(Элемент)
	
	УстановитьОтборПоТекущейСтрокеВидаНоменклатуры(Элемент.ТекущаяСтрока);
	
	Элементы.Список.Доступность = Элемент.ТекущиеДанные <> Неопределено И (Элемент.ТекущиеДанные.ЭтоГруппа = Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьОтборПоТекущейСтрокеВидаНоменклатуры(ТекущаяСтрокаВида)
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(
		Список,
		"Владелец",
		ТекущаяСтрокаВида,
		Истина,
		ВидСравненияКомпоновкиДанных.Равно);
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
