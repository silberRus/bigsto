﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает имя константы, хранящей номер задания для данного регистра.
//
// Возвращаемое значение:
//	Строка - Строковое предствление имени константы НомерЗаданияКРасчетуСебестоимости
Функция ИмяКонстантыНомераЗадания() Экспорт
	
	Возврат Метаданные.Константы.НомерЗаданияКРасчетуСебестоимости.Имя;
	
КонецФункции

// Увеличивает значение номера задания в константе.
//
// Возвращаемое значение:
//	Число - Предыдущий номер задания из константы "Номер задания к расчету себестоимости"
Функция УвеличитьНомерЗадания() Экспорт
	
	Возврат ЗакрытиеМесяцаСервер.УвеличитьНомерЗадания(ИмяКонстантыНомераЗадания());
	
КонецФункции

// Возвращает значение номера задани из константы.
//
// Возвращаемое значение:
//	Число - Номер текущего задания из константы "Номер задания к расчету себестоимости"
Функция ПолучитьНомерЗадания() Экспорт
	
	Возврат ЗакрытиеМесяцаСервер.ТекущийНомерЗадания(ИмяКонстантыНомераЗадания());
	
КонецФункции

// Метод создает запись регистра с заданными параметрами.
//
// Параметры:
//	ПериодЗадания   - Дата - Начало периода, для которого необходимо зарегистрировать задание к расчету
//	ДокументЗадания - ДокументСсылка - документ регистратор создавший движение в зависимых регистрах
//	Организация - СправочникСсылка.Организации - организация, по которой необходим перерасчет
//  НомерЗадания - Число - номер задания; если не задано, то будет установлено значение из соответствующей константы
//	ИзмененыДанныеДляПартионногоУчетаВерсии21 - Булево
//		- если Истина, то для таких изменений не требуется создавать записи в периоде, в котором используется партионный учет версии 2.2,
//			т.к. эти изменения больше не влияют на результат расчета партий/себестоимости (влияли только в версии 2.1);
//		- если Ложь, то значит изменились данные, влияющие на результаты расчета партий версии 2.1. и версии 2.2,
//			т.е. запись для таких изменений нужна всегда, независимо от ее периода.
//
Процедура СоздатьЗаписьРегистра(ПериодЗадания, ДокументЗадания = Неопределено, Организация = Неопределено,
				НомерЗадания = Неопределено, ИзмененыДанныеДляПартионногоУчетаВерсии21 = Ложь) Экспорт
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		// В РИБ данный регистр обрабатывается только в главном узле.
		Возврат;
	КонецЕсли;
	
	Если ИзмененыДанныеДляПартионногоУчетаВерсии21
	 И УниверсальныеМеханизмыПартийИСебестоимостиПовтИсп.ПартионныйУчетВерсии22(НачалоМесяца(ПериодЗадания)) Тогда
		Возврат; // измененные данные не требуют перерасчета партий/себестоимости
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ДокументЗадания) И НЕ ЗначениеЗаполнено(Организация) Тогда
		
		// Создаем задание для каждой организации ИБ
		МассивОрганизаций = УниверсальныеМеханизмыПартийИСебестоимости.СвязиОрганизацийПоСхемеИнтеркампани();
		
	Иначе
		
		МассивОрганизаций = Новый Массив;
		
		Если НЕ ЗначениеЗаполнено(Организация) Тогда
			// Попытаемся определить организацию по умолчанию.
			// Если не удастся, то будет вызвано платформенное исключение при записи.
			МассивОрганизаций.Добавить(Справочники.Организации.ОрганизацияПоУмолчанию());
		ИначеЕсли ТипЗнч(Организация) = Тип("Массив") Тогда
			МассивОрганизаций = Организация;
		Иначе
			МассивОрганизаций.Добавить(Организация);
		КонецЕсли;
		
	КонецЕсли;
	
	// Запишем задания.
	НачатьТранзакцию();
	
	Попытка
		
		Если НомерЗадания = Неопределено Тогда
			НомерЗадания = ПолучитьНомерЗадания();
		КонецЕсли;
		
		Для Каждого ТекущаяОрганизация Из МассивОрганизаций Цикл
			НаборЗаписей = РегистрыСведений.ЗаданияКРасчетуСебестоимости.СоздатьМенеджерЗаписи();
			НаборЗаписей.Месяц        = НачалоМесяца(ПериодЗадания);
			НаборЗаписей.Документ     = ДокументЗадания;
			НаборЗаписей.Организация  = ТекущаяОрганизация;
			НаборЗаписей.НомерЗадания = НомерЗадания;
			НаборЗаписей.Записать(Истина);
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;
	
