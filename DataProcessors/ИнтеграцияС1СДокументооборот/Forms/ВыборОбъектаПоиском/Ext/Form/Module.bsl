﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ТипОбъектаВыбора = Параметры.ТипОбъектаВыбора;
	
	Если ТипОбъектаВыбора = "DMIncomingDocument" 
		Или ТипОбъектаВыбора = "DMInternalDocument" 
		Или ТипОбъектаВыбора = "DMOutgoingDocument" Тогда
		Элементы.ГруппаСтраницыТипов.ТекущаяСтраница = Элементы.ГруппаДокументы;
		КлючСохраненияПоложенияОкна = "Документ";
	ИначеЕсли ТипОбъектаВыбора = "DMCorrespondent" Тогда
		Элементы.ГруппаСтраницыТипов.ТекущаяСтраница = Элементы.ГруппаКонтрагенты;
		КлючСохраненияПоложенияОкна = "Контрагент";
	КонецЕсли;
	Элементы.Папка.Видимость = (ТипОбъектаВыбора = "DMInternalDocument");
	
	// В параметрах может быть предустановленный заголовок.
	Если ТипОбъектаВыбора = "DMIncomingDocument" Тогда
		Заголовок = НСтр("ru = 'Условия поиска входящего документа'");
	ИначеЕсли ТипОбъектаВыбора = "DMInternalDocument" Тогда 
		Заголовок = НСтр("ru = 'Условия поиска внутреннего документа'");
	ИначеЕсли ТипОбъектаВыбора = "DMOutgoingDocument" Тогда
		Заголовок = НСтр("ru = 'Условия поиска исходящего документа'");
	ИначеЕсли ТипОбъектаВыбора = "DMCorrespondent" Тогда
		Если ИнтеграцияС1СДокументооборотПовтИсп.ИспользоватьТерминКорреспонденты() Тогда
			Заголовок = НСтр("ru = 'Условия поиска корреспондента'");
		Иначе
			Заголовок = НСтр("ru = 'Условия поиска контрагента'");
		КонецЕсли;
	КонецЕсли;
	
	ИскатьСразу = Ложь;
	
	// В параметрах могут быть предустановленные условия.
	Если Параметры.Свойство("Отбор") и Параметры.Отбор <> Неопределено Тогда
		Для каждого ПредустановленноеУсловие Из Параметры.Отбор Цикл
			ИмяРеквизитаXDTO = ПредустановленноеУсловие.Ключ;
			Если ИмяРеквизитаXDTO = "correspondent" Тогда
				ИмяРеквизитаФормы = "Контрагент";
			ИначеЕсли ИмяРеквизитаXDTO = "organization" Тогда
				ИмяРеквизитаФормы = "Организация";
			ИначеЕсли ИмяРеквизитаXDTO = "documentType" Тогда
				ИмяРеквизитаФормы = "ВидДокумента";
			ИначеЕсли ИмяРеквизитаXDTO = "name" Тогда
				ИмяРеквизитаФормы = "Наименование";
			ИначеЕсли ИмяРеквизитаXDTO = "sum" Тогда
				ИмяРеквизитаФормы = "Сумма";
			ИначеЕсли ИмяРеквизитаXDTO = "regNumber" Тогда
				ИмяРеквизитаФормы = "РегистрационныйНомер";
			ИначеЕсли ИмяРеквизитаXDTO = "anyDate" Тогда
				ИмяРеквизитаФормы = "ЛюбаяДата";
			ИначеЕсли ИмяРеквизитаXDTO = "inn" Тогда
				ИмяРеквизитаФормы = "ИНН";
			ИначеЕсли ИмяРеквизитаXDTO = "kpp" Тогда
				ИмяРеквизитаФормы = "КПП";
			Иначе
				Продолжить;
			КонецЕсли;
			ОписаниеУсловия = ПредустановленноеУсловие.Значение;
			// примитивные типы могут передаваться сразу значением
			Если ТипЗнч(ОписаниеУсловия) = Тип("Структура") Тогда
				Если ИмяРеквизитаXDTO = "name" Тогда
					ЗначениеУсловия = ОписаниеУсловия.Значение;
					Если Лев(ЗначениеУсловия, 1) = "%" Тогда
						ЗначениеУсловия = Сред(ЗначениеУсловия, 2);
					КонецЕсли;
					Если Прав(ЗначениеУсловия, 1) = "%" Тогда
						ЗначениеУсловия = Лев(ЗначениеУсловия, СтрДлина(ЗначениеУсловия) - 1);
					КонецЕсли;
					ЭтаФорма[ИмяРеквизитаФормы] = ЗначениеУсловия;
				Иначе
					ЭтаФорма[ИмяРеквизитаФормы] = ОписаниеУсловия.Значение;
				КонецЕсли;
				Если ОписаниеУсловия.Свойство("ЗначениеID") 
					и ЗначениеЗаполнено(ОписаниеУсловия.ЗначениеID) Тогда
					ЭтаФорма[ИмяРеквизитаФормы + "ID"] = ОписаниеУсловия.ЗначениеID;
				КонецЕсли;
			Иначе
				ЭтаФорма[ИмяРеквизитаФормы] = ОписаниеУсловия;
			КонецЕсли;
			ИскатьСразу = Истина;
		КонецЦикла;
	КонецЕсли;
	
	Если Параметры.Свойство("ИскатьСразу") Тогда
		ИскатьСразу = Параметры.ИскатьСразу;
	КонецЕсли;
	
	Если ИскатьСразу Тогда
		Обработки.ИнтеграцияС1СДокументооборот.ВыполнитьПоискПоРеквизитам(ТипОбъектаВыбора, СтруктураОтбора(), 
			АдресВоВременномХранилище, КоличествоРезультатов, ПредельноеКоличествоРезультатов);
	КонецЕсли;
	
