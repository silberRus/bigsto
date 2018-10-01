﻿
&НаКлиенте
Процедура ПечатьДокумента(Команда) //печать по кнопке в режиме отладки
	
	//КартаHTML.Печать();
	Элементы.КартаHTML.Документ.parentWindow.print();
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСтрокуИнициализацииСервер()

	Возврат Константы.МегаЛогист_ПараметрыИнициализацииOSM.Получить();

КонецФункции

&НаСервере
Функция ПолучитьДополнительныеПарметры()
	
	ДополнительныеПараметры=Новый Структура;	
		
	ДополнительныеПараметры.Вставить("АдресКурьера", СокрЛП(Константы.МегаЛогист_АдресКурьера.Получить()));
	ДополнительныеПараметры.Вставить("ТипЗадания", Справочники.МегаЛогист_ТипыМаршрутныхЗаданий.ДоставкаДоКлиента);
	
	Возврат ДополнительныеПараметры

КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТаблицаАдресов.Загрузить(ПолучитьИзВременногоХранилища(Параметры.АдресТаблицыАдресов));
	Обработка = РеквизитФормыВЗначение("Объект");
	Обработка.ПутьККарте = Параметры.ПутьККарте;
	КартаHTML = Обработка.ПутьККарте;
	
	ЗначениеВРеквизитФормы(Обработка, "Объект");
	
	ЗадержкаОтправкиЗапроса = ?(Константы.МегаЛогист_ЗадержкаОтправкиЗапроса.Получить() = 0, 0.1, Константы.МегаЛогист_ЗадержкаОтправкиЗапроса.Получить());
	
КонецПроцедуры

#Область ПроцедурыПоляHTMLДокумента

&НаКлиенте
Процедура КартаHTMLДокументСформирован(Элемент)
	
	Если Не ПервыйВызов Тогда
	
		ПервыйВызов = Истина;
		Возврат;
	
	КонецЕсли; 
	
	Попытка
	    Если Не КартаИнициализирована Тогда
			
			СтрокаИнициализации = ПолучитьСтрокуИнициализацииСервер();
			МассивСтрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрокаИнициализации, ",", Истина);
			Если МассивСтрок.Количество() <> 25 Тогда
			
				Сообщить("Карта не может быть отображена. Проверьте настройки инициализации карты");
				Возврат;
			
			КонецЕсли;
			//ПЕРЕНОС
			//Элементы.КартаHTML.Документ.parentWindow.map_initialize(МассивСтрок[0], 
			//														МассивСтрок[1], 
			//														МассивСтрок[2], 
			//														МассивСтрок[3], 
			//														МассивСтрок[4], 
			//														МассивСтрок[5],
			//														МассивСтрок[6],
			//														МассивСтрок[7],
			//														МассивСтрок[8],
			//														МассивСтрок[9],
			//														МассивСтрок[10],
			//														МассивСтрок[11],
			//														МассивСтрок[12],
			//														МассивСтрок[13],
			//														МассивСтрок[14],
			//														МассивСтрок[15],
			//														МассивСтрок[16],
			//														МассивСтрок[17],
			//														МассивСтрок[18],
			//														ПолучитьИмяГеокодера());
			МегаЛогист_Служебный.Инициализация(Элементы, МассивСтрок, ПолучитьИмяГеокодера(), ПолучитьКлючАПИ());
			КартаИнициализирована = Истина;
			ПодключитьОбработчикОжидания("ЗаполнитьМаркерыНаКарте", 1, Истина);
			
		КонецЕсли;
	Исключение
	
	КонецПопытки;

	
КонецПроцедуры

&НаСервере
Функция ПолучитьКлючАПИ()

	Возврат МегаЛогист_Служебный.ПолучитьКлючАПИ();

КонецФункции

#КонецОбласти

