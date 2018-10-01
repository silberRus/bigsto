﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Файл = Параметры.ФайлСсылка;
	КомментарийКВерсии = Параметры.КомментарийКВерсии;
	СоздатьНовуюВерсию = Параметры.СоздатьНовуюВерсию;
	Элементы.СоздатьНовуюВерсию.Доступность = Параметры.СоздатьНовуюВерсиюДоступность;
	
	Если Файл.ХранитьВерсии Тогда
		СоздатьНовуюВерсию = Истина;
	Иначе
		СоздатьНовуюВерсию = Ложь;
		Элементы.СоздатьНовуюВерсию.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сохранить(Команда)
	
	СтруктураВозврата = Новый Структура("КомментарийКВерсии, СоздатьНовуюВерсию, КодВозврата",
		КомментарийКВерсии, СоздатьНовуюВерсию, КодВозвратаДиалога.ОК);
	
	Закрыть(СтруктураВозврата);
	
	Оповестить("РаботаСФайлами_ЗаписанаНоваяВерсияФайла");
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	СтруктураВозврата = Новый Структура("КомментарийКВерсии, СоздатьНовуюВерсию, КодВозврата",
		КомментарийКВерсии, СоздатьНовуюВерсию, КодВозвратаДиалога.Отмена);
	
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

#КонецОбласти