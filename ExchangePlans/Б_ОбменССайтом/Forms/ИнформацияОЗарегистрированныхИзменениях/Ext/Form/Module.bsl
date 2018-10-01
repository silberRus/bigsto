﻿
#Область ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПриЧтенииСозданииНаСервере(Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УзелОбмена = Параметры.УзелОбмена;
	
	Если УзелОбмена.ЭтотУзел Тогда
		
		Отказ = Истина;
		Возврат;
		
	КонецЕсли;
	
	ОбновитьДеревоИзмененийСервер();

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ДеревоИзменений.ПолучитьЭлементы().Количество() = 0 Тогда
		
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Изменения не зарегистрированы.'")
			,,,
			БиблиотекаКартинок.Информация32);
			
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормы
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ТАБЛИЦЫ ФОРМЫ "Дерево изменений"

&НаКлиенте
Процедура ДеревоОбъектНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
&НаКлиенте
Процедура ДеревоОбъектОчистка(Элемент, СтандартнаяОбработка)
	
	Родитель = Элементы.ДеревоИзменений.ТекущиеДанные.ПолучитьРодителя();
	
	Если Родитель = НеОпределено Тогда
		Возврат;
	КонецЕсли;

	УдалитьРегистрациюСервер(Элементы.ДеревоИзменений.ТекущиеДанные.Объект);
	Родитель.ПолучитьЭлементы().Удалить(Элементы.ДеревоИзменений.ТекущиеДанные);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьРегистрациюСервер(ДанныеСсылка)
	
	ПланыОбмена.УдалитьРегистрациюИзменений(УзелОбмена, ДанныеСсылка);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Обновить(Команда)
	ОбновитьДеревоИзмененийСервер();
КонецПроцедуры

&НаСервере
Процедура ОбновитьДеревоИзмененийСервер()
	
	СтруктураИзменений = Новый Структура;
	ПланыОбмена.Б_ОбменССайтом.ЗаполнитьСтруктуруИзмененийДляУзла(УзелОбмена, СтруктураИзменений);
	
	СтрокиДерева = ДеревоИзменений.ПолучитьЭлементы();
	СтрокиДерева.Очистить();
	
	Если СтруктураИзменений.Товары.Количество() > 0 Тогда
		
		СтрокаДерева = СтрокиДерева.Добавить();
		СтрокаДерева.ВидОбъекта = НСтр("ru = 'Товары'");
	
		Для Каждого ЭлементМассива Из СтруктураИзменений.Товары Цикл
			СтрокаОбъекта = СтрокаДерева.ПолучитьЭлементы().Добавить();
			СтрокаОбъекта.Объект = ЭлементМассива;
		КонецЦикла;
		
	КонецЕсли;
	
	Если СтруктураИзменений.Свойства.Количество() > 0 Тогда
		
		СтрокаДерева = СтрокиДерева.Добавить();
		СтрокаДерева.ВидОбъекта = НСтр("ru = 'Свойства'");
	
		Для Каждого ЭлементМассива Из СтруктураИзменений.Свойства Цикл
			СтрокаОбъекта = СтрокаДерева.ПолучитьЭлементы().Добавить();
			СтрокаОбъекта.Объект = ЭлементМассива;
		КонецЦикла;
		
	КонецЕсли;   	
	
	Если СтруктураИзменений.ФайлыНоменклатуры.Количество() > 0 Тогда
		
		СтрокаДерева = СтрокиДерева.Добавить();
		СтрокаДерева.ВидОбъекта = НСтр("ru = 'ФайлыНоменклатуры'");
		
		Для Каждого ЭлементМассива Из СтруктураИзменений.ФайлыНоменклатуры Цикл
			СтрокаОбъекта = СтрокаДерева.ПолучитьЭлементы().Добавить();
			СтрокаОбъекта.Объект = ЭлементМассива;
		КонецЦикла;
		
	КонецЕсли;
	
	Если СтруктураИзменений.Файлы.Количество() > 0 Тогда

		СтрокаДерева = СтрокиДерева.Добавить();
		СтрокаДерева.ВидОбъекта = НСтр("ru = 'Файлы'");
		
		Для Каждого ЭлементМассива Из СтруктураИзменений.Файлы Цикл
			СтрокаОбъекта = СтрокаДерева.ПолучитьЭлементы().Добавить();
			СтрокаОбъекта.Объект = ЭлементМассива;
		КонецЦикла;
		
	КонецЕсли;
	
	Если СтруктураИзменений.Контрагенты.Количество() > 0 Тогда
		
		СтрокаДерева = СтрокиДерева.Добавить();
		СтрокаДерева.ВидОбъекта = НСтр("ru = 'Контрагенты'");
		
		Для Каждого ЭлементМассива Из СтруктураИзменений.Контрагенты Цикл
			СтрокаОбъекта = СтрокаДерева.ПолучитьЭлементы().Добавить();
			СтрокаОбъекта.Объект = ЭлементМассива;
		КонецЦикла;
		
	КонецЕсли;
	
	Если СтруктураИзменений.Партнеры.Количество() > 0 Тогда
		
		СтрокаДерева = СтрокиДерева.Добавить();
		СтрокаДерева.ВидОбъекта = НСтр("ru = 'Партнеры'");
		
		Для Каждого ЭлементМассива Из СтруктураИзменений.Партнеры Цикл
			СтрокаОбъекта = СтрокаДерева.ПолучитьЭлементы().Добавить();
			СтрокаОбъекта.Объект = ЭлементМассива;
		КонецЦикла;
		
	КонецЕсли;
	
	Если СтруктураИзменений.Заказы.Количество() > 0 Тогда
		
		СтрокаДерева = СтрокиДерева.Добавить();
		СтрокаДерева.ВидОбъекта = НСтр("ru = 'Заказы'");
		
		Для Каждого ЭлементМассива Из СтруктураИзменений.Заказы Цикл
			СтрокаОбъекта = СтрокаДерева.ПолучитьЭлементы().Добавить();
			СтрокаОбъекта.Объект = ЭлементМассива;
		КонецЦикла;
		
	КонецЕсли;
	
	Если СтруктураИзменений.Отгрузки.Количество() > 0 Тогда
		
		СтрокаДерева = СтрокиДерева.Добавить();
		СтрокаДерева.ВидОбъекта = НСтр("ru = 'Отгрузки'");
		
		Для Каждого ЭлементМассива Из СтруктураИзменений.Отгрузки Цикл
			СтрокаОбъекта = СтрокаДерева.ПолучитьЭлементы().Добавить();
			СтрокаОбъекта.Объект = ЭлементМассива;
		КонецЦикла;
		
	КонецЕсли;
	
	Если СтруктураИзменений.ПКО.Количество() > 0 Тогда
		
		СтрокаДерева = СтрокиДерева.Добавить();
		СтрокаДерева.ВидОбъекта = НСтр("ru = 'ПКО'");
		
		Для Каждого ЭлементМассива Из СтруктураИзменений.ПКО Цикл
			СтрокаОбъекта = СтрокаДерева.ПолучитьЭлементы().Добавить();
			СтрокаОбъекта.Объект = ЭлементМассива;
		КонецЦикла;
		
	КонецЕсли;
	
	Если СтруктураИзменений.ОплатаПоПлатежнойКарте.Количество() > 0 Тогда
		
		СтрокаДерева = СтрокиДерева.Добавить();
		СтрокаДерева.ВидОбъекта = НСтр("ru = 'Оплата по платежной карте'");
		
		Для Каждого ЭлементМассива Из СтруктураИзменений.ОплатаПоПлатежнойКарте Цикл
			СтрокаОбъекта = СтрокаДерева.ПолучитьЭлементы().Добавить();
			СтрокаОбъекта.Объект = ЭлементМассива;
		КонецЦикла;
		
	КонецЕсли;
	
	Если СтруктураИзменений.ОплатаПоБезналу.Количество() > 0 Тогда
		
		СтрокаДерева = СтрокиДерева.Добавить();
		СтрокаДерева.ВидОбъекта = НСтр("ru = 'Оплата по безналу'");
		
		Для Каждого ЭлементМассива Из СтруктураИзменений.ОплатаПоБезналу Цикл
			СтрокаОбъекта = СтрокаДерева.ПолучитьЭлементы().Добавить();
			СтрокаОбъекта.Объект = ЭлементМассива;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

