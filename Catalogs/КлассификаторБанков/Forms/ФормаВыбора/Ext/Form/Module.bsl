﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ИмяОбработки = "ЗагрузкаКлассификатораБанков";
	ЕстьИсточникЗагрузкиДанных = Метаданные.Обработки.Найти(ИмяОбработки) <> Неопределено;
	
	МожноОбновлятьКлассификатор =
		Не ОбщегоНазначения.РазделениеВключено() // В модели сервиса обновляется автоматически.
		И Не ОбщегоНазначения.ЭтоПодчиненныйУзелРИБ()   // В узле РИБ обновляется автоматически.
		И ПравоДоступа("Изменение", Метаданные.Справочники.КлассификаторБанков); // Пользователь с необходимыми правами.

	Элементы.ФормаЗагрузитьКлассификатор.Видимость = МожноОбновлятьКлассификатор И ЕстьИсточникЗагрузкиДанных;
	
	Если Не Пользователи.ЭтоПолноправныйПользователь() Или Не МожноОбновлятьКлассификатор Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
	ПереключитьВидимостьНедействующихБанков(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗагрузитьКлассификатор(Команда)
	РаботаСБанкамиКлиент.ОткрытьФормуЗагрузкиКлассификатора(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьНедействующиеБанки(Команда)
	ПереключитьВидимостьНедействующихБанков(Не Элементы.ФормаПоказыватьНедействующиеБанки.Пометка);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПереключитьВидимостьНедействующихБанков(Видимость)
	
	Элементы.ФормаПоказыватьНедействующиеБанки.Пометка = Видимость;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "ДеятельностьПрекращена", Ложь, , , Не Видимость);
			
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Список.УсловноеОформление.Элементы.Очистить();
	Элемент = Список.УсловноеОформление.Элементы.Добавить();
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеятельностьПрекращена");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
КонецПроцедуры

#КонецОбласти