КонецПроцедуры
 
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ИскатьСразу или КоличествоРезультатов = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если ПредельноеКоличествоРезультатов <> 0 Тогда
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(Истина, НСтр("ru = 'Да, показать первые'")
			+ " " + Формат(ПредельноеКоличествоРезультатов, "ЧГ=0"));
		Кнопки.Добавить(Ложь, НСтр("ru = 'Нет, уточнить условия'"));
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьПоискЗавершение", ЭтаФорма);
		ПоказатьВопрос(ОписаниеОповещения,
			НСтр("ru = 'Заданные условия поиска дали слишком много результатов. Показать результаты?'"),
			Кнопки);
			
	Иначе
		Отказ = Истина;
		ПерейтиКРезультатамПоиска();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

///////////////////////////////////////////////////////////////////////////////////////////////////
// Начало выбора

&НаКлиенте
Процедура ВидДокументаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыборСсылочногоРеквизитаНачало("ВидДокумента", ТипОбъектаВыбора + "Type");
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыборСсылочногоРеквизитаНачало("Организация", "DMOrganization");
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыборСсылочногоРеквизитаНачало("Контрагент", "DMCorrespondent");
	
КонецПроцедуры

&НаКлиенте
Процедура ПапкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыборСсылочногоРеквизитаНачало("Папка", "DMInternalDocumentFolder");
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////////////////////////
// Очистка

&НаКлиенте
Процедура ВидДокументаОчистка(Элемент, СтандартнаяОбработка)
	
	ЭтаФорма[Элемент.Имя + "ID"] = "";
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОчистка(Элемент, СтандартнаяОбработка)
	
	ЭтаФорма[Элемент.Имя + "ID"] = "";
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентОчистка(Элемент, СтандартнаяОбработка)
	
	ЭтаФорма[Элемент.Имя + "ID"] = "";
	
КонецПроцедуры

&НаКлиенте
Процедура ПапкаОчистка(Элемент, СтандартнаяОбработка)
	
	ЭтаФорма[Элемент.Имя + "ID"] = "";
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////////////////////////
// Автоподбор

