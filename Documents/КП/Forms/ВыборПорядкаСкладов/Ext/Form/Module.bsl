﻿
&НаСервере
Функция ПроверитьРазрешенностьСкладов()
	
	Запрос = Новый Запрос("ВЫБРАТЬ Ссылка ИЗ Справочник.Склады ГДЕ НЕ АТ_РазрешитьВКП И Ссылка В(&Склады)");
	Запрос.УстановитьПараметр("Склады", СписокСкладов);
	СкладыПлохие = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	Bad = СкладыПлохие.Количество();
	Если Bad Тогда
		Сообщить(СтрШаблон("Запрещен%1 склад%1 в КП: %2", ?(Bad = 1, "", "ы"),  СтрСоединить(СкладыПлохие, ",")));
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура Ок(Команда)
	
	Если ПроверитьРазрешенностьСкладов() Тогда
		Закрыть(СписокСкладов);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СписокСкладов = Параметры.СписокСкладов;
	
КонецПроцедуры