&НаСервере 
// производится проверка переданного адреса по регистру "Сохраненные адреса"
//
// Параметры
//  Адрес - Строка
//
// Возвращаемое значение:
//   Структура   - структура возврата
//
Функция ПроверитьВнесениеАдреса(Адрес)

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	МегаЛогист_СохраненныеАдреса.Широта,
	|	МегаЛогист_СохраненныеАдреса.Долгота
	|ИЗ
	|	РегистрСведений.МегаЛогист_СохраненныеАдреса КАК МегаЛогист_СохраненныеАдреса
	|ГДЕ
	|	МегаЛогист_СохраненныеАдреса.ПредставлениеАдреса = &ПредставлениеАдреса";
	
	Запрос.УстановитьПараметр("ПредставлениеАдреса", Адрес);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		Возврат Новый Структура("Широта, Долгота", Выборка.Широта, Выборка.Долгота)
		
	Иначе
		
		Возврат Неопределено;
		
	КонецЕсли; 	

КонецФункции // ПроверитьВнесениеАдреса()

&НаКлиенте
Процедура ЗаполнитьМаркерыНаКарте()

	Для каждого СтрокаТаблицы Из ТаблицаАдресов Цикл
		
		СписокКПереносуНаКарту.Добавить(СтрокаТаблицы.ПолучитьИдентификатор());
		
	КонецЦикла;

	ПодключитьОбработчикОжидания("ЦиклПереносаНаКарту", ЗадержкаОтправкиЗапроса, Истина);
	
КонецПроцедуры

&НаКлиенте 
Процедура ЦиклПереносаНаКарту()

	Если СписокКПереносуНаКарту.Количество() > 0 Тогда
		
		Идентификатор = Число(СписокКПереносуНаКарту[0].Значение);
		СписокКПереносуНаКарту.Удалить(0);
	
	Иначе
	
		Возврат;
	
	КонецЕсли;
	
	Попытка
		
		СтрокаТаблицы = ТаблицаАдресов.НайтиПоИдентификатору(Идентификатор);
		СтруктураВозврата = ПроверитьВнесениеАдреса(СтрокаТаблицы.АдресДоставкиПриведенный);
		Если СтруктураВозврата = Неопределено Тогда
			
			//ПЕРЕНОС
			//Элементы.КартаHTML.Документ.parentWindow.map_addMarkerForAddr(
			//СтрокаТаблицы.Ид, 
			//"" + СтрокаТаблицы.АдресДоставкиПриведенный, 
			//"" + СтрокаТаблицы.ТипЗадания, 
			//"default1.png");
			МегаЛогист_Служебный.ДобавитьМаркерАдрес(Элементы, СтрокаТаблицы, СтрокаТаблицы.Ид);
			
		Иначе
			
			//ПЕРЕНОС
			//Элементы.КартаHTML.Документ.parentWindow.map_addMarkerForLocation(
			//СтрокаТаблицы.Ид,
			//"" + СтруктураВозврата.Широта,
			//"" + СтруктураВозврата.Долгота,
			//"" + СтрокаТаблицы.АдресДоставкиПриведенный, 
			//"" + СтрокаТаблицы.ТипЗадания, 
			//"default1.png");
			МегаЛогист_Служебный.ДобавитьМаркерЛокация(Элементы, СтруктураВозврата, СтрокаТаблицы, СтрокаТаблицы.Ид); 
			
		КонецЕсли;
				
		//Добавим курьера
		Если СписокКПереносуНаКарту.Количество()=0 тогда
			ДополнительныеПараметры=ПолучитьДополнительныеПарметры();
			АдресКурьера=ДополнительныеПараметры.АдресКурьера;
		
			Если ЗначениеЗаполнено(АдресКурьера) тогда
				//ПЕРЕНОС
				//Элементы.КартаHTML.Документ.parentWindow.map_addMarkerForAddr(
				//	"", 
				//	"" + АдресКурьера, 
				//	"" + ДополнительныеПараметры.ТипЗадания, 
				//	"default3.png");
				МегаЛогист_Служебный.ДобавитьМаркерКурьера(Элементы, АдресКурьера, ДополнительныеПараметры); 
			КонецЕсли;		
		КонецЕсли;	
	Исключение
		
		Сообщить("Ошибка: " + ОписаниеОшибки());
		
	КонецПопытки;
	
	ПодключитьОбработчикОжидания("ЦиклПереносаНаКарту", ЗадержкаОтправкиЗапроса, Истина);

КонецПроцедуры

&НаСервере 
Функция ПолучитьИмяГеокодера()
	
	Обработка = РеквизитФормыВЗначение("Объект");
	Возврат Обработка.ПолучитьИмяГеокодера()

КонецФункции
