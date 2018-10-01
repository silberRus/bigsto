﻿
&НаКлиенте
Процедура Активировать(Отказ)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("vid", Элементы.ПоставщикКод.ТекстРедактирования);
	СтруктураПараметров.Вставить("bid", Элементы.ФилиалКод.ТекстРедактирования);
	СтруктураПараметров.Вставить("login", Объект.Логин);
	СтруктураПараметров.Вставить("password", Объект.Пароль);
	СтруктураПараметров.Вставить("parameters", Объект.ДопПараметрыАвторизации);
	
	Код = QWEP_Клиент.ПолучитьКодАктивированногоАккаунта(СтруктураПараметров);
	Если НЕ ЗначениеЗаполнено(Код) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	Объект.Код = Код;
	Объект.Включен = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ЭтоНовый Тогда
		Активировать(Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоставщикФилиалПриИзменении(Элемент)
	
	Объект.Наименование = Строка(Объект.Поставщик) + Строка(Объект.Филиал);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭтоНовый = НЕ ЗначениеЗаполнено(Объект.Ссылка);
	
КонецПроцедуры
