﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СтрокаТаблицыЗначений") Тогда
		ВидНоменклатуры = ДанныеЗаполнения.ВидНоменклатуры;
		
		Если ДанныеЗаполнения.ИспользоватьДатуПроизводстваСерии Тогда
			ДатаПроизводства = ДанныеЗаполнения.Справка1ДатаРозлива;
		КонецЕсли;
		
		Если ДанныеЗаполнения.ИспользоватьПроизводителяЕГАИССерии Тогда
			ПроизводительЕГАИС = ДанныеЗаполнения.Производитель;
		КонецЕсли;
		
		Если ДанныеЗаполнения.ИспользоватьСправку2ЕГАИССерии Тогда
			Справка2ЕГАИС = ДанныеЗаполнения.Справка2;
		КонецЕсли;
		
		Если ДанныеЗаполнения.ИспользоватьСрокГодностиСерии Тогда
			ГоденДо = ДанныеЗаполнения.ГоденДо;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПараметрыШаблона = ЗначениеНастроекПовтИсп.НастройкиИспользованияСерий(ВидНоменклатуры);
	
	Номер = СокрЛП(Номер);
	
	Если ПараметрыШаблона.ТочностьУказанияСрокаГодностиСерии = Перечисления.ТочностиУказанияСрокаГодности.СТочностьюДоЧасов Тогда
		ГоденДо = НачалоЧаса(ГоденДо);
	Иначе
		ГоденДо = НачалоДня(ГоденДо);
	КонецЕсли;
	
	Наименование = НоменклатураКлиентСервер.ПредставлениеСерии(ПараметрыШаблона, ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ПараметрыШаблона = ЗначениеНастроекПовтИсп.НастройкиИспользованияСерий(ВидНоменклатуры);

	Если Не ПараметрыШаблона.ИспользоватьНомерСерии Тогда 
		МассивНепроверяемыхРеквизитов.Добавить("Номер");
	КонецЕсли;
	
	Если Не ПараметрыШаблона.ИспользоватьСрокГодностиСерии Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ГоденДо");
	КонецЕсли;
	
	Если Не ПараметрыШаблона.ИспользоватьДатуПроизводстваСерии Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ДатаПроизводства");
	КонецЕсли;
	
	Если Не ПараметрыШаблона.ИспользоватьПроизводителяЕГАИССерии Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПроизводительЕГАИС");
	КонецЕсли;
		
	Если Не ПараметрыШаблона.ИспользоватьСправку2ЕГАИССерии Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Справка2ЕГАИС");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли