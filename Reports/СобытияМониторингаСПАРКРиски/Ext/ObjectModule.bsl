﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	// 1. Обновить события мониторинга.
	Если СПАРКРиски.ИспользованиеСПАРКРискиВключено() Тогда
		ВидОшибки = СПАРКРискиМониторингСобытий.ОбновитьСобытияМониторинга();
	Иначе
		ВидОшибки = Перечисления.ВидыОшибокСПАРКРиски.ИспользованиеОтключено;
	КонецЕсли;
	
	Если Не ВидОшибки.Пустая() Тогда
		
		Макет = ПолучитьМакет("ОписаниеОшибок");
		ВидыОшибок = Перечисления.ВидыОшибокСПАРКРиски;
		Если ВидОшибки = ВидыОшибок.ИнтернетПоддержкаНеПодключена Тогда
			Если Пользователи.ЭтоПолноправныйПользователь(, Истина, Ложь) Тогда
				ИмяОбласти = "ИППНеПодключена";
			Иначе
				ИмяОбласти = "ИППНеПодключенаОбычныйПользователь";
			КонецЕсли;
		ИначеЕсли ВидОшибки = ВидыОшибок.ТребуетсяОплатаИлиПревышенЛимит Тогда
			ИмяОбласти = "СервисНеПодключен";
		ИначеЕсли ВидОшибки = ВидыОшибок.ВнутренняяОшибкаСервиса Тогда
			ИмяОбласти = "СервисНедоступен";
		ИначеЕсли ВидОшибки = ВидыОшибок.ОшибкаПодключения Тогда
			Если Пользователи.ЭтоПолноправныйПользователь(, Истина, Ложь) Тогда
				ИмяОбласти = "ОшибкаПодключения";
			Иначе
				ИмяОбласти = "ОшибкаПодключенияОбычныйПользователь";
			КонецЕсли;
		ИначеЕсли ВидОшибки = ВидыОшибок.ИспользованиеОтключено Тогда
			Если Пользователи.ЭтоПолноправныйПользователь(, Истина, Ложь) Тогда
				ИмяОбласти = "ИспользованиеСервисаОтключено";
			Иначе
				ИмяОбласти = "ИспользованиеСервисаОтключеноОбычныйПользователь";
			КонецЕсли;
		ИначеЕсли ВидОшибки = ВидыОшибок.ОшибкаАутентификации Тогда
			Если Пользователи.ЭтоПолноправныйПользователь(, Истина, Ложь) Тогда
				ИмяОбласти = "ОшибкаАутентификации";
			Иначе
				ИмяОбласти = "ОшибкаАутентификацииОбычныйПользователь";
			КонецЕсли;
		Иначе
			ИмяОбласти = "НеизвестнаяОшибка";
		КонецЕсли;
		
		Область = Макет.ПолучитьОбласть(ИмяОбласти);
		Если ИмяОбласти = "СервисНеПодключен" Тогда
			Область.Параметры.АдресОписаниеСервиса = СПАРКРискиКлиентСервер.АдресСтраницыОписанияСервисаСПАРКРиски();
		КонецЕсли;
		
		ДокументРезультат.Вывести(Область);
		Возврат;
		
	КонецЕсли;
	
	// 2. Формирование запроса.
	Запросы = Новый Массив;
	ТекстЗапроса = СхемаКомпоновкиДанных.НаборыДанных.СобытияМониторинга.Запрос;
	ПозицияШаблон = СтрНайти(ТекстЗапроса, "//# Начало запроса");
	
	Запросы.Добавить(Лев(ТекстЗапроса, ПозицияШаблон - 1));
	ШаблонЗапроса = Сред(ТекстЗапроса, ПозицияШаблон + 19);
	
	СправочникиКонтрагенты = СПАРКРиски.СвойстваСправочниковКонтрагентов();
	
	ДобавитьОбъединить = Ложь;
	Для Каждого ОписаниеСправочника Из СправочникиКонтрагенты Цикл
		
		Если ДобавитьОбъединить Тогда
			Запросы.Добавить("ОБЪЕДИНИТЬ ВСЕ");
			ШаблонЗапроса = СтрЗаменить(ШаблонЗапроса, "РАЗРЕШЕННЫЕ", "");
		КонецЕсли;
		
		ТекстЗапроса =
			СтрЗаменить(
				ШаблонЗапроса,
				"%ИмяСправочникаКонтрагенты",
				ОписаниеСправочника.Имя);
		
		ТекстЗапроса =
			СтрЗаменить(
				ТекстЗапроса,
				"//#",
				"");
		
		Запросы.Добавить(ТекстЗапроса);
		
		ДобавитьОбъединить = Истина;
		
	КонецЦикла;
	
	СхемаКомпоновкиДанных.НаборыДанных.СобытияМониторинга.Запрос =
		СтрСоединить(Запросы, Символы.ПС);
	
	// 3. Вывод результата.
	ДокументРезультат.Очистить();
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(ЭтотОбъект.СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.ВыводитьСуммуВыделенныхЯчеек                         = Ложь;
	Настройки.События.ПередЗагрузкойВариантаНаСервере              = Истина;
	Настройки.События.ПриОпределенииПараметровВыбора               = Истина;
	Настройки.События.ПриЗагрузкеПользовательскихНастроекНаСервере = Истина;
	
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   НовыеНастройкиКД - НастройкиКомпоновкиДанных - Настройки для загрузки в компоновщик настроек.
//
// См. также:
//   "Расширение управляемой формы для отчета.ПередЗагрузкойВариантаНаСервере" в синтакс-помощнике.
//   ОтчетыПереопределяемый.ПередЗагрузкойВариантаНаСервере().
//
Процедура ПередЗагрузкойВариантаНаСервере(Форма, НовыеНастройкиКД) Экспорт
	
	СПАРКРиски.ПередЗагрузкойВариантаНаСервере(Форма, НовыеНастройкиКД);
	
КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПриЗагрузкеВариантаНаСервере
//
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Форма, НовыеНастройкиКД) Экспорт
	
	Если Форма.КлючНазначенияИспользования = "ТекущиеДела" Тогда
		КомпоновщикНастроекФормы = Форма.Отчет.КомпоновщикНастроек;
		Для Каждого Элемент Из КомпоновщикНастроекФормы.ПользовательскиеНастройки.Элементы Цикл
			Элемент.Использование = Ложь;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// Вызывается в форме отчета перед выводом настройки.
//
// Параметры:
//   Форма - УправляемаяФорма, Неопределено - Форма отчета.
//   СвойстваНастройки - Структура - Описание настройки отчета, которая будет выведена в форме отчета.
//       * ОписаниеТипов - ОписаниеТипов -
//           Тип настройки.
//       * ЗначенияДляВыбора - СписокЗначений -
//           Объекты, которые будут предложены пользователю в списке выбора.
//           Дополняет список объектов, уже выбранных пользователем ранее.
//       * ЗапросЗначенийВыбора - Запрос -
//           Возвращает объекты, которыми необходимо дополнить ЗначенияДляВыбора.
//           Первой колонкой (с 0м индексом) должен выбираться объект,
//           который следует добавить в ЗначенияДляВыбора.Значение.
//           Для отключения автозаполнения
//           в свойство ЗапросЗначенийВыбора.Текст следует записать пустую строку.
//       * ОграничиватьВыборУказаннымиЗначениями - Булево -
//           Когда Истина, то выбор пользователя будет ограничен значениями,
//           указанными в ЗначенияДляВыбора (его конечным состоянием).
//
// См. также:
//   ОтчетыПереопределяемый.ПриОпределенииПараметровВыбора().
//
Процедура ПриОпределенииПараметровВыбора(Форма, СвойстваНастройки) Экспорт
	Если СвойстваНастройки.ОписаниеТипов.СодержитТип(Тип("СправочникСсылка.ТипыСобытийСПАРКРиски")) Тогда
		СвойстваНастройки.ЗапросЗначенийВыбора.Текст = "";
		СвойстваНастройки.ОграничиватьВыборУказаннымиЗначениями = Ложь;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецЕсли
