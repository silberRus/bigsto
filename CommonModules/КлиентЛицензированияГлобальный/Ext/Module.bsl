﻿
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интернет-поддержка пользователей".
// ОбщийМодуль.КлиентЛицензированияГлобальный.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Открывает форму БИП для ввода настроек клиента лицензирования.
// Обработчик подключается во всех режимах кроме режима работы в модели сервиса.
// Подключается в методе
// ИнтернетПоддержкаПользователейКлиент.ПриНачалеРаботыСистемы_ПодключитьОбработчикБИПЗапросаНастройкиКлиентаЛицензирования().
//
// При первом вызове - до отображения системного сообщения о необходимости
// подтверждения правомерности использования конфигурации - проверяются.
//
Процедура ПриЗапросеНастроекКлиентаЛицензирования() Экспорт
	
	Если Не ИнтернетПоддержкаПользователейКлиент.ЗначениеПараметраПриложения(
		"БазоваяФункциональностьБИП\ОбработанПервыйЗапросНастроекКлиентаЛицензирования", Ложь) Тогда
		
		// Обработка первого вызова запроса настроек клиента лицензирования
		ИнтернетПоддержкаПользователейКлиент.УстановитьЗначениеПараметраПриложения(
			"БазоваяФункциональностьБИП\ОбработанПервыйЗапросНастроекКлиентаЛицензирования",
			Истина);
		
		РезультатПроверки = КлиентЛицензированияВызовСервера.ПроверитьНастройкиКлиентаЛицензирования();
		
		ИнтернетПоддержкаПользователейКлиент.УстановитьЗначениеПараметраПриложения(
			"БазоваяФункциональностьБИП\ПравоПодключенияИПП",
			РезультатПроверки.ПравоПодключенияИПП);
		
		Если РезультатПроверки.НастройкиСинхронизированы Или Не РезультатПроверки.ПравоПодключенияИПП Тогда
			// Записаны настройки клиента лицензирования из БИП.
			// Если записанные настройки некорректны, тогда обработчик будет
			// вновь вызван платформой 1С:Предприятие для отображения диалога
			// запроса настроек клиента лицензирования.
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ИнтернетПоддержкаПользователейКлиент.ЗначениеПараметраПриложения("БазоваяФункциональностьБИП\ПравоПодключенияИПП", Ложь) Тогда
		// Выполняется только при втором и последующих вызовах обработчика.
		ПоказатьПредупреждение(, НСтр("ru = 'Недостаточно прав для подключения Интернет-поддержки пользователей.
			|Обратитесь к администратору.'"));
		Возврат;
	КонецЕсли;
	
	ПараметрОповещения = Новый Структура("Активизирована", Ложь);
	Оповестить("ИПП_АктивизироватьФормуПодключенияИПП", ПараметрОповещения);
	
	Если ПараметрОповещения.Свойство("Активизирована") И ПараметрОповещения.Активизирована = Истина Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗапомнитьПароль"                        , Истина);
	ПараметрыФормы.Вставить("ИзменятьФлагЗаполнитьПароль"            , Ложь);
	ПараметрыФормы.Вставить("РежимВводаНастроекКлиентаЛицензирования", Истина);
	
	ОткрытьФорму(
		"ОбщаяФорма.ПодключениеИнтернетПоддержки",
		ПараметрыФормы,
		,
		,
		,
		,
		,
		РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

#КонецОбласти