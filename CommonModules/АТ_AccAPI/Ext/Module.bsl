﻿Функция ПолучитьОстаткиGET(Запрос, ЭтоОтладка = Ложь) Экспорт
	
	Перем Ответ;
	
	Ответ = ВернутьОтвет(Новый Структура("КодОтвета, Тело", , "Пользователь не активирован."), ЭтоОтладка);
	
	Возврат Ответ;
	
КонецФункции


Функция Записать(ОбъектЗаписи, стрОшибки = "", ДопСвойство = Неопределено)
	
	// Возвращает истина если удалось записать и ложь если не
	// стрОшибки - сюда помещается текст ошибки
	
	Попытка
		Если ДопСвойство = Неопределено Тогда
			ОбъектЗаписи.Записать();
		Иначе
			ОбъектЗаписи.Записать(ДопСвойство);
		КонецЕсли;
	Исключение
		стрОшибки = "Ошибка при записи: " + ОписаниеОшибки();
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции
Функция ВернутьОтвет(Параметры, ЭтоОтладка, ТелоВJSON = Истина)
	
	Если ЭтоОтладка Тогда
		Возврат Параметры;
	Иначе
		
		Ответ = АТ_WI_Кеш.Ответ();
		
		Если Параметры.Свойство("КодОтвета") И Параметры.КодОтвета <> 200 Тогда
			Ответ.КодСостояния = Параметры.КодОтвета;
		КонецЕсли;
		
		Если Параметры.Свойство("Тело") Тогда
			Ответ.УстановитьТелоИзСтроки(?(ТелоВJSON, w1_Json.JSON36(Параметры.Тело), Параметры.Тело), КодировкаТекста.UTF8);
		КонецЕсли;
		
		Возврат ?(ЭтоОтладка, 
					Новый Структура("КодСостояния, Тело", Ответ.КодСостояния, АТ_ОбщегоНазначения.Параметр(Параметры, "Тело")), 
					Ответ);
	КонецЕсли;
	
КонецФункции
