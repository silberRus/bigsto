﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УстановитьУсловноеОформление();

	Если НЕ Параметры.Свойство("ИсторияКПП")
		ИЛИ НЕ Параметры.Свойство("ТекущийКПП") Тогда 
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ИсторияКПП.Загрузить(Параметры.ИсторияКПП.Выгрузить());
	Если ИсторияКПП.Количество() = 0 Тогда
		ИсторияКПП.Добавить().КПП = Параметры.ТекущийКПП;
	КонецЕсли;
	
	Если НЕ ПравоДоступа("Редактирование", Метаданные.Справочники.Контрагенты) Тогда
		
		ТолькоПросмотр = Истина;
		
	КонецЕсли;
	
	Если ТолькоПросмотр Тогда
		
		Элементы.ФормаОтмена.КнопкаПоУмолчанию = Истина;
		
	КонецЕсли;
	
	УстановитьПризнакПервоначальногоЗначения(ИсторияКПП);
	
	Если ИсторияКПП.Количество() > 0 Тогда
		Элементы.ИсторияКПП.ТекущаяСтрока = ИсторияКПП[ИсторияКПП.Количество()-1].ПолучитьИдентификатор();
	КонецЕсли;
	
	КоличествоСтрокИстории = ИсторияКПП.Количество();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность И Не ВыполняетсяЗакрытие Тогда
		
		Отказ = Истина;
		СтандартнаяОбработка = Ложь;
		
		ТекстВопроса = НСтр("ru = 'Данные были изменены, перенести изменения?'");
		ОповещениеОЗакрытии = Новый ОписаниеОповещения("ВопросОПереносеИзмененийПослеОтвета", ЭтотОбъект);
		ПоказатьВопрос(ОповещениеОЗакрытии, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыИсторияКПП

&НаКлиенте
Процедура ИсторияКПППриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		
		ТекущиеДанные = Элемент.ТекущиеДанные;
		
		Если ТекущиеДанные <> Неопределено Тогда
			
			НовыйПериод = НачалоДня(ОбщегоНазначенияКлиент.ДатаСеанса());
			ТекущиеДанные.НачальноеЗначение = Ложь;
			
			// Получим максимальный период в таблице
			ПоследнийПериод = '00010101000000';
			Для Каждого ЗаписьИстории ИЗ ИсторияКПП Цикл
				Если ЗаписьИстории.Период > ПоследнийПериод Тогда
					ПоследнийПериод = ЗаписьИстории.Период;
				КонецЕсли;
			КонецЦикла;
			
			Если НовыйПериод <= ПоследнийПериод Тогда
				НовыйПериод = НачалоДня(ПоследнийПериод + 60*60*24);
			КонецЕсли;
			
			ТекущиеДанные.Период = НовыйПериод;
			
			ЭтотОбъект.ТекущийЭлемент = Элементы.ИсторияКППКПП;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияКПППриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПризнакПервоначальногоЗначения(ИсторияКПП);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияКПППередУдалением(Элемент, Отказ)
	
	Если ИсторияКПП.Индекс(Элемент.ТекущиеДанные) = 0 Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияКПППриИзменении(Элемент)
	КоличествоСтрокИстории = ИсторияКПП.Количество();
	ОтключитьОтметкуНезаполненного();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ПеренестиИзменения();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПризнакПервоначальногоЗначения(ТаблицаИстории)
	
	ТаблицаИстории.Сортировать("Период");
	Если ТаблицаИстории.Количество() > 0 Тогда
		ПерваяСтрока = ТаблицаИстории[0];
		ПерваяСтрока.НачальноеЗначение = Истина;
		ПерваяСтрока.Период = '00010101';
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиИзменения()
	
	Отказ = Ложь;
	
	ПроверитьЗаполнениеИстории(Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ВыполняетсяЗакрытие = Истина;
	РезультатВыбора = Новый Структура;
	РезультатВыбора.Вставить("ИсторияКПП", ИсторияКПП);
	
	Закрыть(РезультатВыбора);

КонецПроцедуры

&НаКлиенте
Процедура ПроверитьЗаполнениеИстории(Отказ)
	
	ОчиститьСообщения();
	
	ПериодыСтрок = Новый Массив;
	
	Если ИсторияКПП.Количество() = 1
		И ПустаяСтрока(ИсторияКПП[0].КПП) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Для Каждого Запись Из ИсторияКПП Цикл
		
		ИндексСтроки = ИсторияКПП.Индекс(Запись);
		ПрефиксСообщенияСтроки = "ИсторияКПП["+Формат(ИндексСтроки, "ЧЦ=; ЧДЦ=; ЧГ=")+"].";
		
		Если НЕ ЗначениеЗаполнено(Запись.Период) И ИндексСтроки > 0 Тогда
			СообщениеОбОшибке = НСтр("ru = 'Нужно указать дату начала действия'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке, , ПрефиксСообщенияСтроки+"Период", , Отказ);
		КонецЕсли;
		
		Если ПериодыСтрок.Найти(Запись.Период) = Неопределено Тогда
			Если ЗначениеЗаполнено(Запись.Период) Тогда
				ПериодыСтрок.Добавить(Запись.Период);
			КонецЕсли;
		Иначе
			СообщениеОбОшибке = НСтр("ru = 'Уже есть запись с указанной датой сведений'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке, , ПрефиксСообщенияСтроки+"Период", , Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Запись.КПП) Тогда
			СообщениеОбОшибке = НСтр("ru = 'Поле ""КПП"" не заполнено'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке, , ПрефиксСообщенияСтроки+"КПП",  , Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросОПереносеИзмененийПослеОтвета(Ответ, ДополнительныеПараметры) Экспорт

	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		ПеренестиИзменения();
		
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		ВыполняетсяЗакрытие = Истина;
		Закрыть(Неопределено);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ИсторияКППКПП.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("КоличествоСтрокИстории");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Больше;
	ОтборЭлемента.ПравоеЗначение = 1;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИсторияКПП.КПП");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;

	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ИсторияКПППериод.Имя);
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИсторияКПП.НачальноеЗначение");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Доступность", Ложь);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеактуальногоСписка);

КонецПроцедуры

#КонецОбласти