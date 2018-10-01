﻿////////////////////////////////////////////////////////////////////////////////
//
// ЗатратыСервер: Распределение производственных затрат и затрат незавершенного производства.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Процедура выполняет запись движений производственных затрат.
//
// Параметры:
//	ДополнительныеСвойства - Структура - структура с данными для записи
//	Движения - Движения - Движения регистра "Производственные затраты"
//	Отказ - Булево - Признак отказа от записи движений
//
Процедура ОтразитьМатериалыИРаботыВПроизводстве(ДополнительныеСвойства, Движения, Отказ) Экспорт
	
	Таблица = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаМатериалыИРаботыВПроизводстве;
	
	Если Отказ ИЛИ Таблица.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Набор = Движения.МатериалыИРаботыВПроизводстве;
	Набор.Записывать = Истина;
	Набор.Загрузить(Таблица);
	
КонецПроцедуры

// Процедура выполняет запись движений партий производственных затрат.
//
// Параметры:
//	ДополнительныеСвойства - Структура - структура с данными для записи
//	Движения - Движения - Движения регистра "Партии производственных затрат"
//	Отказ - Булево - Признак отказа от записи движений
//
Процедура ОтразитьПартииПроизводственныхЗатрат(ДополнительныеСвойства, Движения, Отказ) Экспорт

	Таблица = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаПартииПроизводственныхЗатрат;
	
	Если Отказ ИЛИ Таблица.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Набор = Движения.ПартииПроизводственныхЗатрат;
	Набор.Записывать = Истина;
	Набор.Загрузить(Таблица);
	
КонецПроцедуры

// Процедура проверяет дату документа на соответствие дате перехода на партионный учет версии 2.2.
// Проверка выполняется для документов нового производства.
//
// Параметры:
//	Объект - ДокументОбъект.ЭтапПроизводства2_2, ДокументОбъект.ДвижениеПродукцииИМатериалов - проверяемый документ,
//	Дата - Дата - дата, на которую выполняется проверка,
//	Отказ - Булево - устанавливается в ИСТИНА, если дата перехода на новый партионный учет больше переданной даты.
//
Процедура ПроверитьИспользованиеПартионногоУчета22(Объект, Дата, Отказ) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Дата) Тогда
		Возврат;
	КонецЕсли;
	
	ДатаПереходаНаПартионныйУчетВерсии22 = УниверсальныеМеханизмыПартийИСебестоимостиПовтИсп.ДатаПереходаНаПартионныйУчетВерсии22();
	
	ТекстОшибки = Неопределено;
	
	Если НЕ УниверсальныеМеханизмыПартийИСебестоимостиПовтИсп.ПартионныйУчетВерсии22() Тогда
		
		ТекстОшибки = НСтр("ru='Для операций, доступных с версии 2.2, требуется установить соответствующий режим партионного учета.'");
		
	ИначеЕсли ДатаПереходаНаПартионныйУчетВерсии22 > НачалоМесяца(Дата) Тогда
		
		ТекстОшибки = НСтр("ru='Регистрация операций, доступных с версии 2.2, раньше даты перехода на партионный учет версии 2.2 недоступна.
								|Требуется изменить дату операции (%1) или дату перехода на партионный учет 2.2 (%2).'");
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстОшибки,
			Формат(Дата, "ДЛФ=D"),
			Формат(ДатаПереходаНаПартионныйУчетВерсии22, "ДЛФ=D"));
			
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Объект,,, Отказ);
	КонецЕсли;
	
КонецПроцедуры



#КонецОбласти

#Область СлужебныеПроцедурыИФункции


#КонецОбласти

