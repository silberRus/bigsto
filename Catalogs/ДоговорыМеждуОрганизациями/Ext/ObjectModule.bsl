﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Перем Ошибки;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	// Дата начала действия договора должна быть не меньше, чем дата договора.
	Если ЗначениеЗаполнено(Дата) И ЗначениеЗаполнено(ДатаНачалаДействия) Тогда
		
		Если НачалоДня(Дата) > ДатаНачалаДействия Тогда
			
			ТекстОшибки = НСтр("ru='Дата начала действия договора должна быть не меньше даты договора'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект, 
				"ДатаНачалаДействия",
				,
				Отказ);
			
		Конецесли;
		
	КонецЕсли;
	
	// Дата окончания действия договора должна быть не меньше, чем дата договора.
	Если ЗначениеЗаполнено(Дата) И ЗначениеЗаполнено(ДатаОкончанияДействия) Тогда	
		
		Если НачалоДня(Дата) > ДатаОкончанияДействия Тогда
			
			ТекстОшибки = НСтр("ru='Дата окончания действия договора должна быть не меньше даты договора'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект, 
				"ДатаОкончанияДействия",
				,
				Отказ);
			
		Конецесли;
		
	КонецЕсли;
	
	// Дата окончания действия договора должна быть не меньше, чем дата начала действия.
	Если ЗначениеЗаполнено(ДатаНачалаДействия) И ЗначениеЗаполнено(ДатаОкончанияДействия) Тогда	
		
		Если ДатаНачалаДействия > ДатаОкончанияДействия Тогда
			
			ТекстОшибки = НСтр("ru='Дата окончания действия договора должна быть не меньше даты начала действия'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект, 
				"ДатаОкончанияДействия",
				,
				Отказ);
			
		Конецесли;
		
	КонецЕсли;
	
		
	Если Организация = ОрганизацияПолучатель Тогда
		
		Если ТипДоговора = Перечисления.ТипыДоговоровМеждуОрганизациями.КупляПродажа Тогда
			ТекстОшибки = НСтр("ru = 'Покупателем и продавцом не может являться одна и та же организация.'");
		Иначе
			ТекстОшибки = НСтр("ru = 'Комитентом и комиссионером не может являться одна и та же организация.'");
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект, 
			"ОрганизацияПолучатель",
			,
			Отказ);
			
	КонецЕсли;
	
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если НЕ ЗначениеЗаполнено(НаименованиеДляПечати) Тогда
		НаименованиеДляПечати = СокрЛП(Наименование);
	КонецЕсли;
	
	
	ОбщегоНазначенияУТ.ИзменитьПризнакСогласованностиСправочника(
		ЭтотОбъект,
		Перечисления.СтатусыДоговоровКонтрагентов.НеСогласован);
	
	// Отработка смены пометки удаления
	Если Не ЭтоНовый() И ПометкаУдаления <> ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ПометкаУдаления") Тогда
		Справочники.КлючиАналитикиУчетаПоПартнерам.УстановитьПометкуУдаления(Новый Структура("Договор", Ссылка), ПометкаУдаления);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Дата) И ЗначениеЗаполнено(Номер) Тогда
		ИдентификаторПлатежа = ОбщегоНазначенияУТ.ПолучитьУникальныйИдентификаторПлатежа(ЭтотОбъект);
	Иначе
		ИдентификаторПлатежа = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Согласован              = Ложь;
	ДатаНачалаДействия      = '00010101';
	ДатаОкончанияДействия   = '00010101';
	ИдентификаторПлатежа	= Неопределено;

	ИнициализироватьСправочник(, Ложь);

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьСправочник(ДанныеЗаполнения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

// Процедура заполняет реквизиты справочника значениями "по умолчанию".
//
Процедура ИнициализироватьСправочник(ДанныеЗаполнения = Неопределено, ЗаполнятьВсеРеквизиты = Истина) Экспорт
	
	Менеджер = Пользователи.ТекущийПользователь();
	Статус = Перечисления.СтатусыДоговоровКонтрагентов.Действует;
	
	Если ЗаполнятьВсеРеквизиты Тогда
		
		Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Или НЕ ДанныеЗаполнения.Свойство("Организация") Тогда
			Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
		Иначе
			Организация = ДанныеЗаполнения.Организация;
		КонецЕсли;
		
		Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Или НЕ ДанныеЗаполнения.Свойство("ВалютаВзаиморасчетов") Тогда
			ВалютаВзаиморасчетов = ЗначениеНастроекПовтИсп.ПолучитьВалютуРегламентированногоУчета(ВалютаВзаиморасчетов);
		Иначе
			ВалютаВзаиморасчетов = ДанныеЗаполнения.ВалютаВзаиморасчетов;
		КонецЕсли;
		
		Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Или Не ДанныеЗаполнения.Свойство("ПорядокОплаты") Тогда
			ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.ПолучитьПорядокОплатыПоУмолчанию(ВалютаВзаиморасчетов);
		Иначе
			ПорядокОплаты = ДанныеЗаполнения.ПорядокОплаты;
		КонецЕсли;
		
		ПараметрыЗаполнения = ДенежныеСредстваСервер.ПараметрыЗаполненияБанковскогоСчетаОрганизацииПоУмолчанию();
		ПараметрыЗаполнения.Организация = Организация;
		ПараметрыЗаполнения.БанковскийСчет = БанковскийСчет;
		
		ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(ПараметрыЗаполнения);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