&НаКлиенте
Процедура ВидДокументаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора(
			ТипОбъектаВыбора + "Type", ДанныеВыбора, Текст, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПапкаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора(
			"DMInternalDocumentFolder", ДанныеВыбора, Текст, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора(
			"DMOrganization", ДанныеВыбора, Текст, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора(
			"DMCorrespondent", ДанныеВыбора, Текст, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////////////////////////
// Окончание ввода текста

&НаКлиенте
Процедура ВидДокументаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора(
			ТипОбъектаВыбора + "Type", ДанныеВыбора, Текст, СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда 
			ИнтеграцияС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
				"ВидДокумента", ДанныеВыбора[0].Значение, СтандартнаяОбработка, ЭтаФорма);
			СтандартнаяОбработка = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПапкаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора(
			"DMInternalDocumentFolder", ДанныеВыбора, Текст, СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда 
			ИнтеграцияС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
				"Папка", ДанныеВыбора[0].Значение, СтандартнаяОбработка, ЭтаФорма);
			СтандартнаяОбработка = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора(
			"DMOrganization", ДанныеВыбора, Текст, СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда 
			ИнтеграцияС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
				"Организация", ДанныеВыбора[0].Значение, СтандартнаяОбработка, ЭтаФорма);
			СтандартнаяОбработка = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора(
			"DMCorrespondent", ДанныеВыбора, Текст, СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда 
			ИнтеграцияС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
				"Контрагент", ДанныеВыбора[0].Значение, СтандартнаяОбработка, ЭтаФорма);
			СтандартнаяОбработка = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////////////////////////
// Обработка выбора

&НаКлиенте
Процедура ВидДокументаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
		"ВидДокумента", ВыбранноеЗначение, СтандартнаяОбработка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПапкаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
		"Папка", ВыбранноеЗначение, СтандартнаяОбработка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
		"Организация", ВыбранноеЗначение, СтандартнаяОбработка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
		"Контрагент", ВыбранноеЗначение, СтандартнаяОбработка, ЭтаФорма);
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////////////////////////
// Прочее

&НаКлиенте
Процедура ДекорацияРасширенныйПоискНажатие(Элемент)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипОбъектаВыбора", ТипОбъектаВыбора);
	ПараметрыФормы.Вставить("Отбор", СтруктураОтбора());
	ПараметрыФормы.Вставить("ИскатьСразу", Ложь);
	Закрыть();
	ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.ВыборОбъектаПоискомРасширенный",
		ПараметрыФормы,ЭтаФорма,Новый УникальныйИдентификатор,,,
		ОписаниеОповещенияОЗакрытии,РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Искать(Команда)
	
	ВыполнитьПоискНаСервере(ТипОбъектаВыбора, АдресВоВременномХранилище, 
		КоличествоРезультатов, ПредельноеКоличествоРезультатов);
	Если КоличествоРезультатов = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Заданные условия поиска не дали ни одного результата.'"));
		
	ИначеЕсли ПредельноеКоличествоРезультатов <> 0 Тогда
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(Истина, СтрШаблон(
			НСтр("ru = 'Да, показать первые %1'"),
				Формат(ПредельноеКоличествоРезультатов, "ЧГ=0")));
		Кнопки.Добавить(Ложь, НСтр("ru = 'Нет, уточнить условия'"));
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьПоискЗавершение", ЭтаФорма);
		ПоказатьВопрос(ОписаниеОповещения,
			НСтр("ru = 'Заданные условия поиска дали слишком много результатов. Показать результаты?'"),
			Кнопки);
			
	Иначе 
		ПерейтиКРезультатамПоиска();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Упаковывает параметры отбора в структуру, предназначенную для передачи в открываемые формы
//
&НаСервере
Функция СтруктураОтбора()
	
	Отбор = Новый Структура;
	Если ЗначениеЗаполнено(СокрЛП(Наименование)) Тогда
		Значение = Новый Структура;
		Значение.Вставить("Представление", НСтр("ru = 'Наименование'"));
		Значение.Вставить("Значение", "%" + СокрЛП(Наименование) + "%");
		Значение.Вставить("ОператорСравнения", "LIKE");
		Значение.Вставить("ПредставлениеУсловия", СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'содержит ""%1""'"), СокрЛП(Наименование)));
		Отбор.Вставить("name", Значение);
	КонецЕсли;
	Если ЗначениеЗаполнено(ВидДокументаID) Тогда
		Значение = Новый Структура;
		Значение.Вставить("Представление", НСтр("ru = 'Вид документа'"));
		Значение.Вставить("ЗначениеТип", ТипОбъектаВыбора + "Type");
		Значение.Вставить("Значение", ВидДокумента);
		Значение.Вставить("ЗначениеID", ВидДокументаID);
		Значение.Вставить("ОператорСравнения", "=");
		Отбор.Вставить("documentType", Значение);
	КонецЕсли;
	Если ЗначениеЗаполнено(Сумма) Тогда
		Значение = Новый Структура;
		Значение.Вставить("Представление", НСтр("ru = 'Сумма'"));
		Значение.Вставить("Значение", Сумма);
		Значение.Вставить("ОператорСравнения", "=");
		Отбор.Вставить("sum", Значение);
	КонецЕсли;
	Если ЗначениеЗаполнено(СокрЛП(РегистрационныйНомер)) Тогда
		Значение = Новый Структура;
		Значение.Вставить("Представление", НСтр("ru = 'Рег. №'"));
		Значение.Вставить("Значение", СокрЛП(РегистрационныйНомер));
		Значение.Вставить("ОператорСравнения", "=");
		Отбор.Вставить("regNumber", Значение);
	КонецЕсли;
	Если ЗначениеЗаполнено(ЛюбаяДата) Тогда
		Значение = Новый Структура;
		Значение.Вставить("Представление", НСтр("ru = 'Начиная с'"));
		Значение.Вставить("Значение", ЛюбаяДата);
		Значение.Вставить("ОператорСравнения", ">=");
		Отбор.Вставить("anyDate", Значение);
	КонецЕсли;
	Если ЗначениеЗаполнено(ОрганизацияID) Тогда
		Значение = Новый Структура;
		Значение.Вставить("Представление", НСтр("ru = 'Организация'"));
		Значение.Вставить("ЗначениеТип", "DMOrganization");
		Значение.Вставить("Значение", Организация);
		Значение.Вставить("ЗначениеID", ОрганизацияID);
		Значение.Вставить("ОператорСравнения", "=");
		Отбор.Вставить("organization", Значение);
	КонецЕсли;
	Если ЗначениеЗаполнено(КонтрагентID) Тогда
		Значение = Новый Структура;
		Если ИнтеграцияС1СДокументооборотПовтИсп.ИспользоватьТерминКорреспонденты() Тогда
			Значение.Вставить("Представление", НСтр("ru = 'Корреспондент'"));
		Иначе
			Значение.Вставить("Представление", НСтр("ru = 'Контрагент'"));
		КонецЕсли;
		Значение.Вставить("ЗначениеТип", "DMCorrespondent");
		Значение.Вставить("Значение", Контрагент);
		Значение.Вставить("ЗначениеID", КонтрагентID);
		Значение.Вставить("ОператорСравнения", "=");
		Отбор.Вставить("correspondent", Значение);
	КонецЕсли;
	Если ЗначениеЗаполнено(ПапкаID) Тогда
		Значение = Новый Структура;
		Значение.Вставить("Представление", НСтр("ru = 'Папка'"));
		Значение.Вставить("ЗначениеТип", "DMInternalDocumentFolder");
		Значение.Вставить("Значение", Папка);
		Значение.Вставить("ЗначениеID", ПапкаID);
		Значение.Вставить("ОператорСравнения", "IN HIERARCHY");
		Отбор.Вставить("folder", Значение);
	КонецЕсли;
	Если ЗначениеЗаполнено(СокрЛП(ИНН)) Тогда
		Значение = Новый Структура;
		Значение.Вставить("Представление", НСтр("ru = 'ИНН'"));
		Значение.Вставить("Значение", СокрЛП(ИНН));
		Значение.Вставить("ОператорСравнения", "=");
		Отбор.Вставить("inn", Значение);
	КонецЕсли;
	Если ЗначениеЗаполнено(СокрЛП(КПП)) Тогда
		Значение = Новый Структура;
		Значение.Вставить("Представление", НСтр("ru = 'КПП'"));
		Значение.Вставить("Значение", СокрЛП(КПП));
		Значение.Вставить("ОператорСравнения", "=");
		Отбор.Вставить("kpp", Значение);
	КонецЕсли;
	
	Возврат Отбор;
	
КонецФункции

&НаКлиенте
Процедура ВыполнитьПоискЗавершение(Результат, Параметры) Экспорт
	
	Если Результат Тогда 
		ПерейтиКРезультатамПоиска();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКРезультатамПоиска()
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипОбъектаВыбора", ТипОбъектаВыбора);
	ПараметрыФормы.Вставить("Отбор", СтруктураОтбора());
	ПараметрыФормы.Вставить("АдресВоВременномХранилище", АдресВоВременномХранилище);
	Закрыть();
	ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.ВыборОбъектаПоискомРезультаты",
		ПараметрыФормы,ЭтаФорма,Новый УникальныйИдентификатор,,,
		ОписаниеОповещенияОЗакрытии,РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьПоискНаСервере(ТипОбъектаВыбора, АдресВоВременномХранилище, КоличествоРезультатов, ПредельноеКоличествоРезультатов)
	
	Обработки.ИнтеграцияС1СДокументооборот.ВыполнитьПоискПоРеквизитам(ТипОбъектаВыбора, СтруктураОтбора(), 
		АдресВоВременномХранилище, КоличествоРезультатов, ПредельноеКоличествоРезультатов);
		
КонецПроцедуры

&НаКлиенте
Процедура ВыборСсылочногоРеквизитаНачало(ИмяРеквизита, Тип)
	
	СтандартнаяОбработка = Ложь;
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыборСсылочногоРеквизитаЗавершение", 
		ЭтаФорма, ИмяРеквизита);
		
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипОбъектаВыбора", Тип);
	
	Если Тип = "DMCorrespondent" Тогда // контрагентов потенциально много, нужен выбор поиском
		
		Отбор = Новый Структура;
		Если ЗначениеЗаполнено(СокрЛП(Элементы.Контрагент.ТекстРедактирования)) Тогда
			Отбор.Вставить("name", СокрЛП(Элементы.Контрагент.ТекстРедактирования));
			ПараметрыФормы.Вставить("ИскатьСразу", Ложь);
		КонецЕсли;
		ПараметрыФормы.Вставить("Отбор", Отбор);
		
		ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.ВыборОбъектаПоиском",
			ПараметрыФормы,
			ЭтаФорма,
			УникальныйИдентификатор,,,
			ОписаниеОповещения,
			РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
			
	Иначе // обычный выбор из списка
			
		ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.ВыборИзСписка", ПараметрыФормы, 
			ЭтаФорма,Новый УникальныйИдентификатор,,,ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
			
	КонецЕсли;
	
КонецПроцедуры
	
&НаКлиенте
Процедура ВыборСсылочногоРеквизитаЗавершение(Результат, ИмяРеквизита) Экспорт
	
	Если Результат <> Неопределено Тогда
		ЭтаФорма[ИмяРеквизита] = Результат.РеквизитПредставление;
		ЭтаФорма[ИмяРеквизита + "ID"] = Результат.РеквизитID;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти