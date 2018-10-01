﻿////////////////////////////////////////////////////////////////////////////////
// УПРАВЛЕНИЕ ФОРМОЙ

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТКА СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТКА СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МенеджерЗаписи = ЭтотОбъект.РеквизитФормыВЗначение("Запись");
	
	ДанныеЗаполнения = Новый Структура("Пользователь, КатегорияБазыЗнаний");
	Если НЕ Параметры.Свойство("Пользователь") Тогда
		Отказ = Истина;
	КонецЕсли;
	Если НЕ Параметры.Свойство("КатегорияБазыЗнаний") Тогда
		Отказ = Истина;
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ДанныеЗаполнения, Параметры);
	
	МенеджерЗаписи.Пользователь			= ДанныеЗаполнения.Пользователь;
	МенеджерЗаписи.КатегорияБазыЗнаний	= ДанныеЗаполнения.КатегорияБазыЗнаний;
	МенеджерЗаписи.Прочитать();
	ЭтотОбъект.ЗначениеВРеквизитФормы(МенеджерЗаписи, "Запись");
	
	Если НЕ ЗначениеЗаполнено(Запись.Пользователь)
		ИЛИ НЕ ЗначениеЗаполнено(Запись.КатегорияБазыЗнаний) Тогда
		ЗаполнитьЗначенияСвойств(Запись, ДанныеЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
		
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	ПриЗакрытииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
	УдалитьЗапись = Истина;
	Для Каждого МетаРесурс Из Метаданные.РегистрыСведений.ИзбранноеБазыЗнаний.Ресурсы Цикл
		Если Запись[МетаРесурс.Имя] Тогда
			УдалитьЗапись = Ложь;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если УдалитьЗапись Тогда
		МенеджерЗаписи = ЭтотОбъект.РеквизитФормыВЗначение("Запись");
		Если МенеджерЗаписи.Выбран() Тогда
			МенеджерЗаписи.Удалить();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТКА КОМАНД ФОРМЫ

&НаКлиенте
Процедура УстановитьПометки(Команда)
	
	ЗначениеПометки = (Команда.Имя = "ПометитьВсе");
	
	Запись.Создание		= ЗначениеПометки;
	Запись.Изменение	= ЗначениеПометки;
	Запись.Удаление		= ЗначениеПометки;
	Запись.Оповещение	= ЗначениеПометки;
	Запись.Прочее		= ЗначениеПометки;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБЩИЕ МЕТОДЫ

