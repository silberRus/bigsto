﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;	
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьДокументами(Команда)
	ЗаполнитьДокументамиНаСервере();
КонецПроцедуры

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьДокументамиНаСервере()
	
	СхемаКомпоновкиДанных = Документы.СТ_ВозвратыИзОтветственногоХранения.ПолучитьМакет("ОтборДокументов");

    //создадим компоновщик настроек и загрузим настройки по умолчанию, вместо настроек по умолчанию можно использовать восстановленные настройки
    КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных();
    КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
    КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
    Настройки = КомпоновщикНастроек.Настройки;
    
    Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("НачалоПериода", Объект.НачалоПериода);
    Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ОкончаниеПериода", Объект.ОкончаниеПериода);
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ТекущийДокумент", Объект.Ссылка);

	СтруктураОтборов = Новый Структура();
	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		СтруктураОтборов.Вставить("Организация", Объект.Организация);	
	КонецЕсли; 
	Если ЗначениеЗаполнено(Объект.Склад) Тогда
		СтруктураОтборов.Вставить("Склад", Объект.Склад);	
	КонецЕсли; 
	ОтчетыСервер.УстановитьФиксированныеОтборы(СтруктураОтборов, Настройки, Неопределено);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;	
    МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки,,, Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));

    ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
    ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки);
	ПроцессорВывода	= Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ОтборДокументов	= ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
	Объект.ДокументыНаПечать.Загрузить(ОтборДокументов); ;
	
КонецПроцедуры

#КонецОбласти