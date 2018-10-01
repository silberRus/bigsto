﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьВидимостьНаСервере();
	
	ВалютаРеглУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Оповестить("ЗакрытаФормаУзлаПланаОбмена");
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОбновитьИнтерфейс();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьОтборПоОрганизациямПриИзменении(Элемент)
	
	УстановитьВидимостьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОтборПоКассамПриИзменении(Элемент)
	
	УстановитьВидимостьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОтборПоСкладамПриИзменении(Элемент)
	
	УстановитьВидимостьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОтборПоЭквайринговымТерминаламПриИзменении(Элемент)
	
	УстановитьВидимостьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОтборПоВидамЦенНоменклатурыПриИзменении(Элемент)
	
	УстановитьВидимостьНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Процедура УстановитьВидимостьНаСервере()
	
	НастройкаФильтровРегистрации = Элементы.Группа.ПодчиненныеЭлементы.НастройкаФильтровРегистрации;
	НастройкиОтборов = НастройкаФильтровРегистрации.ПодчиненныеЭлементы.НастройкиОтборов;
	
	ОтборПоОрганизациям            = НастройкиОтборов.ПодчиненныеЭлементы.ОтборПоОрганизациям;
	ОтборПоСкладам                 = НастройкиОтборов.ПодчиненныеЭлементы.ОтборПоСкладам;
	ОтборПоКассам                  = НастройкиОтборов.ПодчиненныеЭлементы.ОтборПоКассам;
	ОтборПоВидамЦен                = НастройкиОтборов.ПодчиненныеЭлементы.ОтборПоВидамЦенНоменклатуры;
	ОтборПоЭквайринговымТерминалам = НастройкиОтборов.ПодчиненныеЭлементы.ОтборПоЭквайринговымТерминалам;
	
	ОтборПоОрганизациям.Видимость            = Объект.ИспользоватьОтборПоОрганизациям;
	ОтборПоСкладам.Видимость                 = Объект.ИспользоватьОтборПоСкладам;
	ОтборПоКассам.Видимость                  = Объект.ИспользоватьОтборПоКассам;
	ОтборПоВидамЦен.Видимость                = Объект.ИспользоватьОтборПоВидамЦенНоменклатуры;
	ОтборПоЭквайринговымТерминалам.Видимость = Объект.ИспользоватьОтборПоЭквайринговымТерминалам;
	
	Элементы.СоздаватьПартнеровДляНовыхКонтрагентов.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровИКонтрагентов");
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