КонецПроцедуры

// Метод создает записи регистра с параметрами, полученными запросом.
//
// Параметры:
//	Выборка - ВыборкаИзРезультатаЗапроса - выборка, содержащая данные для формирования записей.
//  НомерЗадания - Число - номер задания; если не задано, то будет установлено значение из соответствующей константы.
//	ИзмененыДанныеДляПартионногоУчетаВерсии21 - Булево
//		- если Истина, то для таких изменений не требуется создавать записи в периоде, в котором используется партионный учет версии 2.2,
//			т.к. эти изменения больше не влияют на результат расчета партий/себестоимости (влияли только в версии 2.1);
//		- если Ложь, то значит изменились данные, влияющие на результаты расчета партий версии 2.1. и версии 2.2,
//			т.е. запись для таких изменений нужна всегда, независимо от ее периода.
//
Процедура СоздатьЗаписиРегистраПоДаннымВыборки(Выборка, НомерЗадания = Неопределено, ИзмененыДанныеДляПартионногоУчетаВерсии21 = Ложь) Экспорт
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		// В РИБ данный регистр обрабатывается только в главном узле.
		Возврат;
	КонецЕсли;
	
	Если Выборка.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию();
	
	Попытка
		
		СтруктураПолей = Новый Структура("Месяц, Организация, Документ");
		
		Если НомерЗадания = Неопределено Тогда
			НомерЗадания = ПолучитьНомерЗадания();
		КонецЕсли;
		
		Пока Выборка.Следующий() Цикл
			
			ЗаполнитьЗначенияСвойств(СтруктураПолей, Выборка);
			
			СоздатьЗаписьРегистра(
				СтруктураПолей.Месяц,
				СтруктураПолей.Документ,
				СтруктураПолей.Организация,
				НомерЗадания,
				ИзмененыДанныеДляПартионногоУчетаВерсии21);
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		ТекстОшибки    = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось сформировать задание к расчету себестоимости за %1 в организации %2 по причине: %3'"),
			Выборка.Месяц,
			Выборка.Организация,
			ТекстОшибки);
			
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Партионный учет'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), УровеньЖурналаРегистрации.Ошибка, , , ТекстСообщения);
		
	КонецПопытки;
	
КонецПроцедуры

// Добавляет описания регистров для их подключения к механизму дат запрета изменения.
//
Процедура ОписаниеРегистровДляКонтроляДатЗапретаИзменения(ИсточникиДанных) Экспорт
	
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "РегистрНакопления.ВыручкаИСебестоимостьПродаж", "Период", "РегламентныеОперации");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "РегистрНакопления.МатериалыИРаботыВПроизводстве", "Период", "РегламентныеОперации");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "РегистрНакопления.ПартииПроизводственныхЗатрат", "Период", "РегламентныеОперации");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "РегистрНакопления.ПартииПрочихРасходов", "Период", "РегламентныеОперации");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "РегистрНакопления.ПартииРасходовНаСебестоимостьТоваров", "Период", "РегламентныеОперации");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "РегистрНакопления.ПартииТоваровОрганизаций", "Период", "РегламентныеОперации");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "РегистрНакопления.ПартииТоваровПереданныеНаКомиссию", "Период", "РегламентныеОперации");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "РегистрНакопления.ПрочиеРасходы", "Период", "РегламентныеОперации");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "РегистрНакопления.СебестоимостьТоваров", "Период", "РегламентныеОперации");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "РегистрНакопления.ТоварыКОформлениюОтчетовКомитенту", "Период", "РегламентныеОперации");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "РегистрНакопления.ТоварыОрганизаций", "Период", "РегламентныеОперации");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "РегистрНакопления.ТоварыОрганизацийКПередаче", "Период", "РегламентныеОперации");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "РегистрНакопления.ТоварыПереданныеНаКомиссию", "Период", "РегламентныеОперации");
	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
