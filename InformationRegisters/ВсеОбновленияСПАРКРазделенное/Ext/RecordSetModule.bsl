﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	ЕстьОшибки = Ложь;

	МассивДопустимыхВидовОбновления = РегистрыСведений.ВсеОбновленияСПАРКРазделенное.ПолучитьЗначенияДопустимыхВидовОбновления();

	Для каждого ТекущаяЗапись Из ЭтотОбъект Цикл
		Если МассивДопустимыхВидовОбновления.Найти(ТекущаяЗапись.ВидОбновления) = Неопределено Тогда
			ЕстьОшибки = Истина;
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Недопустимое значение вида обновления: [%1]'"),
				ТекущаяЗапись.ВидОбновления);
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = ТекстСообщения;
			Сообщение.Поле  = "ВидОбновления";
			Сообщение.УстановитьДанные(ЭтотОбъект);
			Сообщение.Сообщить();
		КонецЕсли;
	КонецЦикла;

	Отказ = ЕстьОшибки;

КонецПроцедуры

#КонецОбласти

#КонецЕсли