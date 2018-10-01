﻿
#Область ОбработчикиСобытийФормы
 
&НаКлиенте
Процедура РазрешитьРедактирование(Команда)
	
	Результат = Новый Массив;
	
	Если РазрешитьРедактированиеГоловнаяОрганизация Или Не ОбособленноеПодразделение Тогда
		Результат.Добавить("ГоловнаяОрганизация");
	КонецЕсли;
	
	Закрыть(Результат);
	
КонецПроцедуры // РазрешитьРедактирование()

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбособленноеПодразделение = Параметры.ОбособленноеПодразделение;
	
	Элементы.ГруппаГоловнаяОрганизация.Видимость = Параметры.ОбособленноеПодразделение;
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти
